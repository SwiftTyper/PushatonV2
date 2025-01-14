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
        Amplify.Hub.publisher(for: .auth).sink { [weak self] payload in
             switch payload.eventName {
                 case HubPayload.EventName.Auth.signedIn:
                     self?.state = .loggedIn
                 case HubPayload.EventName.Auth.signedOut:
                     self?.state = .loggedOut
                 case HubPayload.EventName.Auth.sessionExpired:
                     self?.state = .loggedOut
                 default:
                     break
             }
         }
         .store(in: &cancellables)
    }
    
    private func checkInitialStatus() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            let hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
            if session.isSignedIn {
                self.state = .loggedIn
            } else {
                self.state = hasSeenOnboarding ? .loggedOut : .onboarding
            }
        } catch {
            print("Failed to fetch auth session: \(error)")
            self.state = .notDetermined
        }
    }
    
    func setSeenOnboarding() {
        self.state = .loggedOut
        UserDefaults.standard.setValue(true, forKey: "hasSeenOnboarding")
    }
}
