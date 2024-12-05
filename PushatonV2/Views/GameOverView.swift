//
//  GameOverView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI

struct GameOverView: View {
    @Binding var highScore: Int
    let score: Int
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            VStack(spacing: 20) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.white)
                
                if score > highScore {
                    Text("New High Score!")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }
                
                Button("Play Again") {
                    onRestart()
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
