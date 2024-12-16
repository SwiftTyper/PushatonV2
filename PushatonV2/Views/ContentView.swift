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
    @State var authenticationViewModel: AuthenticationViewModel = .init()
    
    var body: some View {
        VStack {
            if authenticationViewModel.isLoggedIn {
                GameView()
            } else {
                LoggedOutView()
            }
        }
        .environment(authenticationViewModel)
    }
}
