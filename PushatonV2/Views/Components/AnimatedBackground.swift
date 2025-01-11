//
//  AnimatedBackground.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    let colors: [Color]
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: animateGradient ? .bottomTrailing : .bottomLeading
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

