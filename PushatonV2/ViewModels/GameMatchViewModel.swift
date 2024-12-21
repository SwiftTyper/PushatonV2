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
    
    func startMatch(playerId: String) async {
        do {
            if let existingGame = try await getQueuedGames() {
                try await joinGame(id: existingGame.id, playerId: playerId)
                self.game = existingGame
            } else {
                self.game = try await createGame(playerId: playerId)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func joinGame(id: String, playerId: String) async throws {
        
    }
    
    func createGame(playerId: String) async throws -> Game {
        let game = Game(
            id: UUID().uuidString,
            player1Id: playerId,
            status: .waiting
        )
        let result = try await Amplify.API.mutate(request: .create(game))
        return try result.get()
    }
    
    func getQueuedGames() async throws -> Game? {
        let predicate = QueryPredicateOperation(field: "status", operator: .equals(GameStatus.waiting as? Persistable))
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
}
