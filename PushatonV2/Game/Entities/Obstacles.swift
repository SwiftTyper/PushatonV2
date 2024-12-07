//
//  Obsticles.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Obstacle {
    private var obstacles: [SCNNode] = []
    private let lenght: CGFloat = 0.3
    
    init() {
        
    }
    
    func getFucked() -> SCNNode {
        let isLowObstacle = Bool.random()
        let barHeight: Float = isLowObstacle ? 1 : 2
        let barGeometry = SCNBox(width: 4, height: CGFloat(barHeight), length: lenght, chamferRadius: 0.05)
        barGeometry.firstMaterial?.diffuse.contents = isLowObstacle ? UIColor.red : UIColor.yellow
        let node = SCNNode(geometry: barGeometry)
        node.position = SCNVector3(x: 0, y: Float(isLowObstacle ? barHeight * 0.5 : 0.5 + 0.1 + (barHeight * 0.5)), z: 0)
        
        let physicsShape = SCNPhysicsShape(geometry: barGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        node.physicsBody?.categoryBitMask = CollisionCategory.obstacle.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        return node
    }
    
    private func createObstacle(_ gameController: GameController) {
        let newObstacle = getFucked()
        let spacing: Float = spacing(gameController)
        let obstacleLength = newObstacle.boundingBox.max.z - newObstacle.boundingBox.min.z
        
        newObstacle.position.y += gameController.lane.boundingBox.max.y
        
        if !obstacles.isEmpty, let startPosition = obstacles.last?.position.z, startPosition < (spacing * 2 + obstacleLength/2) {
            newObstacle.position.z = startPosition - (spacing + obstacleLength)
        } else {
            newObstacle.position.z = -(spacing * 2 + obstacleLength/2)
        }
        
        obstacles.append(newObstacle)
        gameController.scene.rootNode.addChildNode(newObstacle)
    }
//    
    func update(_ gameController: GameController) {
        for obstacle in obstacles {
            if obstacle.position.z > gameController.camera.position.z + Float(lenght/2) {
                obstacles.removeFirst()
                obstacle.removeFromParentNode()
            } else {
                obstacle.position.z += gameController.speed
            }
        }
        
        if (obstacles.last?.position.z ?? .zero) < gameController.camera.lastVisibleZPosition {
            createObstacle(gameController)
        }
    }
    
    func spacing(_ gameController: GameController) -> Float {
        //MARK: To Do calculate spacing based on speed ensuring jump is always possible
        return 30
    }
    
    func setup(_ gameController: GameController) {
        obstacles = []
        let segmentLenght = Float(lenght) + spacing(gameController)
        let numberOfObstacles = Int(ceil(gameController.camera.lastVisibleZPosition / segmentLenght))
        for _ in 0..<numberOfObstacles {
            createObstacle(gameController)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
