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
    private let length: Float = 0.3
    private var index: Int = 0
    
    init() { }
    
    private func createObstacle(with data: ObstacleData, _ gameController: GameController) {
        let barHeight: Float = data.isLow ? 1 : 2
        let barGeometry = SCNBox(width: 4, height: CGFloat(barHeight), length: CGFloat(length), chamferRadius: 0.05)
        barGeometry.firstMaterial?.diffuse.contents = data.isLow ? UIColor.red : UIColor.yellow
        let node = SCNNode(geometry: barGeometry)
        node.position = SCNVector3(x: 0, y: Float(data.isLow ? barHeight * 0.5 : 0.5 + 0.1 + (barHeight * 0.5)), z: 0)
        
        let physicsShape = SCNPhysicsShape(geometry: barGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        node.physicsBody?.categoryBitMask = CollisionCategory.obstacle.rawValue
        node.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        node.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        
        let spacing: Float = spacing(gameController)
        node.position.y += gameController.lane.segmentHeight
        
        if !obstacles.isEmpty, let startPosition = obstacles.last?.position.z, startPosition < (spacing * 2 + length/2) {
            node.position.z = startPosition - (spacing + length)
        } else {
            node.position.z = -(spacing * 2 + length/2)
        }
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
        node.runAction(SCNAction.repeatForever(moveAction))
        
        index+=1
        obstacles.append(node)
        gameController.scene.rootNode.addChildNode(node)
    }
    
    func update(_ gameController: GameController) {
        for obstacle in obstacles {
            if obstacle.position.z > gameController.camera.position.z + Float(length/2) {
                obstacles.removeFirst()
                obstacle.removeAllActions()
                obstacle.removeFromParentNode()
            }
        }
        
        if (obstacles.last?.position.z ?? .zero) > -gameController.camera.lastVisibleZPosition {
            guard let obstacles = gameController.gameMatchViewModel.game?.obstacles else {
                return
            }
            let safeIndex = index % obstacles.count
            let obstacle = obstacles[safeIndex]
            createObstacle(with: obstacle, gameController)
        }
    }
    
    //MARK: To Do calculate spacing based on speed ensuring jump is always possible
    func spacing(_ gameController: GameController) -> Float {
        return 30
    }
    
    func setup(_ gameController: GameController) {
        let segmentLenght = Float(length) + spacing(gameController)
        let numberOfObstacles = Int(ceil(gameController.camera.lastVisibleZPosition / segmentLenght))
        let obstacles = gameController.gameMatchViewModel.game?.obstacles ?? []
        let visibleObstacles = obstacles.dropFirst(numberOfObstacles)
        
        for obstacle in visibleObstacles {
            createObstacle(with: obstacle, gameController)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
