//
//  Obsticles.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Obstacle: SCNNode {
    private var obstacles: [Obstacle] = []
    private var timer: Timer?
    
    override init() {
        super.init()
        
        let isLowObstacle = Bool.random()
        let barHeight: Float = isLowObstacle ? 1 : 2
        let barGeometry = SCNBox(width: 4, height: CGFloat(barHeight), length: 0.3, chamferRadius: 0.05)
        barGeometry.firstMaterial?.diffuse.contents = isLowObstacle ? UIColor.red : UIColor.yellow
        
        let obstacle = SCNNode(geometry: barGeometry)
        let yPosition: Float = Float(isLowObstacle ? barHeight * 0.5 : 0.5 + 0.1 + (barHeight * 0.5))
        obstacle.position = SCNVector3(0, yPosition, -30)
        
        let physicsShape = SCNPhysicsShape(geometry: barGeometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        obstacle.physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
        obstacle.physicsBody?.categoryBitMask = CollisionCategory.obstacle.rawValue
        obstacle.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        obstacle.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        
        self.addChildNode(obstacle)
    }
    
    func createObstacles(in scene: SCNScene) {
        let newObstacle = Obstacle()
        let moveForward = SCNAction.moveBy(x: 0, y: 0, z: 40, duration: 2.0)
        newObstacle.runAction(moveForward)
        scene.rootNode.addChildNode(newObstacle)
        obstacles.append(newObstacle)
    }
    
    func removeUnusedObstacles() {
        obstacles = obstacles.filter { obstacle in
            if obstacle.position.z > 10 {
                obstacle.removeFromParentNode()
                return false
            }
            return true
        }
    }
   
    func setup(_ gameController: GameController) {
        createObstacles(in: gameController.scene)
        startObstacleSpawnTimer(gameController)
    }
    
    func startObstacleSpawnTimer(_ gameController: GameController) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { timer in
            guard gameController.state == .playing else { return }
            self.createObstacles(in: gameController.scene)
        })
    }
    
    func cleanup() {
       timer?.invalidate()
       timer = nil
       obstacles.forEach { $0.removeFromParentNode() }
       obstacles.removeAll()
    }
    
    deinit {
        cleanup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
