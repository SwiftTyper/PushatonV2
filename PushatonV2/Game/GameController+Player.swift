//
//  GameController+Player.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/12/2024.
//

import Foundation
import SceneKit

extension GameController {
    func setupPlayer() {
        let playerGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        playerGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        player = SCNNode(geometry: playerGeometry)
        player.position = .init(x: 0, y: 0.5, z: 0)
        
        let physicsShape = SCNPhysicsShape(geometry: playerGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        player.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        player.physicsBody?.categoryBitMask = CollisionCategory.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionCategory.obstacle.rawValue
        player.physicsBody?.collisionBitMask = CollisionCategory.obstacle.rawValue
        
        scene.rootNode.addChildNode(player)
    }
}
