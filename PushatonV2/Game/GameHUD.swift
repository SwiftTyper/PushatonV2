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
    
    override func didMove(to view: SKView) {
        addHearts()
        addPointsLabel()
        offsetHearts(view: view)
        pointsLabel?.position.y -= view.safeAreaInsets.top
    }
    
    private func offsetHearts(view: SKView) {
        self.enumerateChildNodes(withName: "heart") { node, index in
            node.position.y = self.size.height - view.safeAreaInsets.top
        }
    }
    
    func addHearts() {
        let spacing: CGFloat = 8
        for index in -1...1 {
            let heart = Heart(.full)
            let xPosition = self.size.width/2 + (heart.size.width + spacing) * CGFloat(index)
            heart.position.x = xPosition
            hearts.append(heart)

            let emptyHeart = Heart(.empty)
            emptyHeart.position.x = xPosition
            
            addChild(emptyHeart)
            addChild(heart)
        }
    }
    
    func addMenuLabels() {
        logoLabel = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        tapToPlayLabel = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        guard let logoLabel = logoLabel, let tapToPlayLabel = tapToPlayLabel else {
            return
        }
        logoLabel.text = "Pushaton"
        logoLabel.fontSize = 35.0
        logoLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logoLabel)
        
        tapToPlayLabel.text = "Tap to Play"
        tapToPlayLabel.fontSize = 25.0
        tapToPlayLabel.position = CGPoint(x: frame.midX, y: frame.midY-logoLabel.frame.size.height)
        addChild(tapToPlayLabel)
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
            y: frame.maxY - pointsLabel.frame.size.height/2
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
