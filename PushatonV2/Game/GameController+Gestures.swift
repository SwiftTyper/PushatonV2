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
            
            player.runAction(jumpAction) { [weak self] in
                self?.isPlayerManeuvering = false
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

