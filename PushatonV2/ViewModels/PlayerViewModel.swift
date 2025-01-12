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
    
    var isLoading: Bool = false

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
    
    func makeGameReady() async {
        do {
            isLoading = true
            player?.score = 0
            player?.isPlayerAlive = true
            guard let player = player else { return }
            _ = try await Amplify.API.mutate(request: .update(player))
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
        }
    }
  
    func updateScore() -> Int {
        guard player != nil else { return 0 }
        let newScore = (player!.score ?? 0) + 1
        
        if newScore > player?.highScore {
            player?.highScore = newScore
        }
        
        player!.score = newScore
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
    
    private func initialOpponentFetch(id: String) async throws {
        self.opponent = try await PlayerManager.getPlayer(username: id, signedIn: true)
    }
    
    func createOpponentSubscription(id: String) {
        subscription = Amplify.API.subscribe(request: .subscription(of: Player.self, type: .onUpdate))
        guard let subscription = subscription else { return }
        Task {
            try await initialOpponentFetch(id: id)
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

//MARK: Debug
extension PlayerViewModel {
    func clearHighscore() async {
        do {
            player?.highScore = 0
            guard let player = player else { return }
            _ = try await Amplify.API.mutate(request: .update(player))
        } catch {
            print(error.localizedDescription)
        }
    }
}
