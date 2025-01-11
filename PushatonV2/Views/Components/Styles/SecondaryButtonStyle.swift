//
//  SecondaryButtonStyle.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    init() {}
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(.tertiarySystemFill))
            .foregroundColor(.white)
            .cornerRadius(12)
            .font(.body.weight(.semibold))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    Button("Tap Me") {
        
    }
    .buttonStyle(SecondaryButtonStyle())
}

