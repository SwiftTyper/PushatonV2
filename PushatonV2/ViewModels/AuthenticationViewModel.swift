//
//  AuthenticationViewModel.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 16/12/2024.
//

import Foundation
import Observation
import AWSCognitoAuthPlugin
import Amplify

@MainActor
@Observable
class AuthenticationViewModel {
    var email: String = ""
    var username: String = ""
    var password: String = ""
    var confirmedPassword: String = ""
    var state: AuthStatus = .login
    
    func signUp() async {
        state = .loading
        do {
            guard try await PlayerManager.doesPlayerExist(username: username) == false else {
                throw PlayerError.playerAlreadyExists
            }
            let userAttributes = [AuthUserAttribute(.preferredUsername, value: username)]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)

            //this is a bit confusing but the username is the email
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )

            if signUpResult.isSignUpComplete {
                reset()
                state = .login
            } else {
                state = .verifyCode
            }
        } catch let error as PlayerError {
            AlertManager.presentAlert(message: error.errorDescription)
            state = .login
        } catch let error as AuthError {
            AlertManager.presentAlert(message: error.errorDescription)
            state = .login
        } catch {
            AlertManager.presentAlert()
            state = .login
        }
    }
    
    func verifySignUp(with confirmationCode: String) async {
        state = .loading
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: email,
                confirmationCode: confirmationCode
            )
            
            if confirmSignUpResult.isSignUpComplete {
                await signIn()
            }
        } catch let error as AuthError{
            AlertManager.presentAlert(message: error.errorDescription)
        } catch {
            AlertManager.presentAlert()
        }
        state = .login
    }
    
    func resendSignUpCode() async {
        state = .loading
        do {
           _ = try await Amplify.Auth.resendSignUpCode(for: email)
        } catch let error as AuthError{
            AlertManager.presentAlert(message: error.errorDescription)
        } catch {
            AlertManager.presentAlert()
        }
        state = .verifyCode
    }
    
    func signIn() async {
        state = .loading
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            if signInResult.isSignedIn {
                reset()
                state = .login
            } else {
                state = .verifyCode
            }
        } catch let error as AuthError{
            AlertManager.presentAlert(message: error.errorDescription)
            state = .login
        } catch {
            AlertManager.presentAlert()
            state = .login
        }
    }
  
    func reset() {
        email = ""
        username = ""
        password = ""
        confirmedPassword = ""
        state = .login
    }
    
    func signOut() async {
       _ = await Amplify.Auth.signOut()
    }
}
