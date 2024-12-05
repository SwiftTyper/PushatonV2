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
        scene = .init()
        sceneView.delegate = self
        sceneView.scene = scene
        sceneView.backgroundColor = .skyBlue
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showPhysicsShapes]
        scene.physicsWorld.contactDelegate = self
    }
}
