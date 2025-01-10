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
        Group {
            if let status = gameMatchViewModel.game?.status {
                switch status {
                    case .waiting:
                        ProgressView("Looking for players")
                    case .playing:
                        GameSceneView(
                            gameMatchViewModel: gameMatchViewModel,
                            playerViewModel: playerViewModel
                        )
                        .ignoresSafeArea(.all)
                    case .finished:
                        GameResultView(
                            playerScore: playerViewModel.player?.score ?? -1,
                            opponentScore: playerViewModel.opponent?.score ?? -1,
                            opponentId: playerViewModel.opponent?.username ?? "",
                            result: gameMatchViewModel.getGameResult(playerId: playerViewModel.playerId),
                            action: {
                                Task { await playerViewModel.resetScore() }
                                gameMatchViewModel.game = nil
                                gameMatchViewModel.cancelSubscription()
                                playerViewModel.cancelSubscription()
                            },
                            dismissAction: {
                                Task { await playerViewModel.resetScore() }
                                gameMatchViewModel.game = nil
                                gameMatchViewModel.cancelSubscription()
                                playerViewModel.cancelSubscription()
                            }
                        )
                }
            } else {
                MenuView()
            }
        }
        .environment(gameMatchViewModel)
        .environment(playerViewModel)
    }
}
