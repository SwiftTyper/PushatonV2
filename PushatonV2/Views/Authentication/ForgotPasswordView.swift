//
//  ResetPasswordView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @Environment(AuthenticationViewModel.self) var authenticationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var focused: Bool = false
    @State private var animate: Bool = false
    
    var isDisabled: Bool {
        authenticationViewModel.email.isEmpty
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            form
            bottomToolbar
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    HapticManager.shared.impact(style: .medium)
                    dismiss()
                } label: {
                    HStack(spacing: 8){
                        Image(systemName: "chevron.backward")
                        Text("Login")
                    }
                }
                .buttonStyle(TertiaryButtonStyle())
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension ForgotPasswordView {
    var form: some View {
        @Bindable var authenticationViewModel = authenticationViewModel
        
        return VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            Image(systemName: "person.crop.circle.badge.questionmark")
                .symbolEffect(.bounce, options: .default, value: animate)
                .font(.system(size: 200))
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
                
                LimitedTextField(
                    text: $authenticationViewModel.email,
                    focused: $focused,
                    characterLimit: 40,
                    placeholder: "Email"
                )
                .limitedTextFieldStyle()
            }
        }
        .padding(.bottom, 40)
        .padding(.horizontal, 20)
    }
}

extension ForgotPasswordView {
    var bottomToolbar: some View {
        VStack(alignment: .center, spacing: 15){
            Divider()
           
            Button("Reset Password") {
                HapticManager.shared.impact(style: .medium)
                Task { }
            }
            .disabled(isDisabled)
            .buttonStyle(PrimaryButtonStyle(isDisabled: isDisabled))
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
}
