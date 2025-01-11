//
//  PlayButtonStyle.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SwiftUI

struct PlayAgainButtonStyle: ButtonStyle {
    let type: GameResult
    
    init(type: GameResult) {
        self.type = type
    }
    
    var color: Color {
        type == .won ? Color.green : Color.red
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
    }
}

#Preview {
    Button("Tap Me") {
        
    }
    .buttonStyle(PlayAgainButtonStyle(type: .won))
}
