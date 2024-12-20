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
    @Environment(\.presentationMode) private var presentationMode

    @State private var emailFocused: Bool = false
    @State private var usernameFocused: Bool = false
    @State private var passwordFocused: Bool = false
    @State private var confimedPasswordFocused: Bool = false
    
    @State private var isPasswordHidden: Bool = true

    var body: some View {
        VStack(alignment: .center, spacing: 0){
            form
            bottomToolbar
        }
        .navigationTitle("Create your Account")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    HapticManager.shared.impact(style: .medium)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(TertiaryButtonStyle())
            }
        }
    }
}

extension SignUpView {
    var form: some View {
        @Bindable var authenticationViewModel = authenticationViewModel
        return GeometryReader { geo in
            VStack(alignment: .center, spacing: 30) {
                VStack(alignment: .leading, spacing: 16) {
                    LimitedTextField(
                        text: $authenticationViewModel.email,
                        focused: $emailFocused,
                        nextResponder: $usernameFocused,
                        characterLimit: 40,
                        placeholder: "Email"
                    )
                    .limitedTextFieldStyle()
                    
                    LimitedTextField(
                        text: $authenticationViewModel.username,
                        focused: $usernameFocused,
                        nextResponder: $passwordFocused,
                        characterLimit: 40,
                        placeholder: "Username"
                    )
                    .limitedTextFieldStyle()

                    LimitedTextField(
                        text: $authenticationViewModel.password,
                        focused: $passwordFocused,
                        nextResponder: $confimedPasswordFocused,
                        characterLimit: 40,
                        placeholder: "Password",
                        isPassword: $isPasswordHidden
                    )
                    .limitedTextFieldStyle(isPassword: true, isPasswordHidden: $isPasswordHidden)

                    LimitedTextField(
                        text: $authenticationViewModel.confirmedPassword,
                        focused: $confimedPasswordFocused,
                        characterLimit: 40,
                        placeholder: "Confirm Password",
                        isPassword: $isPasswordHidden
                    )
                    .limitedTextFieldStyle(isPassword: true, isPasswordHidden: $isPasswordHidden)
                    
                    RequirementsTableView(requirements: requirements)
                }
                
                Text(termsAndPrivacyText)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.secondary)
                    .frame(height: 35, alignment: .top)
                    .padding(.top, -10)
                    .padding(.bottom, 30)

            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
    }
}

extension SignUpView {
    var bottomToolbar: some View {
        VStack(alignment: .center, spacing: 15){
            Divider()
           
            VStack(spacing: 24) {
                Button("Create Account") {
                    Task {
                        HapticManager.shared.impact(style: .medium)
                        await authenticationViewModel.signUp()
                    }
                }
                .disabled(isDisabled)
                .buttonStyle(PrimaryButtonStyle(isDisabled: isDisabled))

                if !isFocused {
                    HStack {
                        Text("Already have an account?")
                            .font(.body)
                            .foregroundStyle(Color.secondary)
                        
                        Button {
                            HapticManager.shared.impact(style: .medium)
                            authenticationViewModel.state = .login
                        } label: {
                            Text("Log In")
                        }
                        .buttonStyle(TertiaryButtonStyle())
                    }
                }
            }
            .padding(.bottom, isFocused ? 15 : 30)
            .padding(.horizontal, 20)
        }
        .background(Color(UIColor.systemBackground))
    }
}
    
extension SignUpView {
    private var isFocused: Bool {
        emailFocused || passwordFocused || confimedPasswordFocused || usernameFocused
    }
    
    private var isDisabled: Bool {
        !requirements.allSatisfy { $0.isMet } || authenticationViewModel.email.isEmpty
    }
    
    private var termsAndPrivacyText: AttributedString {
        let fullString = NSMutableAttributedString(string: "By signing up, I acknowledge that I have read and agree to our terms & conditions and privacy policy")
        
        let range1 = (fullString.string as NSString).range(of: "terms & conditions")
        let range2 = (fullString.string as NSString).range(of: "privacy policy")
        
        fullString.addAttributes([
            .link: URL(string: "https://example.com/terms")!,
            .foregroundColor: UIColor(Color.accentColor)
        ], range: range1)
        
        fullString.addAttributes([
            .link: URL(string: "https://example.com/privacy")!,
            .foregroundColor: UIColor(Color.accentColor)
        ], range: range2)
        
        return AttributedString(fullString)
    }
        
    private var requirements: [Requirement] {
        [
            Requirement(name: "At least 6 characters long", isMet: authenticationViewModel.password.count >= 6),
            Requirement(name: "At least one special character", isMet: authenticationViewModel.password.contains { $0.isSymbol || $0.isPunctuation || $0.isNumber }),
            Requirement(name: "Passwords must match", isMet: authenticationViewModel.password == authenticationViewModel.confirmedPassword)
        ]
    }
}
