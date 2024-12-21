//
//  LoginView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import SwiftUI
import Amplify

struct LoginView: View {
    @Environment(AuthenticationViewModel.self) var authenticationViewModel
    @Environment(\.presentationMode) private var presentationMode

    @State private var didForgetPassword: Bool = false
    @State private var emailFocus: Bool = false
    @State private var passwordFocus: Bool = false
    @State private var isPasswordHidden: Bool = true
    
    var isFocused: Bool {
        emailFocus || passwordFocus
    }
    
    var isDisabled: Bool {
        authenticationViewModel.email.isEmpty || authenticationViewModel.password.isEmpty
    }
    
    var body: some View {
        form
            .safeAreaInset(edge: .bottom) { bottomToolbar }
            .navigationTitle("Log In")
            .navigationDestination(isPresented: $didForgetPassword) {
                ForgotPasswordView(email: authenticationViewModel.email)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(TertiaryButtonStyle())
                }
            }
    }
}

extension LoginView {
    var form: some View {
        @Bindable var authenticationViewModel = authenticationViewModel
        return ScrollView {
            VStack(alignment: .center, spacing: 30) {
                VStack(alignment: .center, spacing: 14) {
                    LimitedTextField(
                        text: $authenticationViewModel.email,
                        focused: $emailFocus,
                        nextResponder: $passwordFocus,
                        characterLimit: 40,
                        placeholder: "Email"
                    )
                    .limitedTextFieldStyle()
                    
                    LimitedTextField(
                        text: $authenticationViewModel.password,
                        focused: $passwordFocus,
                        characterLimit: 40,
                        placeholder: "Password",
                        isPassword: $isPasswordHidden
                    )
                    .limitedTextFieldStyle(isPassword: true, isPasswordHidden: $isPasswordHidden)
                }
                
                Button("Forgot Password?") {
                    HapticManager.shared.impact(style: .medium)
                    didForgetPassword = true
                }
                .buttonStyle(TertiaryButtonStyle())
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
    }
}

extension LoginView {
    var bottomToolbar: some View {
        VStack(alignment: .center, spacing: 15) {
            Divider()
           
            VStack(spacing: 24){
                Button("Login") {
                    Task {
                        HapticManager.shared.impact(style: .medium)
                        await authenticationViewModel.signIn()
                    }
                }
                .disabled(isDisabled)
                .buttonStyle(PrimaryButtonStyle(isDisabled: isDisabled))
               
                if !isFocused {
                    HStack {
                        Text("Don't have an account?")
                            .font(.body)
                            .foregroundStyle(Color.secondary)
                        
                        Button {
                            HapticManager.shared.impact(style: .medium)
                            authenticationViewModel.state = .signup
                        } label: {
                            Text("Sign Up")
                                .foregroundStyle(Color.accentColor)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .padding(.bottom, isFocused ? 15 : 30)
            .padding(.horizontal, 20)
        }
        .background(Color(UIColor.systemBackground))
    }
}
