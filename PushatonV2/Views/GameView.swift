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
                        Task { await gameMatchViewModel.startMatch(playerId: "") }
                    }
                    
                    if let activeGame = gameMatchViewModel.game {
                        Text(activeGame.id)
                        Text(activeGame.player1Id)
                        Text(activeGame.player2Id ?? "e")
                    }
                }
        }
    }
}
