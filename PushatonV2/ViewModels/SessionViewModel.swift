////
////  SessionViewModel.swift
////  PushatonV2
////
////  Created by Wit Owczarek on 17/12/2024.
////
//
import Foundation
import Amplify
import Observation
import Combine

@MainActor
@Observable
class SessionViewModel {
    var state: LoginStatus = .notDetermined
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        Task { await checkInitialStatus() }
        setupListener()
    }
    
    private func setupListener() {
        Amplify.Hub.publisher(for: .auth)
             .sink { [weak self] payload in
                 switch payload.eventName {
                 case HubPayload.EventName.Auth.signedIn:
                        self?.state = .loggedIn
                     print("User signed in")
                     
                 case HubPayload.EventName.Auth.signedOut:
                         self?.state = .loggedOut
                     print("User signed out")
                     
                 case HubPayload.EventName.Auth.sessionExpired:
                         self?.state = .loggedOut
                     print("Session expired")
                     
                 default:
                     break
                 }
             }
             .store(in: &cancellables)
    }
    
    private func checkInitialStatus() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            self.state = session.isSignedIn ? .loggedIn : .loggedOut
        } catch {
            print("Failed to fetch auth session: \(error)")
            self.state = .notDetermined
        }
    }
}
