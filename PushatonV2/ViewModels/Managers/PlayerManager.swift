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
    
    static func getPlayer(username: String) async throws -> Player? {
        let result = try await Amplify.API.query(request: .get(Player.self, byIdentifier: .identifier(username: username), authMode: .awsIAM))
        return try result.get()
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
