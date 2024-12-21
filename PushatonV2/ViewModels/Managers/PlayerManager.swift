//
//  PlayerManager.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 21/12/2024.
//

import Foundation
import Amplify

class PlayerManager {
    static func doesPlayerExist(username: String) async throws -> Bool {
        let result = try await Amplify.API.query(request:
                .list(
                    Player.self,
                    where: QueryPredicateOperation(field: "username", operator: .equals(username)),
                    limit: 1,
                    authMode: .amazonCognitoUserPools
                )
            )
        let resultCount = try result.get().count
        return resultCount == 1
    }
    
    static func createPlayer(username: String) async {
        do {
            let player = Player(
                username: username,
                currentGameId: nil,
                position: nil,
                highScore: 0,
                score: 0,
                isAlive: false,
                isOnline: true
            )
            _ = try await Amplify.API.mutate(request: .create(player))
        } catch {
            print(error.localizedDescription)
        }
    }
}
