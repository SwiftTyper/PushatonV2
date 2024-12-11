//
//  PushatonV2App.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 01/12/2024.
//

import SwiftUI
import Amplify

@main
struct PushatonV2App: App {
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            GameView()
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.configure(with: .amplifyOutputs)
            print("Success")
        } catch {
            print("Failed")
        }
    }
}
