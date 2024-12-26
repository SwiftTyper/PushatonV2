//
//  PlayerManager.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 21/12/2024.
//

import Foundation
import Amplify

class PlayerManager {
//    static func doesPlayerExist(username: String) async throws -> Bool {
//        let result = try await Amplify.API.query(request:
//                .list(
//                    Player.self,
//                    where: QueryPredicateOperation(field: "username", operator: .equals(username)),
//                    limit: 1,
//                    authMode: .amazonCognitoUserPools
//                )
//            )
//        let resultCount = try result.get().count
//        return resultCount == 1
//    }
    
    static func doesPlayerExist(username: String) async -> Bool {
        return await getPlayer(username: username) != nil
    }
    
    static func getPlayer(username: String) async -> Player? {
        do {
            let result = try await Amplify.API.query(request: .get(Player.self, byIdentifier: .identifier(username: username)))
            return try result.get()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func createPlayer(username: String) async throws -> Player {
        let player = Player(
            username: username,
            currentGameId: nil,
            position: nil,
            highScore: 0,
            score: 0,
            isAlive: false,
            isOnline: true
        )
        let result = try await Amplify.API.mutate(request: .create(player))
        return try result.get()
    }
}
