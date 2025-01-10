//
//  GameOverView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 09/01/2025.
//

import Foundation
import SwiftUI

extension Font {
    public static let largerTitle: Font = Font.system(size: 40, weight: .bold, design: .default)
    public static let largestTitle: Font = Font.system(size: 70, weight: .bold, design: .default)
}

struct GameResultView: View {
    let playerScore: Int
    let opponentScore: Int
    let opponentId: String
    let result: GameResult
    
    let action: () -> Void
    let dismissAction: () -> Void
    
    var scoreDifference: Int {
        abs(opponentScore - playerScore)
    }
    
    let percentagePassed: Int = 30
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Text(result.getTitle(difference: scoreDifference))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.primaryText)
                            .shadow(radius: 2)
                        
                        if result == .tie {
                            Text("Better Luck Next Time!")
                                .font(.title)
                                .foregroundStyle(.primaryText)
                        }
                    }
                    
                    Spacer()
                    
                    if result == .lost {
                        VStack(spacing: 60) {
                            Text("Score")
                                .font(.title2)
                                .foregroundStyle(.primaryText)
                            
                            ScoreProgressBar(
                                score: playerScore,
                                maxScore: opponentScore,
                                opponentId: opponentId
                            )
                            .frame(maxWidth: geo.size.width * 2/3)
                        }
                    } else if result == .won {
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
                                Text("Opponent's Score")
                                    .font(.headline)
                                    .foregroundStyle(.primaryText)
                                
                                Text("\(opponentScore)")
                                    .font(.largerTitle)
                                    .foregroundStyle(.primaryText)
                            }
                        }
                    } else {
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
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        Button(action: {
                            action()
                        }) {
                            HStack {
                                Image(systemName: result == .won ? "play.fill" :  "arrow.clockwise")
                                Text("\(result == .won ? "Play" : "Try") Again")
                                    .font(.title3)
                            }
                            .bold()
                            .foregroundStyle(.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(result == .won ? Color.green : Color.red)
                                    .shadow(radius: 5)
                            )
                            .padding(.horizontal, 50)
                        }
                        
                        Text("You are in the top **\(percentagePassed)%** of players")
                            .foregroundColor(.primaryText)
                            .font(.title3)
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismissAction()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .font(.title)
                    .bold()
                    .tint(.primaryText)
                }
            }
            .background(
                Color(
                    red: 0.1,
                    green: 0.3,
                    blue: 0.8
                ).ignoresSafeArea()
            )
        }
    }
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(
            playerScore: 20,
            opponentScore: 30,
            opponentId: "Player123",
            result: .tie,
            action: {},
            dismissAction: {}
        )
    }
}
