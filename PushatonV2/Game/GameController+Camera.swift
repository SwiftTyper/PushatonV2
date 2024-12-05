//
//  GameController+Camera.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/12/2024.
//

import Foundation
import SceneKit

extension GameController {
    func setupCamera() {
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 6, 12)
        cameraNode.eulerAngles = SCNVector3(x: Calculator.toRadians(angle: -15), y: 0, z: 0)
        scene.rootNode.addChildNode(cameraNode)
    }
}
