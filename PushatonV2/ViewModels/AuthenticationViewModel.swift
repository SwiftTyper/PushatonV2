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
    
    var state: AuthStatus = .login
    
    func isUsernameUnique(username: String) -> Bool {
        return true
    }
    
    func signUp(
        username: String,
        password: String,
        email: String
    ) async {
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
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
                state = .codeConfirmation
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func verifySignUp(for email: String, with confirmationCode: String) async {
        do {
            try await getLoggedInUserId()
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: email,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func resendSignUpCode(email: String) async {
        do {
           _ = try await Amplify.Auth.resendSignUpCode(for: email)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(
                username: email,
                password: password
            )
            if signInResult.isSignedIn {
                print("Sign in succeeded")
            } else {
              state = .codeConfirmation
              print(signInResult)
              print("wtf")
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func signOut() async {
       _ = await Amplify.Auth.signOut()
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
