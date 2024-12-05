//
//  GameView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI

struct GameView: View {
    @State private var score = 0
    @State private var isGameActive = false
    @State private var showMenu = true
    @State private var highScore = UserDefaults.standard.integer(forKey: "HighScore")
    
    var body: some View {
            //            if isGameActive {
            GameSceneView()
                .ignoresSafeArea(.all)
            
//            } else {
//                ZStack {
//                    VStack {
//                        HStack {
//                            Text("Score: \(score)")
//                                .font(.title2)
//                                .foregroundColor(.white)
//                                .padding()
//                            Spacer()
//                            Text("High Score: \(highScore)")
//                                .font(.title2)
//                                .foregroundColor(.white)
//                                .padding()
//                        }
//                        .background(Color.black.opacity(0.5))
//                        Spacer()
//                    }
//                    
//                    if showMenu {
//                        StartMenuView {
//                            startGame()
//                        }
//                    } else {
//                        GameOverView(highScore: $highScore, score: score) {
//                            restartGame()
//                        }
//                    }
//                }
//            }
//        }
    }
    
//    private func startGame() {
//        showMenu = false
//        score = 0
//        isGameActive = true
//    }
//    
//    private func restartGame() {
//        if score > highScore {
//            highScore = score
//            UserDefaults.standard.set(highScore, forKey: "HighScore")
//        }
//        score = 0
//        isGameActive = true
//    }
}
