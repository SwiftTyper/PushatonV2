//
//  GameView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI
import Amplify

struct GameView: View {
    @Environment(AuthenticationViewModel.self) var authenticationViewModel
    @Environment(SessionViewModel.self) var sessionViewModel
    @State var gameMatchViewModel: GameMatchViewModel = .init()
    @State private var isGameShown = false

    var body: some View {
        if isGameShown {
            GameSceneView(isGameShown: $isGameShown)
                .ignoresSafeArea(.all)
        } else {
            VStack {
                Button("Play Again") {
                    self.isGameShown = true
                }
               
                Button("Sign Out") {
                    Task { await authenticationViewModel.signOut() }
                }
                
                Button("Play") {
                    Task { await gameMatchViewModel.startMatch(playerId: sessionViewModel.player?.username ?? "") }
                }
                
                if let activeGame = gameMatchViewModel.game {
                    Text(activeGame.id)
                    Text(activeGame.player1Id)
                    Text(activeGame.player2Id ?? "")
                    Text(activeGame.status.rawValue)
                }
                
                Button("List Games") {
                    Task {
                        gameMatchViewModel.games = try await gameMatchViewModel.listGames()
                    }
                }
                
                Button("Clear Games") {
                    Task {
                        await gameMatchViewModel.clearGames()
                    }
                }
                
                
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
    }
}
