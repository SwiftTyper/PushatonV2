//
//  SCNNode+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

extension SCNNode {
    func squashAndUnsquashHeight(
        durationPerAction: TimeInterval,
        intervalBetweenActions: TimeInterval,
        completionHandler: @escaping () -> Void = {}
    ) {
        // Store the original height and position
        let originalHeight = (self.boundingBox.max.y - self.boundingBox.min.y)
        let originalY = self.position.y
        
        let squashDown = SCNAction.customAction(duration: durationPerAction) { (node, elapsedTime) in
            let percentage = elapsedTime / durationPerAction
            // Scale down height
            let scale = Float(1.0 - (0.5 * percentage))
            let box = node.geometry as? SCNBox
            box?.height = CGFloat(originalHeight * scale)
            // Move down to keep top in place
            
            if let oldPhysicsBody = node.physicsBody {
                node.physicsBody = SCNPhysicsBody(
                    type: oldPhysicsBody.type,
                    shape: SCNPhysicsShape(
                        geometry: box!,
                        options: nil
                    )
                )
            }
            
            let heightDifference = originalHeight * Float(0.5 * percentage)
            node.position.y = originalY - (heightDifference*0.5)
        }
        
        let waitAction = SCNAction.wait(duration: intervalBetweenActions)
        
        let unsquash = SCNAction.customAction(duration: durationPerAction) { (node, elapsedTime) in
            let percentage = elapsedTime / durationPerAction
            // Scale back up
            let scale = Float(0.5 + (0.5 * percentage))
            let box = node.geometry as? SCNBox
            box?.height = CGFloat(originalHeight * scale)
            
            if let oldPhysicsBody = node.physicsBody {
                node.physicsBody = SCNPhysicsBody(
                    type: oldPhysicsBody.type,
                    shape: SCNPhysicsShape(
                        geometry: box!,
                        options: nil
                    )
                )
            }
            
            // Move back up as height increases
            let heightDifference = originalHeight * Float(0.5 * (1 - percentage))
            node.position.y = originalY - (heightDifference*0.5)
        }
        
        let sequence = SCNAction.sequence([squashDown, waitAction, unsquash])
        
        self.runAction(sequence, completionHandler: completionHandler)
    }
}
