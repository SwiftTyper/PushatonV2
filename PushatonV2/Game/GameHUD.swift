//
//  GameHUD.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 27/12/2024.
//

import Foundation
import SpriteKit

class GameHUD: SKScene {
    var logoLabel: SKLabelNode?
    var tapToPlayLabel: SKLabelNode?
    var pointsLabel: SKLabelNode?
    var hearts: [SKSpriteNode] = []
    
    init(with size: CGSize) {
        super.init(size: size)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if let view = view {
            DispatchQueue.main.async {
                self.addHearts()
                self.addPointsLabel()
            }
        }
    }
    
    func addHearts() {
        let spacing: CGFloat = 8
        let yPosition = self.size.height - (view?.safeAreaInsets.top ?? 0)
        for index in -1...1 {
            let heart = Heart(.full)
            let xPosition = self.size.width/2 + (heart.size.width + spacing) * CGFloat(index)
            heart.position.x = xPosition
            heart.position.y = yPosition
            hearts.append(heart)

            let emptyHeart = Heart(.empty)
            emptyHeart.position.x = xPosition
            emptyHeart.position.y = yPosition
            
            addChild(emptyHeart)
            addChild(heart)
        }
    }
   
    func addPointsLabel() {
        pointsLabel = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        guard let pointsLabel = pointsLabel else {
            return
        }
        pointsLabel.text = "0"
        pointsLabel.fontSize = 40.0
        pointsLabel.horizontalAlignmentMode = .right
        pointsLabel.position = CGPoint(
            x: frame.maxX - 20,
            y: frame.maxY - pointsLabel.frame.size.height/2 - (view?.safeAreaInsets.top ?? 0)
        )
        addChild(pointsLabel)
    }
    
    func updatePoints(with points: Int) {
        pointsLabel?.text = "\(points)"
    }
    
    func removeHeart() -> Bool {
        if let lastHeart = hearts.popLast() {
            DispatchQueue.main.async {
                lastHeart.removeFromParent()
            }
        }
        
        if hearts.isEmpty {
            return false
        } else {
            return true
        }
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
