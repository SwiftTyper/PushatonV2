//
//  ForgotPasswordViewModel.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 20/12/2024.
//

import Foundation
import Observation
import Amplify
import SwiftUI

@MainActor
@Observable
class ForgotPasswordViewModel {
    var email: String
    var newPassword: String = ""
    var state: ForgotPasswordState = .resetPassword
    
    init(email: String) {
        self.email = email
    }
    
    func resetPassword() async {
        state = .loading
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: email)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(_, _):
                    state = .verifyCode
                case .done:
                    state = .resetPassword
            }
        } catch let error as AuthError {
            AlertManager.presentAlert(message: error.errorDescription)
            state = .resetPassword
        } catch {
            AlertManager.presentAlert()
            state = .resetPassword
        }
    }
    
    func verifyResetPassword(
        with code: String,
        onSuccess: @escaping () -> Void
    ) async {
        state = .loading
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: email,
                with: newPassword,
                confirmationCode: code
            )
            onSuccess()
        } catch let error as AuthError {
            AlertManager.presentAlert(message: error.errorDescription)
        } catch {
            AlertManager.presentAlert()
        }
        state = .resetPassword
    }
}
