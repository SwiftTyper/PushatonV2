//
//  Calculations.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 04/12/2024.
//

import Foundation

struct Calculator {
    private static let degreesPerRadians = Float(Double.pi/180)
    private static let radiansPerDegrees = Float(180/Double.pi)

    static func toRadians(angle: Float) -> Float {
        return angle * degreesPerRadians
    }

    static func toRadians(angle: CGFloat) -> CGFloat {
        return angle * CGFloat(degreesPerRadians)
    }

    static func randomBool(odds: Int) -> Bool {
        let random = arc4random_uniform(UInt32(odds))
        if random < 1 {
            return true
        } else {
            return false
        }
    }
}
