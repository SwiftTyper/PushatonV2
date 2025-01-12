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
    var isDisabled: Bool
    
    init(isDisabled: Bool) {
        self.isDisabled = isDisabled
    }
    
    var color: Color {
        if isDisabled {
            return Color.green.disabled()
        } else {
            return isAnimating ? Color.green.lighten(by: 0.05) : Color.green
        }
    }
  
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .font(.title3)
            .bold()
            .foregroundStyle(.primaryText)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color)
                    .shadow(color: color.opacity(0.8), radius: 5)
            )
            .padding(.horizontal, 50)
            .scaleEffect(isAnimating ? 1 : 0.92)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                if !isDisabled {
                    isAnimating = true
                }
            }
            .onChange(of: isDisabled) { _, newValue in
                isAnimating = !newValue
            }
    }
}


#Preview {
    @Previewable @State var isDisabled = true
    Button("Tap Me") {
        
    }
    .buttonStyle(PlayButtonStyle(isDisabled: isDisabled))
    .onAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isDisabled = false
        }
    }
}

