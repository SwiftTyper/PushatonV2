//
//  Int+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/01/2025.
//

import Foundation

extension Optional<Int>: @retroactive Comparable {
    public static func < (lhs: Optional, rhs: Optional) -> Bool {
        (lhs ?? 0) < (rhs ?? 0)
    }
}
