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
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(_:)))
        swipeUp.direction = .up
        sceneView.addGestureRecognizer(swipeUp)
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if sceneView.isPlaying {
            player.jump()
        } else {
//            isGameShown = false
        }
    }
    
    @objc private func handleSwipeUp(_ gesture: UISwipeGestureRecognizer) {
        guard sceneView.isPlaying else { return }
        player.jump()
    }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        guard sceneView.isPlaying else { return }
        player.dash()
    }
}
