//
//  Obsticles.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Obstacle: SCNNode {
    static private let length: Float = 0.3
    static private let spacing: Float = 40
    static private var index: Int = 0
    static private var obstacles: [Obstacle] = []
    
    init(with data: ObstacleData) {
        super.init()
        setupObstacle(with: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupObstacle(with data: ObstacleData) {
        let barHeight: Float = data.isLow ? 1 : 2
        let barGeometry = SCNBox(width: 4, height: CGFloat(barHeight), length: CGFloat(Obstacle.length), chamferRadius: 0.05)
        barGeometry.firstMaterial?.diffuse.contents = data.isLow ? UIColor.red : UIColor.yellow
        self.geometry = barGeometry
        self.name = "obstacle"
        self.position = SCNVector3(x: 0, y: Float(data.isLow ? barHeight * 0.5 : 0.5 + 0.1 + (barHeight * 0.5)), z: 0)
        
        let physicsShape = SCNPhysicsShape(geometry: barGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        self.physicsBody?.categoryBitMask = CollisionCategory.obstacle.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        
        self.position.y += Lane.segmentHeight
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
        self.runAction(SCNAction.repeatForever(moveAction))
    }
}

extension Obstacle {
    static func update(_ gameController: GameController) {
        gameController.scene.rootNode.enumerateChildNodes { node, _ in
            guard node.name == "obstacle" else { return }
            
            if node.position.z > gameController.camera.position.z + Float(length/2) {
                node.removeAllActions()
                node.removeFromParentNode()
                if let index = obstacles.firstIndex(where: { $0 === node as? Obstacle }) {
                    obstacles.remove(at: index)
                }
            }
        }
        
        if (obstacles.last?.position.z ?? .zero) > -gameController.camera.lastVisibleZPosition {
            guard let gameObstacles = gameController.gameMatchViewModel.game?.obstacles else {
                return
            }
            let safeIndex = index % gameObstacles.count
            let obstacleData = gameObstacles[safeIndex]
            createObstacle(with: obstacleData, gameController)
            index += 1
        }
    }
    
    static func setup(_ gameController: GameController) {
        let segmentLength = Obstacle.length + Obstacle.spacing
        let numberOfObstacles = Int(ceil(gameController.camera.lastVisibleZPosition / segmentLength))
        guard let gameObstacles = gameController.gameMatchViewModel.game?.obstacles else { return }
        let visibleObstacles = gameObstacles.prefix(numberOfObstacles)
        
        for obstacleData in visibleObstacles {
            createObstacle(with: obstacleData, gameController)
        }
    }
    
    private static func createObstacle(with data: ObstacleData, _ gameController: GameController) {
        let node = Obstacle(with: data)
        
        if !obstacles.isEmpty, let lastPosition = obstacles.last?.position.z {
            node.position.z = lastPosition - (spacing + length)
        } else {
            node.position.z = -(spacing * 2 + length/2)
        }
        
        obstacles.append(node)
        gameController.scene.rootNode.addChildNode(node)
        Coin.spawnCoins(scene: gameController.scene, obstacle: node, data: data)
    }
}
