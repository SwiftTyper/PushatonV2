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
