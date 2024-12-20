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
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: email)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    state = .verifyCode
                case .done: return
            }
        } catch let error as AuthError {
            AlertManager.presentAlert(message: error.errorDescription)
        } catch {
            AlertManager.presentAlert()
        }
    }
    
    func verifyResetPassword(
        with code: String,
        onSuccess: @escaping () -> Void
    ) async {
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
    }
}
