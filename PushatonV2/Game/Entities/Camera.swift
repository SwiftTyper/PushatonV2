//
//  Camera.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 05/12/2024.
//

import Foundation
import SceneKit

class Camera: SCNNode {
    override init() {
        super.init()
        camera = SCNCamera()
        position = SCNVector3(0, 4, 8)
        eulerAngles = SCNVector3(x: Calculator.toRadians(angle: -15), y: 0, z: 0)
    }
    
    var visibleWidth: CGFloat {
        let distanceToCamera = abs(position.z)
        let fov = Float(camera?.fieldOfView ?? 60.0)
        let visibleWidth = 2.0 * distanceToCamera * tan((.pi * fov / 180.0) / 2.0)
        return CGFloat(visibleWidth)
    }
    
    var lastVisibleZPosition: Float {
        let viewDistance = Float(camera?.zFar ?? .zero)
        return position.z + viewDistance
    }
    
    func setup(_ gameController: GameController) {
        gameController.scene.rootNode.addChildNode(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
