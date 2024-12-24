//
//  GameViewModel.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 13/12/2024.
//

import Foundation
import Observation
import Amplify

@MainActor
@Observable
class GameMatchViewModel {
    var game: Game? = nil
    var games: [Game] = []
    var subscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Game>>?
    
    deinit {
        Task {
            await self.cancelSubscription()
        }
    }
    
    func startMatch(playerId: String) async {
        do {
            if let existingGame = try await getQueuedGame() {
                self.game = try await joinGame(existingGame, playerId: playerId)
            } else {
                self.game = try await createGame(playerId: playerId)
            }
            createSubscription()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func cancelSubscription() {
        subscription?.cancel()
    }
    
    private func createSubscription() {
        subscription = Amplify.API.subscribe(request: .subscription(of: Game.self, type: .onUpdate))
        guard let subscription = subscription else { return }
        Task {
            do {
                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                            case .success(let updatedGame):
                                print("Successfully got todo from subscription: \(updatedGame)")
                                self.game = updatedGame
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
    
    private func joinGame(_ game: Game, playerId: String) async throws -> Game {
        var game = game
        game.player2Id = playerId
        game.status = .playing
        
        let result = try await Amplify.API.query(request: .update(game))
        return try result.get()
    }
    
    private func createGame(playerId: String) async throws -> Game {
        let game = Game(
            id: UUID().uuidString,
            player1Id: playerId,
            status: .waiting
        )
        let result = try await Amplify.API.mutate(request: .create(game))
        return try result.get()
    }
    
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
    
    func listGames() async throws -> [Game] {
        let result = try await Amplify.API.query(request: .list(Game.self))
        return try result.get().elements
    }
    
    func clearGames() async {
        do {
            // First get all games
            let games = try await Amplify.API.query(request: .list(Game.self))
            let gameList = try games.get()
            
            // Delete each game
            for game in gameList {
                _ = try await Amplify.API.mutate(request: .delete(game))
                print("Deleted game with ID: \(game.id)")
            }
            
        } catch {
            print("Error clearing games: \(error)")
        }
    }
}
