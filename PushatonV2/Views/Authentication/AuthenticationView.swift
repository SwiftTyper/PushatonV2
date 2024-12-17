//
//  AuthenticationView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import SwiftUI

struct AuthenticationView: View {
    @Environment(AuthenticationViewModel.self) var authenticationViewModel
    
    var body: some View {
        if authenticationViewModel.state == .codeConfirmation {
            VerificationView { code in
                Task {
                    await authenticationViewModel.verifySignUp(for: "email", with: code)
                }
            } resendAction: {
                Task {
                    await authenticationViewModel.resendSignUpCode(email: "email")
                }
            }
        } else if authenticationViewModel.state == .login {
            LoginView()
        } else {
            SignUpView()
        }
    }
}
