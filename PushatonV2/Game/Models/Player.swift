//
//  Player.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Player: SCNNode {
    var isManuvering: Bool = false
    
    init(size: CGFloat = 1.0) {
        super.init()
        let playerGeometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        playerGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        geometry = playerGeometry
        
        let physicsShape = SCNPhysicsShape(geometry: playerGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        physicsBody = .init(type: .kinematic, shape: physicsShape)
        physicsBody?.categoryBitMask = CollisionCategory.player.rawValue
        physicsBody?.contactTestBitMask = CollisionCategory.obstacle.rawValue
        physicsBody?.collisionBitMask = CollisionCategory.obstacle.rawValue
    }
    
    func setup(_ gameController: GameController) {
        let size: Float = self.boundingBox.max.y - self.boundingBox.min.y
        position = .init(x: 0, y: gameController.lane.boundingBox.max.y + size/2, z: 0)
        gameController.scene.rootNode.addChildNode(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
