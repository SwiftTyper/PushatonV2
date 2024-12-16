//
//  LoggedOutView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 16/12/2024.
//

import Foundation
import SwiftUI

struct LoggedOutView: View {
    enum FormType: String, CaseIterable {
        case login = "Login"
        case signup = "Sign Up"
    }
    
    @Environment(AuthenticationViewModel.self) var authenticationViewModel
    @State private var form: FormType = .signup
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Form {
            Section {
                Picker("form type", selection: $form) {
                    ForEach(FormType.allCases, id: \.self) { form in
                        Text(form.rawValue)
                            .tag(form.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            TextField("email", text: $email)
                .autocorrectionDisabled()
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)

            if form == .signup {
                TextField("username", text: $username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            TextField("password", text: $password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            Section {
                Button(form == .login ? "Login" : "Sign Up") {
                    Task {
                        if form == .login {
                            await authenticationViewModel.signIn(email: email, password: password)
                        } else {
                            await authenticationViewModel.signUp(username: username, password: password, email: email)
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
