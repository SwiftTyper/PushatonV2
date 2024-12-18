//
//  ButtonStyles.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    init(isDisabled: Bool = false) {
        self.isDisabled = isDisabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(maxWidth: .infinity, maxHeight: 52)
            .background(isDisabled ? Color.accentColor.opacity(0.2) : Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(12)
            .font(.body.weight(.semibold))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
    
}

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
