//
//  Sound.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 12/01/2025.
//

import Foundation
import SpriteKit
import AVFAudio
import SceneKit

enum Sound : String {
    case death = "death.mp3"
    case jump = "jump.wav"
    case reward = "reward.wav"
    case collision = "crash.mp3"
    case dash = "dash.mp3"
    
    var action: SCNAction {
        return SCNAction.playAudio(.init(fileNamed: rawValue)!, waitForCompletion: false)
    }
}
