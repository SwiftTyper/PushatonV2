//
//  ForgotPasswordView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 20/12/2024.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @State private var viewModel: ForgotPasswordViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(email: String) {
        viewModel = .init(email: email)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
                case .resetPassword:
                    ResetPasswordView()
                case .verifyCode:
                    VerificationView { code in
                        Task {
                            await viewModel.verifyResetPassword(with: code) {
                                dismiss()
                            }
                        }
                    } resendAction: {
                        Task {
                            await viewModel.resetPassword()
                        }
                    }
            }
        }
        .environment(viewModel)
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
