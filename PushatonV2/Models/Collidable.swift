//
//  Collidable.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 07/01/2025.
//

import Foundation
import SceneKit

protocol Collidable {
    func didCollide(with node: SCNNode)
}
