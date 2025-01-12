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

//    case countdown = "countdown.wav"
//    case record = "record.mp3"

enum Sound : String {
    case death = "death.mp3"
    case jump = "jump.wav"
    case reward = "reward.wav"
    case collision = "box crash.mp3"
    case dash = ""
    
    var action: SCNAction {
        return SCNAction.playAudio(.init(fileNamed: rawValue)!, waitForCompletion: false)
    }
}
