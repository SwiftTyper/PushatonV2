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
                     Task {
                         do {
                             try await self?.createPlayerIfMissing()
                         } catch {
                             print(error.localizedDescription)
                         }
                     }
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
            guard self.state == .loggedIn else { return }
            try await createPlayerIfMissing()
        } catch {
            print("Failed to fetch auth session: \(error)")
            self.state = .notDetermined
        }
    }
    
    func createPlayerIfMissing() async throws {
        let attributes = try await Amplify.Auth.fetchUserAttributes()
        let username = attributes.first(where: { $0.key == AuthUserAttributeKey.preferredUsername })?.value
        guard let username = username else { return }
        guard try await PlayerManager.doesPlayerExist(username: username) == false else { return }
        await PlayerManager.createPlayer(username: username)
    }
}

