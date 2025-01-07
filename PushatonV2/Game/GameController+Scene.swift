//
//  GameController+Scene.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

extension GameController {
    func setupScene() {
        sceneView.delegate = self
        
        scene = .init()
        scene.physicsWorld.contactDelegate = self
       
        sceneView.backgroundColor = .skyBlue
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showPhysicsShapes]
        sceneView.isPlaying = true
        
        DispatchQueue.main.async {
            self.hud = .init(with: self.sceneView.bounds.size)
            self.sceneView.overlaySKScene = self.hud
            self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
        }
       
        sceneView.present(scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
    }
}
