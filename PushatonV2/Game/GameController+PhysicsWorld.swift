//
//  GameController+PhysicsWorld.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/12/2024.
//

import Foundation
import SceneKit

extension GameController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        let isPlayerA = nodeA.physicsBody?.categoryBitMask == CollisionCategory.player.rawValue
        let isPlayerB = nodeB.physicsBody?.categoryBitMask == CollisionCategory.player.rawValue
        
        if (isPlayerA && nodeB.physicsBody?.categoryBitMask == CollisionCategory.obstacle.rawValue) ||
            (isPlayerB && nodeA.physicsBody?.categoryBitMask == CollisionCategory.obstacle.rawValue) {
            self.player.die(removeHeart: hud.removeHeart, onFinalDeath: gameOver)
        }
    }
}
