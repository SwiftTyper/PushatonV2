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
        
        handleCollision(of: nodeA, with: nodeB)
        handleCollision(of: nodeB, with: nodeA)
    }
    
    func handleCollision(of nodeOne: SCNNode, with nodeTwo: SCNNode) {
        if let nodeOne = nodeOne as? Collidable {
            nodeOne.didCollide(with: nodeTwo, self)
        } else {
            print("Node with unhandled collision!")
        }
    }
}
