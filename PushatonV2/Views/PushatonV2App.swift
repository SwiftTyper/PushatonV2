//
//  PushatonV2App.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 01/12/2024.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin

@main
struct PushatonV2App: App {
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure(with: .amplifyOutputs)
            print("Success")
        } catch {
            print("Failed")
        }
    }
}
