//
//  GameViewModel.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 13/12/2024.
//

import Foundation
import Observation
import Amplify

@Observable
class GameMatchViewModel {
    var game: Game? = nil { willSet { continuation.yield(newValue) } }
    var games: [Game] = []
    
    var isLoading: Bool = false
    var showCameraOverlay: Bool = false

    var gameSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Game>>?
    let (gameStream, continuation) = AsyncStream.makeStream(of: Game?.self)
    
    deinit {
        continuation.finish()
        
        Task { @MainActor [weak self] in
            self?.cancelSubscription()
        }
    }
    
    @MainActor
    func startMatch(playerId: String, createOpponentSubscriptionAction: @escaping (String) -> Void) async {
        do {
            isLoading = true
            if let existingGame = try await getQueuedGame() {
                self.game = try await joinGame(existingGame, playerId: playerId)
                createOpponentSubscriptionAction(self.game?.player1Id ?? "")
            } else {
                self.game = try await createGame(playerId: playerId)
            }
            createGameSubscription(createOpponentSubscriptionAction: createOpponentSubscriptionAction)
            isLoading = false
        } catch {
            isLoading = false
            print(error.localizedDescription)
        }
    }

    @MainActor
    func lost(player: Player?, opponent: Player?) async {
        do {
            guard var game = game, let player = player, let opponent = opponent else { return }
            guard game.status != .finished else { return }
       
            if player.isPlayerAlive == false && opponent.isPlayerAlive == false {
                if player.score > opponent.score {
                    game.winner = player.username
                } else if player.score == opponent.score {
                    game.winner = nil
                } else {
                    game.winner = opponent.username
                }
                game.status = .finished
            } else if (player.isPlayerAlive == true && opponent.isPlayerAlive == false) && (player.score > opponent.score) {
                game.winner = player.username
                game.status = .finished
            } else if (player.isPlayerAlive == false && opponent.isPlayerAlive == true) && (player.score < opponent.score) {
                game.winner = opponent.username
                game.status = .finished
            }
            
            print("OPPONENT")
            print(opponent)
            
            print("PLAYER")
            print(player)
            
            print("GAME")
            print(game)
            
            _ = try await Amplify.API.mutate(request: .update(game))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getGameResult(playerId: String) -> GameResult {
        guard let winner = game?.winner else { return .tie }
        return winner == playerId ? .won : .lost
    }
    
    func cancelSubscription() {
        gameSubscription?.cancel()
    }
    
    private func createGameSubscription(createOpponentSubscriptionAction: @escaping (String) -> Void) {
        gameSubscription = Amplify.API.subscribe(request: .subscription(of: Game.self, type: .onUpdate))
        guard let subscription = gameSubscription else { return }
        Task {
            do {
                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                        case .connection(_): break
                        case .data(let result):
                            switch result {
                                case .success(let updatedGame):
                                    if updatedGame.id == game?.id {
                                        print("Successfully got todo from subscription:")
                                        
                                        if game?.player2Id == nil && updatedGame.player2Id != nil {
                                            createOpponentSubscriptionAction(updatedGame.player2Id ?? "")
                                            print("created subscription with \(updatedGame.player2Id ?? "")")
                                        }
                                        
                                        self.game = updatedGame
                                    }
                                case .failure(let error):
                                    print("Got failed result with \(error.errorDescription)")
                            }
                        }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }
    
    @MainActor
    private func joinGame(_ game: Game, playerId: String) async throws -> Game {
        var game = game
        game.player2Id = playerId
        game.status = .playing
        
        let result = try await Amplify.API.mutate(request: .update(game))
        return try result.get()
    }
    
    @MainActor
    private func createGame(playerId: String) async throws -> Game {
        let numberOfObstacles = 80
        var obstacles: [ObstacleData] = []
      
        for _ in 0..<numberOfObstacles {
            let isLowObstacle = Bool.random()
            let coin = Coin.getRandomArrangement(isLow: isLowObstacle)
            let obstacle = ObstacleData(
                isLow: isLowObstacle,
                coinArrangement: coin.0,
                coinValue: coin.1
            )
            obstacles.append(obstacle)
        }
        
        let game = Game(
            id: UUID().uuidString,
            player1Id: playerId,
            status: .waiting,
            obstacles: obstacles
        )
        
        let result = try await Amplify.API.mutate(request: .create(game))
        return try result.get()
    }
    
    @MainActor
    private func getQueuedGame() async throws -> Game? {
        let predicate = QueryPredicateOperation(field: "status", operator: .equals(GameStatus.waiting.rawValue))
        let request = GraphQLRequest<Game>.list(
            Game.self,
            where: predicate,
            limit: 1
        )
        let result = try await Amplify.API.query(request: request)
        return try result.get().elements.first
    }
}

//MARK: Debug
extension GameMatchViewModel {
    func leaveGame() {
        
    }
    
    @MainActor
    func listGames() async {
        do {
            let result = try await Amplify.API.query(request: .list(Game.self))
            games = try result.get().elements
        } catch let error as GraphQLResponseError<List<PushatonV2.Game>>{
            print(error.debugDescription)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func clearGames() async {
        do {
            let games = try await Amplify.API.query(request: .list(Game.self))
            let gameList = try games.get()
            
            for game in gameList {
                _ = try await Amplify.API.mutate(request: .delete(game))
                print("Deleted game with ID: \(game.id)")
            }
        } catch {
            print("Error clearing games: \(error)")
        }
    }
}
