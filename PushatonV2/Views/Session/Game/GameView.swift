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
    @StateObject var predictionViewModel: PredictionViewModel = .init()
    
    var body: some View {
        Group {
            if gameMatchViewModel.isLoading || playerViewModel.isLoading {
                GameProgressView()
            } else {
                ZStack(alignment: .bottomLeading){
                    if let status = gameMatchViewModel.game?.status {
                        switch status {
                            case .waiting:
                                GameProgressView()
                            case .playing:
                                GameSceneView(
                                    gameMatchViewModel: gameMatchViewModel,
                                    playerViewModel: playerViewModel,
                                    predictionViewModel: predictionViewModel
                                )
                            case .finished:
                                GameOverView()
                        }
                    } else {
                        MenuView()
                    }
                    
                    if predictionViewModel.isShowingCameraOverlay || gameMatchViewModel.game?.status == .playing {
                        CameraOverlay()
                    }
                }
                .ignoresSafeArea(.all)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
                self.predictionViewModel.videoCapture.updateDeviceOrientation()
            }
            self.predictionViewModel.videoCapture.updateDeviceOrientation()
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
        }
        .environment(gameMatchViewModel)
        .environment(playerViewModel)
        .environmentObject(predictionViewModel)
    }
    
    func isInPortrait() -> Bool {
        let orientation = UIDevice.current.orientation
        return orientation == .portrait || orientation == .portraitUpsideDown
    }
}

#Preview {
    GameView()
}
