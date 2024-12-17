//
//  SignUpView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @Environment(AuthenticationViewModel.self) var authenticationViewModel
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("e-mail", text: $email)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            TextField("username", text: $username)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            TextField("password", text: $password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            Section {
                Button("Sign Up") {
                    Task {
                        await authenticationViewModel.signUp(username: username, password: password, email: email)
                    }
                }
            }
        }
    }
}
