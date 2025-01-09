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
    private var isHit: Bool = false
    static let size: CGFloat = 1
    
    override init() {
        super.init()
        let playerGeometry = SCNBox(width: PlayerNode.size, height: PlayerNode.size, length: PlayerNode.size, chamferRadius: 0)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerNode: Collidable {
    func didCollide(with node: SCNNode, _ gameController: GameController) {
        switch node {
            case is Obstacle:
                self.die(removeHeart: gameController.hud.removeHeart, onFinalDeath: gameController.gameOver)
            default: return
        }
    }
}

extension PlayerNode {
    func jump() {
        guard !isManeuvering else { return  }
        isManeuvering = true
        let moveUpAction = SCNAction.moveBy(x: 0, y: 2, z: 0, duration: 0.4)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 0.3)
        moveUpAction.timingMode = .easeOut
        moveDownAction.timingMode = .easeIn
        let jumpAction = SCNAction.sequence([moveUpAction,moveDownAction])
        
        self.runAction(jumpAction) { [weak self] in
            self?.isManeuvering = false
        }
    }
    
    func die(removeHeart: @escaping () -> Bool, onFinalDeath: @escaping () -> Void) {
        guard !isHit else { return }
        isHit = true
        
        if removeHeart() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isHit = false
            }
        } else {
            onFinalDeath()
            isManeuvering = false
        }
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
        position = .init(x: 0, y: Lane.segmentHeight + size/2, z: 0)
        gameController.scene.rootNode.addChildNode(self)
    }
}
