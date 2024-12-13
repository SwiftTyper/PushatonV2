//
//  GameView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI
import Amplify
import Authenticator

struct GameView: View {
    @State private var isGameShown = false
    @State var vm: GameViewModel = .init()
    
    var body: some View {
        if isGameShown {
            GameSceneView(isGameShown: $isGameShown)
                .ignoresSafeArea(.all)
        } else {
            Authenticator { state in
                VStack {
                    Button("Play Again") {
                        self.isGameShown = true
                    }
                    
                    Button("Create Game") {
                        Task { await vm.createGame() }
                    }
                    
                    Button("List Games") {
                        Task { await vm.listGames() }
                    }
                    
                    Button("Sign Out") {
                        Task { await state.signOut() }
                    }
                    
                    List {
                        ForEach(vm.games, id: \.id) { game in
                            Text(game.id)
                        }
                        .onDelete { indexSet in
                            Task { await vm.deleteGames(indexSet: indexSet) }
                        }
                    }
                    .task {
                        await vm.listGames()
                    }
                }
            }
        }
    }
}
