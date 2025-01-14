//
//  GameController+Scene.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit
import SpriteKit

extension GameController {
    func setupScene() {
        sceneView.delegate = self
        
        scene = .init()
        scene.physicsWorld.contactDelegate = self
        
        let skySphere = SCNSphere(radius: 1000)
              
        let skyMaterial = SCNMaterial()
        skyMaterial.diffuse.contents = UIColor.skyBlue
        skyMaterial.isDoubleSided = true
        skySphere.materials = [skyMaterial]
          
        let skyNode = SCNNode(geometry: skySphere)
        skyNode.renderingOrder = -1
        scene.rootNode.addChildNode(skyNode)
      
        scene.fogStartDistance = 20
        scene.fogEndDistance = 80
        scene.fogDensityExponent = 1.5
        scene.fogColor = UIColor(white: 0.7, alpha: 0.7) as Any
       
        sceneView.backgroundColor = .skyBlue
        sceneView.allowsCameraControl = false
//        sceneView.showsStatistics = true
//        sceneView.debugOptions = [.showPhysicsShapes]
        sceneView.isPlaying = true
        
        DispatchQueue.main.async {
            self.hud = .init(with: self.sceneView.bounds.size)
            self.sceneView.overlaySKScene = self.hud
            self.sceneView.overlaySKScene?.isHidden = false
            self.sceneView.overlaySKScene?.scaleMode = .resizeFill
            self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
        }
        
        sceneView.present(scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
    }
}
