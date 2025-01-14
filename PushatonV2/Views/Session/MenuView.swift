//
//  MenuView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 24/12/2024.
//

import Foundation
import SwiftUI
import Amplify

struct MenuView: View {
    @Environment(GameMatchViewModel.self) var gameMatchViewModel
    @Environment(PlayerViewModel.self) var playerViewModel
    @EnvironmentObject var predictionViewModel: PredictionViewModel
    @State private var showSettings: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    Spacer()
                        .frame(height: 100)

                    Text("Pushaton V2")
                        .font(.evenLargerTitle)
                        .foregroundStyle(Color.primaryText)
                        .multilineTextAlignment(.center)
                    
                    #if DEBUG
                        Button("List Games") {
                            Task { await gameMatchViewModel.listGames() }
                        }
                        
                        Button("Clear Games") {
                            Task { await gameMatchViewModel.clearGames() }
                        }
                    
                        Button("Clear Highscore") {
                            Task { await  playerViewModel.clearHighscore() }
                        }
                    #endif
                    
                    Spacer()
                    
                    Button {
                        predictionViewModel.isShowingCameraOverlay = true
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Play 1v1")
                        }
                    }
                    .buttonStyle(
                        PlayButtonStyle(
                            isDisabled: playerViewModel.player == nil
                        )
                    )
                    .disabled(playerViewModel.player == nil)
                    
                    Spacer()
                        .frame(height: 100)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                        }
                        .font(.title3)
                        .tint(Color.primaryText)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 6){
                            Image(systemName: "crown.fill")
                            if playerViewModel.player == nil {
                                ActivityIndicator(
                                    isAnimating: .constant(true),
                                    style: .medium,
                                    color: UIColor(named: "gold")!
                                )
                            } else {
                                Text("\(playerViewModel.player?.highScore ?? 0)")
                                    .bold()
                                    .font(.title3)
                            }
                        }
                        .foregroundStyle(.gold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.blue)
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color.blue,
                                Color.primaryBackground,
                                Color.primaryBackground
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        ParticlesView()
                    }
                )
            }
            PopupView(isShowing: $showSettings)
        }
    }
}

#Preview {
    MenuView()
        .environment(GameMatchViewModel())
        .environment(PlayerViewModel())
}
