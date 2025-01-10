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
                            playerScore: playerViewModel.player?.score ?? 0,
                            opponentScore: playerViewModel.opponent?.score ?? 0,
                            opponentId: playerViewModel.opponent?.username ?? "",
                            result: gameMatchViewModel.getGameResult(playerId: playerViewModel.playerId),
                            action: {},
                            dismissAction: {
                                gameMatchViewModel.game = nil
                                gameMatchViewModel.cancelSubscription()
                                playerViewModel.cancelSubscription()
                                Task { await playerViewModel.resetScore() }
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
