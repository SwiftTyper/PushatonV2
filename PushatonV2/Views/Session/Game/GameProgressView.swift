//
//  GameProgressView().swift
//  PushatonV2
//
//  Created by Wit Owczarek on 12/01/2025.
//

import Foundation
import SwiftUI

struct GameProgressView: View {
    @State private var isLoading: Bool = false
    
    var body: some View {
        ActivityIndicator(
            isAnimating: $isLoading,
            style: .large,
            color: .white
        )
        .onAppear {
            isLoading = true
        }
        .onDisappear {
            isLoading = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground.ignoresSafeArea())
    }
}

#Preview {
    GameProgressView()
}
