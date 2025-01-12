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
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 50)

                Text("Pushaton V2")
                    .font(.evenLargerTitle)
                    .foregroundStyle(Color.primaryText)
                    .multilineTextAlignment(.center)
                
                #if DEBUG
                    Button("Sign Out") {
                        Task {
                            await Amplify.Auth.signOut()
                        }
                    }
                    Button("List Games") {
                        Task { await gameMatchViewModel.listGames() }
                    }
                    
                    Button("Clear Games") {
                        Task { await gameMatchViewModel.clearGames() }
                    }
                
                    Button("Clear Highscore") {
                        Task { await  playerViewModel.clearHighscore() }
                    }
                    
                    Text(playerViewModel.playerId)
                    
                    List(gameMatchViewModel.games, id: \.id) { game in
                        HStack {
                            Text(game.id)
                            Text(game.player1Id)
                            Text(game.player2Id ?? "")
                            Text(game.status.rawValue)
                        }
                    }
                #endif
                
                Spacer()
                
                Button {
                    Task {
                        await playerViewModel.resetScore()
                        await playerViewModel.setAlive()
                        await gameMatchViewModel.startMatch(playerId: playerViewModel.playerId) { opponentId in
                            playerViewModel.createOpponentSubscription(id: opponentId)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play 1v1")
                    }
                }
                .buttonStyle(PlayButtonStyle())
                
                Spacer()
                    .frame(height: 50)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .font(.title3)
                    .tint(Color.primaryText)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 6){
                        Image(systemName: "crown.fill")
                        Text("\(playerViewModel.player?.highScore ?? 0)")
                            .bold()
                            .font(.title3)
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
    }
}

#Preview {
    MenuView()
        .environment(GameMatchViewModel())
        .environment(PlayerViewModel())
}
