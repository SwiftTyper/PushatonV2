//
//  PushupClassifier+FrameRate.swift
//
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import CoreML

extension PushupClassifierV4 {
    static let frameRate:Double = 30.0
    
    func calculatePredictionWindowSize() -> Int {
        return Int(PushupClassifierV4.frameRate)
    }
}
