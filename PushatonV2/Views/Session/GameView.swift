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
    @Environment(SessionViewModel.self) var sessionViewModel
    
    @State var gameMatchViewModel: GameMatchViewModel = .init()
    @State var playerViewModel: PlayerViewModel = .init()
    
    var body: some View {
        if let status = gameMatchViewModel.game?.status {
            switch status {
                case .waiting:
                    ProgressView()
                case .playing, .finished:
                    GameSceneView(
                        gameMatchViewModel: gameMatchViewModel,
                        playerViewModel: playerViewModel
                    )
                    .ignoresSafeArea(.all)
                    .overlay {
                        if gameMatchViewModel.game?.status == .finished {
                            VStack(spacing: 20) {
                                Text(gameMatchViewModel.getGameResult(playerId: playerViewModel.playerId) == .won ? "Winner" : "Game Over")
                                
                                Button("Go Back") {
                                    gameMatchViewModel.game = nil
                                    gameMatchViewModel.cancelSubscription()
                                }
                            }
                        }
                    }
            }
        } else {
            MenuView()
                .environment(gameMatchViewModel)
                .environment(playerViewModel)
        }
    }
}
