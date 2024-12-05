//
//  GameController+Gestures.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/12/2024.
//

import Foundation
import SceneKit

extension GameController {
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown(_:)))
        swipeDown.direction = .down
        sceneView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        swipeUp.direction = .up
        sceneView.addGestureRecognizer(swipeUp)
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if state == .menu {
            state = .playing
        } else if state == .gameOver {
            state = .playing
            initGame()
        } else if state == .playing, !isPlayerManeuvering {
            isPlayerManeuvering = true
            let moveUpAction = SCNAction.moveBy(x: 0, y: 1.5, z: 0, duration: 0.4)
            let moveDownAction = SCNAction.moveBy(x: 0, y: -1.5, z: 0, duration: 0.3)
            moveUpAction.timingMode = .easeOut
            moveDownAction.timingMode = .easeIn
            let jumpAction = SCNAction.sequence([moveUpAction,moveDownAction])
            player.runAction(jumpAction) {
                self.isPlayerManeuvering = false
            }
        }
    }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        guard state == .playing, !isPlayerManeuvering else { return }
        
        isPlayerManeuvering = true
        
        player.squashAndUnsquashHeight(durationPerAction: 0.20, intervalBetweenActions: 0.3) {
            self.isPlayerManeuvering = false
        }
    }
}

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
