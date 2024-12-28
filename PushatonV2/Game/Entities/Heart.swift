//
//  Heart.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 26/12/2024.
//

import Foundation
import SpriteKit

class Heart: SKSpriteNode {
    enum State {
        case full
        case empty
    }
    
    init(_ state: State) {
        let texture: SKTexture
        if state == .empty {
            texture = .init(imageNamed: "dark heart")
        } else {
            texture = .init(imageNamed: "heart")
        }
        
        super.init(texture: texture, color: .clear, size: texture.size())
        size = CGSize(width: 40, height: 40)
        name = "heart"
        zPosition = state == .empty ? 2 : 3
        anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
