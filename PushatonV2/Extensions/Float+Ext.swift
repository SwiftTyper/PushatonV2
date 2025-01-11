//
//  Float.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 10/01/2025.
//

import Foundation

extension Float {
    func toRadians() -> Float {
        return self *  Float.pi/180
    }
    
    func toDegrees() -> Float {
        return self * 180/Float.pi
    }
}
