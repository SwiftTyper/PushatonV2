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
        NavigationStack {
            if authenticationViewModel.state == .login {
                LoginView()
            } else if authenticationViewModel.state == .signup {
                SignUpView()
            } else {
                VerificationView { code in
                    Task {
                        await authenticationViewModel.verifySignUp(with: code)
                    }
                } resendAction: {
                    Task {
                        await authenticationViewModel.resendSignUpCode()
                    }
                }
            }
        }
        .overlay { if authenticationViewModel.isLoading { ProgressView() }}
        .environment(authenticationViewModel)
    }
}
