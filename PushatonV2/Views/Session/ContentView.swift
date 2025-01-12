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
    
    var body: some View {
        Group {
            switch sessionViewModel.state {
                case .loggedIn: GameView()
                default: GameProgressView()
            }
        }
        .modifier(ShowAuthenticationIfNeededModifier())
        .environment(sessionViewModel)
    }
}
