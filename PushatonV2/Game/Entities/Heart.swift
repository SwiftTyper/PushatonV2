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
        let texture: SKTexture = .init(imageNamed: "heart")
        if state == .empty {
            super.init(texture: texture, color: .black, size: texture.size())
            colorBlendFactor = 1
        } else {
            super.init(texture: texture, color: .clear, size: texture.size())
        }
      
        let desiredWidth: CGFloat = 40
        let aspectRatio = texture.size().height / texture.size().width
        let calculatedHeight = desiredWidth * aspectRatio
                
        size = CGSize(width: desiredWidth, height: calculatedHeight)
        name = "heart"
        zPosition = state == .empty ? 2 : 3
        anchorPoint = CGPoint(x: 0.5, y: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
