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
    
    //    private func setupLane(width: CGFloat) {
    //        let geometry = SCNBox(
    //            width: width,
    //            height: CGFloat(Lane.segmentHeight),
    //            length: CGFloat(Lane.segmentLength),
    //            chamferRadius: 0
    //        )
    //        let material = SCNMaterial()
    //        if let texturePath = Bundle.main.path(forResource: "concrete", ofType: "jpg"),
    //           let texture = UIImage(contentsOfFile: texturePath) {
    //            material.diffuse.contents = texture
    //            material.diffuse.wrapT = .repeat
    //            material.diffuse.wrapS = .repeat
    //            material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), 1, Lane.segmentLength)
    //        }
    //        geometry.materials = [material]
    //        self.geometry = geometry
    //
    //        self.position.y = Lane.segmentHeight/2
    //
    //        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
    //        self.runAction(SCNAction.repeatForever(moveAction))
    //    }
    
    private func setupLane(width: CGFloat) {
        let geometry = SCNBox(
            width: width,
            height: CGFloat(Lane.segmentHeight),
            length: CGFloat(Lane.segmentLength),
            chamferRadius: 0
        )
        
        // Create tile material
        let material = SCNMaterial()
        
        // Create procedural tile texture - make it larger for better quality outlines
        let textureSize: CGFloat = 512 // Increased for better quality
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: textureSize, height: textureSize), true, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Fill with dark outline color (black or dark gray for the outlines)
        context.setFillColor(UIColor.lightGray.cgColor)  // Using black for strong outlines
        context.fill(CGRect(x: 0, y: 0, width: textureSize, height: textureSize))
        
        // Draw white tile with thick outline on all sides
        let outlineThickness: CGFloat = 15.0  // Increased thickness for more visible outlines
        let tilePath = UIBezierPath(rect: CGRect(x: outlineThickness,
                                                 y: outlineThickness,
                                                 width: textureSize - (outlineThickness * 2),
                                                 height: textureSize - (outlineThickness * 2)))
        
        // Fill tile with white
        UIColor.white.setFill()
        tilePath.fill()
        
        // Add subtle shading for depth
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: [UIColor.white.cgColor,
                                           UIColor(white: 0.9, alpha: 1.0).cgColor] as CFArray,
                                  locations: [0, 1])!
        
        context.saveGState()
        tilePath.addClip()
        context.drawLinearGradient(gradient,
                                   start: CGPoint(x: 0, y: 0),
                                   end: CGPoint(x: textureSize, y: textureSize),
                                   options: [])
        context.restoreGState()
        
        let tileTexture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Apply texture
        material.diffuse.contents = tileTexture
        material.diffuse.wrapT = .repeat
        material.diffuse.wrapS = .repeat
        
        // Scale texture to make each tile a square of lane width
        let tilesAlong: Float = Float(Lane.segmentLength / Float(width))  // This makes each tile a square
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(1, tilesAlong, 1)
        
        // Add slight specularity for shine
        material.specular.contents = UIColor(white: 1.0, alpha: 0.3)
        material.roughness.contents = 0.2
        
        geometry.materials = [material]
        self.geometry = geometry
        
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: [
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        self.physicsBody?.allowsResting = true
        self.physicsBody?.contactTestBitMask = CollisionCategory.ground.rawValue
        self.physicsBody?.collisionBitMask = CollisionCategory.ground.rawValue
        self.physicsBody?.categoryBitMask = CollisionCategory.ground.rawValue
        self.physicsBody?.isAffectedByGravity = false
        
        self.position.y = Lane.segmentHeight/2
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 20, duration: 1)
        self.runAction(SCNAction.repeatForever(moveAction))
    }
}

extension Lane: Collidable {
    func didCollide(with node: SCNNode, _ gameController: GameController) {
        
    }
}

extension Lane {
    static func setup(_ gameController: GameController) {
        segments = []
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
