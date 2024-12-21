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
    
    private var isDisabled: Bool {
        !requirements.allSatisfy { $0.isMet } || viewModel.email.isEmpty
    }
    
    private var requirements: [Requirement] {
       [
            Requirement(
                name: "At least 8 characters long",
                isMet: viewModel.newPassword.count >= 8
            ),
            Requirement(
                name: "At least one uppercase letter",
                isMet: viewModel.newPassword.contains { $0.isUppercase}
            ),
            Requirement(
                name: "At least one number and symbol",
                isMet: viewModel.newPassword.contains { $0.isNumber } && viewModel.newPassword.contains { $0.isActualSymbol }
            )
       ]
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
        return GeometryReader { geo in
            VStack(alignment: .center, spacing: 30) {
                Image(systemName: "person.crop.circle.badge.questionmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity)
                    .offset(x: -geo.size.width/25)
                    .symbolEffect(.bounce, options: .default, value: animate)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.accentColor.gradient)
                    .onAppear {
                        withAnimation(.spring){
                            animate.toggle()
                        }
                    }
                    .layoutPriority(1)
                
                VStack(alignment: .center, spacing: 30) {
                    Text("Forgot Password?")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color.primary)
                    
                    Text("Don't worry it happens. Please enter the address associated with your account.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(2)

                    VStack(alignment: .center, spacing: 14) {
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
                        
                        RequirementsTableView(requirements: requirements)
                    }
                }
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 20)
        }
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
