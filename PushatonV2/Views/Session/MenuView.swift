//
//  MenuView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 24/12/2024.
//

import Foundation
import SwiftUI
import Amplify

struct MenuView: View {
    @Environment(GameMatchViewModel.self) var gameMatchViewModel
    @Environment(PlayerViewModel.self) var playerViewModel
    
    var body: some View {
        Button("Sign Out") {
            Task {
                await Amplify.Auth.signOut()
            }
        }
        
        Button("Play") {
            Task {
                await playerViewModel.setAlive()
                await gameMatchViewModel.startMatch(playerId: playerViewModel.playerId)
                let opponentId = playerViewModel.playerId == gameMatchViewModel.game?.player1Id ? gameMatchViewModel.game?.player2Id : gameMatchViewModel.game?.player1Id
                playerViewModel.createOpponentSubscription(id: opponentId ?? "")
            }
        }
        
        Button("List Games") {
            Task { await gameMatchViewModel.listGames() }
        }
        
        Button("Clear Games") {
            Task { await gameMatchViewModel.clearGames() }
        }
        
        Text(playerViewModel.playerId)
        
        List(gameMatchViewModel.games, id: \.id) { game in
            HStack {
                Text(game.id)
                Text(game.player1Id)
                Text(game.player2Id ?? "")
                Text(game.status.rawValue)
            }
        }
    }
}
