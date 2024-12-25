//
//  AuthenticationView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import SwiftUI

struct AuthenticationView: View {
    @State private var authenticationViewModel: AuthenticationViewModel = .init()
    
    var body: some View {
        NavigationStack {
            switch authenticationViewModel.state {
                case .login: LoginView()
                case .signup: SignUpView()
                case .verifyCode:
                    VerificationView { code in
                        Task {
                            await authenticationViewModel.verifySignUp(with: code)
                        }
                    } resendAction: {
                        Task {
                            await authenticationViewModel.resendSignUpCode()
                        }
                    }
                case .loading: ProgressView()
            }
        }
        .environment(authenticationViewModel)
    }
}
