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
    var isLoggedIn: Bool = false
    var unsubscribeToken: UnsubscribeToken?
    
    init() {
        self.unsubscribeToken = Amplify.Hub.listen(to: .auth) { [weak self] payload in
            switch payload.eventName {
            case HubPayload.EventName.Auth.signedIn:
                print("User signed in")
                    self?.isLoggedIn = true
                
                // Update UI

            case HubPayload.EventName.Auth.sessionExpired:
                print("Session expired")
                    self?.isLoggedIn = false
                // Re-authenticate the user

            case HubPayload.EventName.Auth.signedOut:
                print("User signed out")
                    self?.isLoggedIn = false
                // Update UI

            case HubPayload.EventName.Auth.userDeleted:
                print("User deleted")
                    self?.isLoggedIn = false
                // Update UI

            default:
                break
            }
        }
    }
    
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
            } else {
                print("SignUp Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
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
        do {
            let result = await Amplify.Auth.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
