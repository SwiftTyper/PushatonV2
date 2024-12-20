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
    var isLoading: Bool = false
    
    func isUsernameUnique(username: String) -> Bool {
        return true
    }
    
    func reset() {
        email = ""
        username = ""
        password = ""
        confirmedPassword = ""
        state = .login
    }
    
    func signUp() async {
        isLoading = true
        do {
            guard isUsernameUnique(username: username) else {
                return
            }
            let userAttributes = [AuthUserAttribute(.preferredUsername, value: username)]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)

            //this is a bit confusing but username is the email
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )

            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                state = .verifyCode
            } else {
                reset()
            }
        } catch {
            
        }
        isLoading = false
    }
    
    func verifySignUp(with confirmationCode: String) async {
        isLoading = true
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: email,
                confirmationCode: confirmationCode
            )
            
            if confirmSignUpResult.isSignUpComplete {
                reset()
            }
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        isLoading = false
    }
    
    func resendSignUpCode() async {
        isLoading = true
        do {
           _ = try await Amplify.Auth.resendSignUpCode(for: email)
        } catch {
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    func signIn() async {
        isLoading = true
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            if signInResult.isSignedIn {
                reset()
                print("Sign in succeeded")
            } else {
                state = .verifyCode
                print(signInResult)
                print("wtf")
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
       _ = await Amplify.Auth.signOut()
        isLoading = false
    }
    
    func getLoggedInUserId() async throws -> String {
        do {
            let currentUser = try await Amplify.Auth.getCurrentUser()
            print(currentUser.username)
            return currentUser.userId
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
}
