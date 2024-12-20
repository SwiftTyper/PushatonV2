//
//  ShowAuthenticationIfNeeded.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import SwiftUI

struct ShowAuthenticationIfNeededModifier: ViewModifier {
    @Environment(SessionViewModel.self) var sessionViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: .constant(sessionViewModel.state == .loggedOut)) {
                AuthenticationView()
                    .interactiveDismissDisabled()
            }
    }
}

