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

    var gameSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Game>>?
    let (gameStream, continuation) = AsyncStream.makeStream(of: Game?.self)
    
    deinit {
        continuation.finish()
        
        Task { @MainActor [weak self] in
            self?.cancelSubscription()
        }
    }
    
    @MainActor
    func startMatch(playerId: String) async {
        do {
            if let existingGame = try await getQueuedGame() {
                self.game = try await joinGame(existingGame, playerId: playerId)
            } else {
                self.game = try await createGame(playerId: playerId)
            }
            createGameSubscription()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateScore(playerId: String) -> Int {
        if playerId == game?.player1Id {
            game?.player1Score += 1
            return game?.player1Score ?? 0
        } else if playerId == game?.player2Id {
            game?.player2Score += 1
            return game?.player2Score ?? 0
        }
        return 0
    }
    
    @MainActor
    func lost(playerId: String) async {
        do {
            guard var game = game else { return }
            guard game.status != .finished else { return }
            
            if playerId == game.player1Id {
                game.isPlayer1Alive = false
            } else if playerId == game.player2Id {
                game.isPlayer2Alive = false
            }
            
            if game.isPlayer1Alive == false && game.isPlayer2Alive == false {
                if game.player1Score > game.player2Score {
                    game.winner = game.player1Id
                } else if game.player1Score == game.player2Score {
                    game.winner = nil
                } else {
                    game.winner = game.player2Id
                }
                game.status = .finished
            } else if game.isPlayer1Alive == true && game.isPlayer2Alive == false {
                if game.player1Score > game.player2Score {
                    game.winner = game.player1Id
                    game.status = .finished
                }
            } else if game.isPlayer1Alive == false && game.isPlayer2Alive == true {
                if game.player2Score > game.player1Score {
                    game.winner = game.player2Id
                    game.status = .finished
                }
            }
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
    
    @MainActor
    private func createGameSubscription() {
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
                                        print("Successfully got todo from subscription: \(updatedGame)")
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
        
        let result = try await Amplify.API.query(request: .update(game))
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
            player1Score: 0,
            player2Score: 0,
            isPlayer1Alive: true,
            isPlayer2Alive: true,
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
