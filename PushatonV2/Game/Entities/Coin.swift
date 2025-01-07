//
//  Coin.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 03/01/2025.
//

import Foundation
import SceneKit

class Coin: SCNNode {
    static let radius: CGFloat = 0.4
    
    override init() {
        super.init()
        setupCoin(radius: Coin.radius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoin(radius: CGFloat) {
        let coinGeometry = SCNCylinder(radius: radius, height: 0.08)
        
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
        
        let shape = SCNPhysicsShape(geometry: self.geometry!, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        self.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        self.physicsBody?.categoryBitMask = CollisionCategory.coin.rawValue
        self.physicsBody?.contactTestBitMask = CollisionCategory.player.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.player.rawValue
        self.physicsBody?.isAffectedByGravity = false
        
        let rotationAnimation = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 3)
        )
        self.runAction(rotationAnimation)
    }
}

// MARK: - Coin Spawning and Movement
extension Coin {
    static func spawnCoins(scene: SCNScene, obstacle: SCNNode, data: ObstacleData) {
        guard let type = data.coinArrangement else { return }
        let baseY: Float = Lane.segmentHeight + Float(PlayerNode.size/2)
        let spacing: Float = 3.0
        
        switch type {
            case .straight:
                guard let lenght = data.coinValue else { return }
                for i in 1...lenght {
                    let coin = Coin()
                    let z = obstacle.position.z + Float(i) * spacing + spacing
                    coin.position = SCNVector3(obstacle.position.x, baseY, z)
                    
                    let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
                    coin.runAction(SCNAction.repeatForever(moveAction))
                    
                    scene.rootNode.addChildNode(coin)
                }
            case .doubleStraight:
                for j in 0..<2 {
                    for i in 1...6 {
                        let coin = Coin()
                        let z = obstacle.position.z + Float(i) * spacing + spacing
                        let y = baseY + Float(j) * 1.0
                        coin.position = SCNVector3(obstacle.position.x, y, z)
                        
                        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
                        coin.runAction(SCNAction.repeatForever(moveAction))
                        
                        scene.rootNode.addChildNode(coin)
                    }
                }
            case .arc:
                let radius: Float = 2
                let numberOfCoins: Int = 5
                for i in 0..<numberOfCoins {
                    let progress = Float(i) / Float(numberOfCoins - 1)
                    let angle = .pi * progress
                    let z = obstacle.position.z + radius * cos(angle) * 2
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
    
    static func collect(contact: SCNPhysicsContact, _ gameController: GameController) {
        var coinNode: SCNNode?
        if contact.nodeA.name == "coin" {
            coinNode = contact.nodeA
        } else if contact.nodeB.name == "coin" {
            coinNode = contact.nodeB
        }
        
        if let coin = coinNode {
            if coin.value(forKey: "collected") as? Bool != true {
                coin.removeFromParentNode()
                coin.setValue(true, forKey: "collected")
               
                let score = gameController.playerViewModel.updateScore()
                gameController.hud.updatePoints(with: score)
            }
        }
    }
    
    static func getRandomArrangement(isLow: Bool) -> (CoinArrangement?, Int?) {
        guard Bool.random(odds: 3) else { return (nil,nil) }
        let randomNumber = Int.random(in: 1...7)
        
        if isLow {
            switch randomNumber {
                case 1...4:
                    let length = Int.random(in: 4...6)
                    return (.straight, length)
                case 5, 6:
                    return (.arc, nil)
                default:
                    return (.doubleStraight, nil)
            }
        } else {
            switch randomNumber {
                case 1...6:
                    let length = Int.random(in: 4...6)
                    return (.straight, length)
                default:
                    return (.doubleStraight, nil)
            }
        }
    }
}
