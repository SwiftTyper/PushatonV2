import Foundation
import SceneKit

class Lane {
    private var segments: [SCNNode] = []
    private let segmentLength: Float = 10.0
    static let segmentHeight: Float = 0.4
    
    init() { }
    
    func setup(_ gameController: GameController) {
        segments.removeAll()
        let numberOfSegments = Int(ceil(gameController.camera.lastVisibleZPosition / segmentLength)) + 1
        for _ in 0..<numberOfSegments {
            createSegment(gameController)
        }
    }
    
    func update(_ gameController: GameController) {
        for segment in segments {
            if segment.position.z > gameController.camera.position.z + segmentLength/2 {
                segment.position.z = (segments.last?.position.z ?? .zero) - segmentLength
                segments.removeFirst()
                segments.append(segment)
            }
        }
    }
    
    private func createSegment(_ gameController: GameController) {
        let width = CGFloat(0.4 * gameController.camera.visibleWidth)
        let laneGeometry = SCNBox(width: width, height: CGFloat(Lane.segmentHeight), length: CGFloat(segmentLength), chamferRadius: 0)
        let material = SCNMaterial()
        
        if let texturePath = Bundle.main.path(forResource: "lightgrass", ofType: "png"),
           let texture = UIImage(contentsOfFile: texturePath) {
            material.diffuse.contents = texture
            material.diffuse.wrapT = .repeat
            material.diffuse.wrapS = .repeat
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), 1, segmentLength)
        }
        
        let segmentNode = SCNNode(geometry: laneGeometry)
        laneGeometry.materials = [material]
        
        segmentNode.position.y = Lane.segmentHeight/2
        segmentNode.position.z = (segments.last?.position.z ?? gameController.camera.position.z) - segmentLength
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
        segmentNode.runAction(SCNAction.repeatForever(moveAction))
        
        segments.append(segmentNode)
        gameController.scene.rootNode.addChildNode(segmentNode)
    }
}
