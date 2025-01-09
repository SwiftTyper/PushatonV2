//
//  PlayerViewModel.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 25/12/2024.
//

import Foundation
import Observation
import Amplify

@MainActor
@Observable
class PlayerViewModel {
    var player: Player? = nil
    var opponent: Player? = nil
    var subscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Player>>?
    var playerId: String { player?.username ?? "" }
    
    init() {
        Task { await createPlayerIfMissing() }
    }
    
    deinit {
        Task { @MainActor [weak self] in
            self?.cancelSubscription()
        }
    }
    
    func die() async {
        do {
            guard player?.isPlayerAlive == true else { return }
            player?.isPlayerAlive = false
            guard let player = player else { return }
            _ = try await Amplify.API.mutate(request: .update(player))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setAlive() async {
        do {
            player?.isPlayerAlive = true
            guard let player = player else { return }
            _ = try await Amplify.API.mutate(request: .update(player))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func resetScore() async {
        do {
            player?.score = 0
            guard let player = player else { return }
            _ = try await Amplify.API.mutate(request: .update(player))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateScore() -> Int {
        // First check if player exists
        guard player != nil else { return 0 }
        
        // Create new score based on current optional score
        let newScore = (player!.score ?? 0) + 1
        // Update the original player's score
        player!.score = newScore
        
        // Create a copy for the async task
        let updatedPlayer = player!
        
        Task { @MainActor in
            do {
                _ = try await Amplify.API.mutate(request: .update(updatedPlayer))
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return newScore
    }
    
    private func createPlayerIfMissing() async {
        do {
            let attributes = try await Amplify.Auth.fetchUserAttributes()
            let username = attributes.first(where: { $0.key == AuthUserAttributeKey.preferredUsername })?.value
            guard let username = username else { return }
            
            if let player = try await PlayerManager.getPlayer(username: username, signedIn: true) {
                self.player = player
            } else {
                self.player = try await PlayerManager.createPlayer(username: username)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createOpponentSubscription(id: String) {
        subscription = Amplify.API.subscribe(request: .subscription(of: Player.self, type: .onUpdate))
        guard let subscription = subscription else { return }
        Task {
            do {
                for try await subscriptionEvent in subscription {
                    switch subscriptionEvent {
                        case .connection(_): break
                        case .data(let result):
                            switch result {
                                case .success(let updatedPlayer):
                                    if updatedPlayer.username == id {
                                        self.opponent = updatedPlayer
                                    }
                                    print("Got update")
                                case .failure(let error):
                                    print("Got failed result with \(error.errorDescription)")
                            }
                        }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }
    
    func cancelSubscription() {
        subscription?.cancel()
    }
}
