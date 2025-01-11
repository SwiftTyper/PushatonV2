//
//  SKView+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SpriteKit

extension SKView {
    override open func safeAreaInsetsDidChange() {
      scene?.didChangeSize(scene!.size)
    }
}
