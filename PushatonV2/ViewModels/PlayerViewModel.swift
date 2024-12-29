//
//  PlayerViewModel.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 25/12/2024.
//

import Foundation
import Observation
import Amplify

@MainActor
@Observable
class PlayerViewModel {
    var player: Player? = nil
    
    var playerId: String {
        player?.username ?? ""
    }
    
    init() {
        Task { await createPlayerIfMissing() }
    }
    
    private func createPlayerIfMissing() async {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            let username = attributes.first(where: { $0.key == AuthUserAttributeKey.preferredUsername })?.value
            guard let username = username else { return }
            
            if let player = try await PlayerManager.getPlayer(username: username, signedIn: true) {
                self.player = player
            } else {
                self.player = try await PlayerManager.createPlayer(username: username)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
