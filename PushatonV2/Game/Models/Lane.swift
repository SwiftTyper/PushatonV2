//
//  LaneNode.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 04/12/2024.
//

import Foundation
import SceneKit

class Lane: SCNNode {
    private var segments: [SCNNode] = []
    private let segmentLength: Float = 50.0
    private let numberOfSegments = 3
    
    override init() {
        super.init()
    }
    
    func setup(_ gameController: GameController) {
        let distanceToCamera = abs(gameController.cameraNode.position.z)
        let fov = Float(gameController.cameraNode.camera?.fieldOfView ?? 60.0)
        let visibleWidth = Float(2.0 * distanceToCamera * tan((.pi * fov / 180.0) / 2.0))
        let width = CGFloat(0.4 * visibleWidth)
        createInitialSegments(width: width, gameController: gameController)
        gameController.scene.rootNode.addChildNode(self)
    }
    
    func createInitialSegments(width: CGFloat, gameController: GameController) {
        for i in 0..<numberOfSegments {
            let segment = createSegment(width: width)
            segment.position.z = Float(i) * -segmentLength
            addChildNode(segment)
            segments.append(segment)
        }
    }
    
    private func createSegment(width: CGFloat) -> SCNNode {
        let segmentNode = SCNNode()
        
        let laneGeometry = SCNBox(
            width: width,
            height: 0.4,
            length: CGFloat(
                segmentLength
            ),
            chamferRadius: 0
        )
        
        let material = SCNMaterial()
        segmentNode.position.y = 0.2
        
        if let texturePath = Bundle.main.path(forResource: "lightgrass", ofType: "png"),
           let texture = UIImage(contentsOfFile: texturePath) {
            material.diffuse.contents = texture
            material.diffuse.wrapT = .repeat
            material.diffuse.wrapS = .repeat
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(12.5, 12.5, 12.5)
        }
        laneGeometry.materials = [material]
        let laneNode = SCNNode(geometry: laneGeometry)
        segmentNode.addChildNode(laneNode)
        return segmentNode
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
