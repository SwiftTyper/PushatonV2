//
//  GameController+Obstacles.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/12/2024.
//

import Foundation
import SceneKit

extension GameController {
    func spawnObstacle() {
        let isLowObstacle = Bool.random()
        let barHeight: Float = isLowObstacle ? 1 : 2
        let barGeometry = SCNBox(width: 4, height: CGFloat(barHeight), length: 0.3, chamferRadius: 0.05)
        barGeometry.firstMaterial?.diffuse.contents = isLowObstacle ? UIColor.red : UIColor.yellow
        
        let obstacle = SCNNode(geometry: barGeometry)
        let yPosition: Float = Float(isLowObstacle ? barHeight * 0.5: 0.5 + 0.1 + (barHeight * 0.5))
        obstacle.position = SCNVector3(0, yPosition, -30)
        
        let physicsShape = SCNPhysicsShape(geometry: barGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        obstacle.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        obstacle.physicsBody?.categoryBitMask = CollisionCategory.obstacle.rawValue
        obstacle.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        obstacle.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        
        scene.rootNode.addChildNode(obstacle)
        
        let moveForward = SCNAction.moveBy(x: 0, y: 0, z: 40, duration: 2.0)
        let removeFromParent = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([moveForward, removeFromParent])
        
        obstacle.runAction(sequence)
    }
}
