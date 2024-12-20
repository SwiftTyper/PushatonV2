//
//  ResetPasswordView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 20/12/2024.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    @Environment(ForgotPasswordViewModel.self) var viewModel
    
    @State private var animate: Bool = false
    @State private var focused: Bool = false
    @State private var passwordFocused: Bool = false
    @State private var isPasswordHidden: Bool = true
    
    var isDisabled: Bool {
        viewModel.email.isEmpty || viewModel.newPassword.isEmpty
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            form
            bottomToolbar
        }
    }
}

extension ResetPasswordView {
    var form: some View {
        @Bindable var viewModel = viewModel
        return VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.questionmark")
                .symbolEffect(.bounce, options: .default, value: animate)
                .font(.system(size: 150))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.accentColor.gradient)
                .padding(.bottom, 10)
                .onAppear {
                    withAnimation(.spring){
                        animate.toggle()
                    }
                }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 30) {
                Text("Forgot Password?")
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.primary)
                    .padding(.bottom, 10)
                
                Text("Don't worry it happens. Please enter the address associated with your account.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.secondary)
                
                VStack(alignment: .center, spacing: 16) {
                    LimitedTextField(
                        text: $viewModel.email,
                        focused: $focused,
                        nextResponder: $passwordFocused,
                        characterLimit: 40,
                        placeholder: "Email"
                    )
                    .limitedTextFieldStyle()
                    
                    LimitedTextField(
                        text: $viewModel.newPassword,
                        focused: $passwordFocused,
                        characterLimit: 40,
                        placeholder: "New Password",
                        isPassword: $isPasswordHidden
                    )
                    .limitedTextFieldStyle(isPassword: true, isPasswordHidden: $isPasswordHidden)
                }
            }
        }
        .padding(.bottom, 40)
        .padding(.horizontal, 20)
    }
}

extension ResetPasswordView {
    var bottomToolbar: some View {
        VStack(alignment: .center, spacing: 15){
            Divider()
           
            Button("Reset Password") {
                HapticManager.shared.impact(style: .medium)
                Task { await viewModel.resetPassword() }
            }
            .disabled(isDisabled)
            .buttonStyle(PrimaryButtonStyle(isDisabled: isDisabled))
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
