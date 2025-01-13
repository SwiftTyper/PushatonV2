//
//  GameOverView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 12/01/2025.
//

import Foundation
import SwiftUI

struct GameOverView: View {
    @Environment(GameMatchViewModel.self) var gameMatchViewModel
    @Environment(PlayerViewModel.self) var playerViewModel
    
    @State private var highscoreDimissed: Bool = false
    
    var highscoreShown: Bool {
        !highscoreDimissed && playerViewModel.player?.score == playerViewModel.player?.highScore && playerViewModel.player?.score > 0
    }
    
    var body: some View {
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
                    AudioPlayerManager.shared.stopAudio(.background)
                },
                onAppear: {
                    gameMatchViewModel.cancelSubscription()
                    playerViewModel.cancelSubscription()
                }
            )
        }
    }
}
