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
    @State var gameMatchViewModel: GameMatchViewModel = .init()
    @State var playerViewModel: PlayerViewModel = .init()
    
    var body: some View {
        Group {
            if gameMatchViewModel.isLoading || playerViewModel.isLoading {
                GameProgressView()
            } else {
                if let status = gameMatchViewModel.game?.status {
                    switch status {
                        case .waiting:
                            GameProgressView()
                        case .playing:
                            GameSceneView(
                                gameMatchViewModel: gameMatchViewModel,
                                playerViewModel: playerViewModel
                            )
                            .ignoresSafeArea(.all)
                        case .finished:
                            GameOverView()
                    }
                } else {
                    MenuView()
                }
            }
        }
        .environment(gameMatchViewModel)
        .environment(playerViewModel)
    }
}
