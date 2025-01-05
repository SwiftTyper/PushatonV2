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
        return try await getPlayer(username: username) != nil
    }
    
    static func getPlayer(username: String, signedIn: Bool = false) async throws -> Player? {
        let result = try await Amplify.API.query(request: .get(Player.self, byIdentifier: .identifier(username: username), authMode: signedIn ? .amazonCognitoUserPools : .awsIAM))
        return try result.get()
    }
    
    static func createPlayer(username: String) async throws -> Player {
        let player = Player(
            username: username,
            currentGameId: nil,
            position: nil,
            highScore: 0,
            isOnline: true
        )
        let result = try await Amplify.API.mutate(request: .create(player))
        return try result.get()
    }
}
