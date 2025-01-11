//
//  Color+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 02/12/2024.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Extensions
extension UIColor {
    static var skyBlue: UIColor {
        UIColor(red: 0.529, green: 0.808, blue: 0.922, alpha: 1.0)
    }
}

extension Color {
    func lighten(by amount: CGFloat) -> Color {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        if UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) {
            return Color(red: max(r + amount, 0.0),
                           green: max(g + amount, 0.0),
                           blue: max(b + amount, 0.0), opacity: a)
        }

        return self
    }
}
