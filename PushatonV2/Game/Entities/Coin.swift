//
//  Coin.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/01/2025.
//

import Foundation
import SceneKit

class Coin: SCNNode {
    static let radius: CGFloat = 0.3
    
    override init() {
        super.init()
        setupCoin(radius: Coin.radius)
        setupPhysics(radius: Coin.radius)
        startSpinAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoin(radius: CGFloat) {
        let coinGeometry = SCNCylinder(radius: radius, height: 0.05)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        material.metalness.contents = 1.0
        material.roughness.contents = 0.2
        material.specular.contents = UIColor.white
        
        let edgeMaterial = SCNMaterial()
        edgeMaterial.diffuse.contents = UIColor(red: 0.85, green: 0.65, blue: 0.0, alpha: 1.0)
        edgeMaterial.metalness.contents = 1.0
        edgeMaterial.roughness.contents = 0.3
        
        coinGeometry.materials = [edgeMaterial, material, material]
        
        self.geometry = coinGeometry
        self.name = "coin"
        
        self.eulerAngles.x = Float.pi / 2
    }
    
    private func setupPhysics(radius: CGFloat) {
        let shape = SCNPhysicsShape(geometry: self.geometry!, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        self.physicsBody?.categoryBitMask = CollisionCategory.coin.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        self.physicsBody?.isAffectedByGravity = false
    }
    
    private func startSpinAnimation() {
        let rotationAnimation = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 1.5)
        )
        self.runAction(rotationAnimation)
    }
}

// MARK: - Coin Spawning and Movement
extension Coin {
    static func spawnCoins(scene: SCNScene, obstacle: SCNNode, data: ObstacleData) {
        guard Int.random(in: 0..<3) == 0 else { return }
        
        let type = Arrangement.getRandom(isLow: data.isLow)
        let baseY: Float = Lane.segmentHeight + Float(PlayerNode.size/2)
        let spacing: Float = 3.0
        
        switch type {
        case .straight:
            let length = Bool.random() ? 6 : 4
            for i in 1...length {
                let coin = Coin()
                let z = obstacle.position.z + Float(i) * spacing
                coin.position = SCNVector3(obstacle.position.x, baseY, z)
                
                let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
                coin.runAction(SCNAction.repeatForever(moveAction))
                
                scene.rootNode.addChildNode(coin)
            }
        case .doubleStraight:
            for j in 0..<2 {
                for i in 1...6 {
                    let coin = Coin()
                    let z = obstacle.position.z + Float(i) * spacing
                    let y = baseY + Float(j) * 1.0
                    coin.position = SCNVector3(obstacle.position.x, y, z)
                    
                    let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
                    coin.runAction(SCNAction.repeatForever(moveAction))
                    
                    scene.rootNode.addChildNode(coin)
                }
            }
            case .arc:
                let radius: Float = 2.5
                for i in 0..<5 {
                    let angle = Float(i) * (.pi / 4)
                    let z = obstacle.position.z + radius * cos(angle)
                    let y = baseY + radius * sin(angle)
                    let coin = Coin()
                    coin.position = SCNVector3(obstacle.position.x, y, z)
                    
                    let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
                    coin.runAction(SCNAction.repeatForever(moveAction))
                    
                    scene.rootNode.addChildNode(coin)
                }
            }
    }
    
    static func update(_ gameController: GameController) {
        gameController.scene.rootNode.enumerateChildNodes { node, _ in
            guard node.name == "coin" else { return }
         
            if node.position.z > gameController.camera.position.z + Float(Coin.radius) {
                node.removeFromParentNode()
            }
        }
    }
    
    static func collect(node: SCNNode) {
        node.removeFromParentNode()
    }
}

// MARK: - Arrangement Types
extension Coin {
    enum Arrangement {
        case straight
        case doubleStraight
        case arc
        
        static func getRandom(isLow: Bool) -> Arrangement {
            let randomNumber = Int.random(in: 1...7)
            
            switch randomNumber {
                case 1...4:
                    return .straight
                case 5, 6:
                    return isLow ? .arc : .straight
                default:
                    return .doubleStraight
            }
        }
    }
}
