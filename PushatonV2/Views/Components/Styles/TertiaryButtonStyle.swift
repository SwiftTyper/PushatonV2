//
//  TertiaryButtonStyle.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SwiftUI

struct TertiaryButtonStyle: ButtonStyle {
    init() {}
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .foregroundStyle(Color.accentColor)
            .font(.body.weight(.semibold))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    Button("Tap Me") {
        
    }
    .buttonStyle(TertiaryButtonStyle())
}
