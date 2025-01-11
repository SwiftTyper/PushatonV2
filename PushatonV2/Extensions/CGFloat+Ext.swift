//
//  CGFloat+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 09/01/2025.
//

import Foundation

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi/180)
    }
    
    func toDegrees() -> CGFloat {
        return self * CGFloat(180/Double.pi)
    }
}
