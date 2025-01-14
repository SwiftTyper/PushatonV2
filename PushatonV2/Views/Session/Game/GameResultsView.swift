//
//  GameOverView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 09/01/2025.
//

import Foundation
import SwiftUI

struct GameResultView: View {
    let playerScore: Int
    let opponentScore: Int
    let opponentId: String
    let result: GameResult
    
    let onAction: () -> Void
    let onDismiss: () -> Void
    let onAppear: () -> Void
    
    var scoreDifference: Int {
        abs(opponentScore - playerScore)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text(result.getTitle(difference: scoreDifference))
                            .font(.evenLargerTitle)
                            .foregroundStyle(.primaryText)
                            .shadow(radius: 2)
                        
                        if result == .tie {
                            Text("Better Luck Next Time!")
                                .font(.title)
                                .foregroundStyle(.primaryText)
                        }
                    }
                    
                    Spacer()
                    
                    scoreView(geo: geo)
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Button {
                            onAction()
                        } label: {
                            HStack {
                                Image(systemName: result == .won ? "play.fill" :  "arrow.clockwise")
                                Text("\(result == .won ? "Play" : "Try") Again")
                            }
                        }
                        .buttonStyle(PlayAgainButtonStyle(type: result))
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .font(.title)
                    .bold()
                    .tint(.primaryText)
                }
            }
            .background(Color.primaryBackground.ignoresSafeArea())
            .onAppear(perform: onAppear)
        }
    }
    
    @ViewBuilder
    func scoreView(geo: GeometryProxy) -> some View {
        switch result {
            case .won:
                VStack(spacing: 30) {
                    VStack(spacing: 2) {
                        Text("Your Score")
                            .font(.headline)
                            .foregroundStyle(.primaryText)
                        
                        Text("\(playerScore)")
                            .font(.largestTitle)
                            .foregroundStyle(.gold)
                    }
                    
                    VStack(spacing: 2) {
                        Text("\(opponentId)'s Score")
                            .font(.headline)
                            .foregroundStyle(.primaryText)
                        
                        Text("\(opponentScore)")
                            .font(.largerTitle)
                            .foregroundStyle(.primaryText)
                    }
                }
            case .lost:
                VStack(spacing: 60) {
                    Text("Score")
                        .font(.title)
                        .foregroundStyle(.primaryText)
                    
                    ScoreProgressBar(
                        score: playerScore,
                        maxScore: opponentScore,
                        opponentId: opponentId
                    )
                    .frame(maxWidth: geo.size.width * 2/3)
                }
            case .tie:
                MyEqualWidthHStack {
                    VStack(spacing: 8) {
                        Text("Your Score")
                            .font(.headline)
                            .foregroundStyle(.primaryText)
                        
                        Text("\(playerScore)")
                            .font(.largestTitle)
                            .foregroundStyle(.primaryText)
                    }
                    
                    VStack(spacing: 8) {
                        Text("Opponent's Score")
                            .font(.headline)
                            .foregroundStyle(.primaryText)
                        
                        Text("\(opponentScore)")
                            .font(.largestTitle)
                            .foregroundStyle(.primaryText)
                    }
                }
        }
    }
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(
            playerScore: 20,
            opponentScore: 30,
            opponentId: "Player123",
            result: .won,
            onAction: {},
            onDismiss: {},
            onAppear: {}
        )
    }
}
