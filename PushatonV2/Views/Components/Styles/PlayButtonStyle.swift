//
//  PlayButtonStyle.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SwiftUI

struct PlayButtonStyle: ButtonStyle {
    @State private var isAnimating: Bool = false
  
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .font(.title3)
            .bold()
            .foregroundStyle(.primaryText)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isAnimating ? Color.green.lighten(by: 0.05) : Color.green)
                    .shadow(color: Color.green.opacity(0.8), radius: 5)
            )
            .padding(.horizontal, 50)
            .scaleEffect(isAnimating ? 1 : 0.92)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}


#Preview {
    Button("Tap Me") {
        
    }
    .buttonStyle(PlayButtonStyle())
}

