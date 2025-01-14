//
//  OnboardingView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 14/01/2025.
//

import Foundation
import SwiftUI

struct OnboardingSlide<Icon: View>: View {
    
    let icon: Icon
    let title: String
    let description: String
    
    init(title: String, description: String, @ViewBuilder icon: () -> Icon) {
        self.title = title
        self.description = description
        self.icon = icon()
    }
    
    var body: some View {
        
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 0.08 * UIScreen.main.bounds.size.height) {
                icon
                VStack(spacing: 0.05 * UIScreen.main.bounds.size.height) {
                    Text(title)
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(Color.primary)
                    
                    Text(description)
                        .font(.body.weight(.medium))
                        .foregroundColor(Color.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
                .frame(maxWidth: 380)
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}
