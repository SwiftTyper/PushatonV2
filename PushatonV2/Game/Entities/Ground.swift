//
//  Ground.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Ground: SCNNode {
    override init() {
        super.init()
        let floor = SCNFloor()
        floor.firstMaterial?.diffuse.contents = UIColor.clear
        floor.reflectivity = 0.1
        
        geometry = floor
        
        let physicsShape = SCNPhysicsShape(geometry: floor, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        position = SCNVector3(0, 0, 0)
        physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        physicsBody?.allowsResting = true
        
        physicsBody?.contactTestBitMask = CollisionCategory.ground.rawValue
        physicsBody?.collisionBitMask = CollisionCategory.ground.rawValue
        physicsBody?.categoryBitMask = CollisionCategory.ground.rawValue

        physicsBody?.isAffectedByGravity = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Ground {
    static func setup(_ gameController: GameController) {
        gameController.scene.rootNode.addChildNode(Ground())
    }
}
