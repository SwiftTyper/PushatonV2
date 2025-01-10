//
//  CGFloat+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 09/01/2025.
//

import Foundation

extension CGFloat {
    private static let degreesPerRadians = CGFloat(Double.pi/180)
    private static let radiansPerDegrees = CGFloat(180/Double.pi)

    func toRadians() -> CGFloat {
        return self * CGFloat.degreesPerRadians
    }
    
    func toDegrees() -> CGFloat {
        return self * CGFloat.radiansPerDegrees
    }
}
