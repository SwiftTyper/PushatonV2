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
                                    playerViewModel: playerViewModel
                                )
                                .ignoresSafeArea(.all)
                            case .finished:
                                GameOverView()
                        }
                    } else {
                        MenuView()
                    }
                    
                    if gameMatchViewModel.showCameraOverlay {
                        CameraOverlay()
                    }
                }
                .ignoresSafeArea(.all)
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
//                self.isPortrait = isInPortrait()
                self.predictionViewModel.videoCapture.updateDeviceOrientation()
                print(UIDevice.current.orientation)
            }
            self.predictionViewModel.videoCapture.updateDeviceOrientation()
            print(UIDevice.current.orientation.rawValue)
//            self.isPortrait = isInPortrait()
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
