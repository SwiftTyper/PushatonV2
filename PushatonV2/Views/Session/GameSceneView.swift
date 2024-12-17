//
//  GameSceneView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import SwiftUI
import SceneKit

struct GameSceneView: UIViewRepresentable {
    @Binding var isGameShown: Bool
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView(frame: .zero)
        let gameController = GameController(sceneView: sceneView, isGameShown: $isGameShown)
        sceneView.delegate = gameController
        context.coordinator.gameController = gameController
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var gameController: GameController?
    }
}
