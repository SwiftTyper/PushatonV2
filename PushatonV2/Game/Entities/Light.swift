//
//  Lighting.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Light {
    func setup(_ gameController: GameController) {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 500
        gameController.scene.rootNode.addChildNode(ambientLight)
        
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.position = SCNVector3(5, 10, 10)
        directionalLight.eulerAngles = SCNVector3(-Float.pi/4, Float.pi/4, 0)
        gameController.scene.rootNode.addChildNode(directionalLight)
    }
}
