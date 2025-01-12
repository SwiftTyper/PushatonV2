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
    
    @State private var highscoreDimissed: Bool = false
    
    var highscoreShown: Bool {
        !highscoreDimissed && playerViewModel.player?.score == playerViewModel.player?.highScore && playerViewModel.player?.score > 0
    }
    
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
                            if highscoreShown {
                                HighScoreView(score: playerViewModel.player?.score ?? -1) {
                                    highscoreDimissed = true
                                }
                            } else {
                                GameResultView(
                                    playerScore: playerViewModel.player?.score ?? -1,
                                    opponentScore: playerViewModel.opponent?.score ?? -1,
                                    opponentId: playerViewModel.opponent?.username ?? "",
                                    result: gameMatchViewModel.getGameResult(playerId: playerViewModel.playerId),
                                    onAction: {
                                        Task {
                                            await gameMatchViewModel.startMatch(playerId: playerViewModel.playerId) { opponentId in
                                                playerViewModel.createOpponentSubscription(id: opponentId)
                                            }
                                        }
                                    },
                                    onDismiss: {
                                        gameMatchViewModel.game = nil
                                    },
                                    onAppear: {
                                        gameMatchViewModel.cancelSubscription()
                                        playerViewModel.cancelSubscription()
                                    }
                                )
                            }
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
