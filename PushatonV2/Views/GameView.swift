//
//  GameView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI

struct GameView: View {
    @State private var isGameShown = false
    
    var body: some View {
        if isGameShown {
            GameSceneView(isGameShown: $isGameShown)
                .ignoresSafeArea(.all)
        } else {
            Button("Play Again") {
                self.isGameShown = true
            }
        }
    }
}
