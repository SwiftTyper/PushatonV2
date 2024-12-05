//
//  GameController+Ground.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/12/2024.
//

import Foundation
import SceneKit

extension GameController {
    func setupGround() {
        let floor = SCNFloor()
//        floor.firstMaterial?.diffuse.contents = UIColor.green
        floor.reflectivity = 0.0
        
        let ground = SCNNode(geometry: floor)
        
        let physicsShape = SCNPhysicsShape(geometry: floor, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        ground.position = SCNVector3(0, 0, 0)
        ground.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        ground.physicsBody?.allowsResting = true
        
        ground.physicsBody?.contactTestBitMask = CollisionCategory.ground.rawValue
        ground.physicsBody?.collisionBitMask = CollisionCategory.ground.rawValue
        ground.physicsBody?.categoryBitMask = CollisionCategory.ground.rawValue

        ground.physicsBody?.isAffectedByGravity = false
        scene.rootNode.addChildNode(ground)
    }
}
