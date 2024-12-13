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
class GameViewModel {
    var games: [Game] = []
    
    func deleteGames(indexSet: IndexSet) async {
        for index in indexSet {
            do {
                let game = games[index]
                let result = try await Amplify.API.mutate(request: .delete(game))
                switch result {
                case .success(let game):
                    print("Successfully deleted todo: \(game)")
                    games.remove(at: index)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to deleted todo: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func removeGame() async {
        
    }
    
    func createGame() async {
        let creationTime = Temporal.DateTime.now()
        let game = Game(
            id: UUID().uuidString,
            player1Id: UUID().uuidString,
            player2Id: UUID().uuidString,
            player1Score: 23,
            player2Score: 35,
            status: .playing,
            lastUpdateTime: .now()
        )
        do {
            let result = try await Amplify.API.mutate(request: .create(game))
            switch result {
            case .success(let todo):
                print("Successfully created todo: \(todo)")
                games.append(game)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create todo: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func listGames() async {
        let request = GraphQLRequest<Game>.list(Game.self)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let games):
                print("Successfully retrieved list of todos: \(games)")
                self.games = games.elements
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query list of todos: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

