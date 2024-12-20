//
//  ContentView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 16/12/2024.
//

import Foundation
import SwiftUI
import Authenticator

struct ContentView: View {
    @State private var sessionViewModel: SessionViewModel = .init()
    @State private var authenticationViewModel: AuthenticationViewModel = .init()
    
    var body: some View {
        Group {
            switch sessionViewModel.state {
                case .loggedIn: GameView()
                default: ProgressView()
            }
        }
        .modifier(ShowAuthenticationIfNeededModifier())
        .environment(sessionViewModel)
        .environment(authenticationViewModel)
    }
}
