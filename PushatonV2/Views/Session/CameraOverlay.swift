//
//  CameraOverlay.swift
//  
//
//  Created by Wit Owczarek on 14/12/2024.
//

import Foundation
import SwiftUI

struct CameraOverlay: View {
    @EnvironmentObject var viewModel: PredictionViewModel
    @Environment(GameMatchViewModel.self) var gameMatchViewModel
    @Environment(PlayerViewModel.self) var playerViewModel
    @Environment(\.safeAreaInsets) var safeAreaInsets
   
    var body: some View {
        ZStack {
            if let (image, poses) = viewModel.currentFrame {
                CameraImageView(cameraImage: image)
                PosesView(poses: poses)
            } else {
                ProgressView()
            }
            
            if viewModel.countdownTimer != nil {
                Text(String(viewModel.countdownTime))
                    .font(.system(size: 196))
                    .bold()
                    .foregroundStyle(viewModel.getConditionCountdownColor())
                    .contentTransition(.numericText(countsDown: true))
                    .onAppear {
                        AudioPlayerManager.shared.play(.countdown)
                    }
            }
        }
        .onAppear {
            viewModel.setupConditionMonitoring {
                AudioPlayerManager.shared.play(.background)
                Task {
             //                        //could potentially be moved to run in parrallel (if the gameready executes first then no problem becuase gamematchviewmodel will fetch the initla status, however if it doesn't and the startMatch extectures first then also not a problem as it will have set up the listener and reacted to the new changes)
                     await playerViewModel.makeGameReady()
                     await gameMatchViewModel.startMatch(playerId: playerViewModel.playerId) { opponentId in
                         playerViewModel.createOpponentSubscription(id: opponentId)
                     }
                 }
            }
            viewModel.updateLabels(with: .startingPrediction)
        }
        .onDisappear {
            viewModel.stopConditionMonitoring()
        }
        .frame(
            width: (
                viewModel.isShowingGame || viewModel.isGameOver
            ) ? UIScreen.main.bounds.size.width/4 : UIScreen.main.bounds.size.width,
            height: (
                viewModel.isShowingGame || viewModel.isGameOver
            ) ? UIScreen.main.bounds.size.height/4 : UIScreen.main.bounds.size.height
        )
        .clipShape(RoundedRectangle(cornerRadius: (viewModel.isShowingGame || viewModel.isGameOver) ? 30 : 0))
        .overlay(alignment: (viewModel.isShowingGame || viewModel.isGameOver) ? .bottomLeading : .top) {
            if viewModel.currentFrame != nil {
                if (viewModel.isShowingGame || viewModel.isGameOver) {
                    predictionLabels
                } else {
                    VStack {
                        topBar
                        Spacer()
                        bottomBar
                    }
                }
            }
        }
        .containerShape(RoundedRectangle(cornerRadius: (viewModel.isShowingGame || viewModel.isGameOver) ? 15 : 0))
        .padding([.leading, .bottom], (viewModel.isShowingGame || viewModel.isGameOver) ? 12 : 0)
        .ignoresSafeArea(.all)
    }
}

extension CameraOverlay {
    var predictionLabels: some View {
        Group {
            if viewModel.predicted != ActionPrediction.lowConfidencePrediction.label {
                VStack(alignment: .center, spacing: 5){
        //            #if DEBUG
        //                Text("Prediction: \(viewModel.predicted)")
        //                    .font(.subheadline)
        //                    .bold()
        //
        //                Text("Confidence: \(viewModel.confidence)")
        //                    .font(.caption)
        //            #else
                        Text("\(viewModel.predicted)")
                            .font(.subheadline)
                            .bold()
        //            #endif
                }
                .foregroundStyle(Color.primaryText)
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, 10)
            }
        }
    }
    
    var topBar: some View {
        VStack(alignment: .center, spacing: 10) {
            Label {
                Text("Enter Pushup Hold To Start")
            } icon: {
                Image(systemName: "flag.checkered.2.crossed")
            }
            .font(.title)
            .bold()
            .foregroundStyle(Color.primaryText)
            .multilineTextAlignment(.center)
                
            HStack(alignment: .center, spacing: 10) {
                Text("Person Detected: ")
                    .font(.subheadline)
                    .foregroundStyle(Color.primaryText)
                
                statusIndictator(viewModel.isPersonFullyDetected)
            }
        }
        .padding(30)
        .background(Material.ultraThinMaterial)
        .cornerRadius(50)
        .padding(.top, safeAreaInsets.top)
        .padding(.horizontal, 5)
    }
    
    var bottomBar: some View {
        Button("Cancel") {
            gameMatchViewModel.showCameraOverlay = false
        }
        .buttonStyle(TertiaryButtonStyle())
        .foregroundStyle(Color.blue)
        .padding()
        .background(Capsule().fill(.ultraThinMaterial))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, safeAreaInsets.bottom + 50)
    }
    
    @ViewBuilder
    func statusIndictator(_ condition: Bool) -> some View {
        Image(systemName: condition ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundStyle(condition ? .green : .red)
            .font(.headline)
    }
}
