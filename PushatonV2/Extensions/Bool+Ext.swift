//
//  Bool+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 04/01/2025.
//

import Foundation

extension Bool {
    static func random(odds: Int) -> Bool {
        let random = Int.random(in: 0..<odds)
        if random == 0 {
            return true
        } else {
            return false
        }
    }
}

let degreesPerRadians = Float(Double.pi/180)
let radiansPerDegrees = Float(180/Double.pi)

func toRadians(angle: Float) -> Float {
    return angle * degreesPerRadians
}

func toRadians(angle: CGFloat) -> CGFloat {
    return angle * CGFloat(degreesPerRadians)
}

