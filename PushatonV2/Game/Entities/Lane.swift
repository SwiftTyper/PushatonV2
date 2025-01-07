import Foundation
import SceneKit

class Lane: SCNNode {
    static private var segments: [SCNNode] = []
    static private let segmentLength: Float = 10.0
    static let segmentHeight: Float = 0.4
    
    init(width: CGFloat) {
        super.init()
        setupLane(width: width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLane(width: CGFloat) {
        let geometry = SCNBox(
            width: width,
            height: CGFloat(Lane.segmentHeight),
            length: CGFloat(Lane.segmentLength),
            chamferRadius: 0
        )
        let material = SCNMaterial()
        if let texturePath = Bundle.main.path(forResource: "lightgrass", ofType: "png"),
           let texture = UIImage(contentsOfFile: texturePath) {
            material.diffuse.contents = texture
            material.diffuse.wrapT = .repeat
            material.diffuse.wrapS = .repeat
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), 1, Lane.segmentLength)
        }
        geometry.materials = [material]
        self.geometry = geometry
        
        self.position.y = Lane.segmentHeight/2
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
        self.runAction(SCNAction.repeatForever(moveAction))
    }
}

extension Lane {
    static func setup(_ gameController: GameController) {
        let width = CGFloat(0.4 * gameController.camera.visibleWidth)
        let numberOfSegments = Int(ceil(gameController.camera.lastVisibleZPosition / segmentLength)) + 1
        
        for _ in 0..<numberOfSegments {
            let node = Lane(width: width)
            node.position.z = (segments.last?.position.z ?? gameController.camera.position.z) - segmentLength
            segments.append(node)
            gameController.scene.rootNode.addChildNode(node)
        }
    }
    
    static func update(_ gameController: GameController) {
        for segment in segments {
            if segment.position.z > gameController.camera.position.z + segmentLength/2 {
                segment.position.z = (segments.last?.position.z ?? .zero) - segmentLength
                segments.removeFirst()
                segments.append(segment)
            }
        }
    }
}
