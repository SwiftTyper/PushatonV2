//
//  StartMenuView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI

struct StartMenuView: View {
    let onStart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
            
            VStack(spacing: 30) {
                Text("Runner Game")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("Tap to jump\nSwipe down to duck")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button("Start Game") {
                    onStart()
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
