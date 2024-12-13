//
//  Player.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class PlayerNode: SCNNode {
    private var isManeuvering: Bool = false
    
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
    
    func jump() {
        guard !isManeuvering else { return  }
        isManeuvering = true
        let moveUpAction = SCNAction.moveBy(x: 0, y: 1.5, z: 0, duration: 0.4)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -1.5, z: 0, duration: 0.3)
        moveUpAction.timingMode = .easeOut
        moveDownAction.timingMode = .easeIn
        let jumpAction = SCNAction.sequence([moveUpAction,moveDownAction])
        
        self.runAction(jumpAction) { [weak self] in
            self?.isManeuvering = false
        }
    }
    
    func die() {
        isManeuvering = false
    }
    
    func dash() {
        guard !isManeuvering else { return }
        isManeuvering = true
        
        self.squashAndUnsquashHeight(durationPerAction: 0.20, intervalBetweenActions: 0.3) {
            self.isManeuvering = false
        }
    }
    
    func setup(_ gameController: GameController) {
        let size: Float = self.boundingBox.max.y - self.boundingBox.min.y
        position = .init(x: 0, y: gameController.lane.segmentHeight + size/2, z: 0)
        gameController.scene.rootNode.addChildNode(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
