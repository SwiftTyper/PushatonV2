////
////  LaneNode.swift
////  PushatonV2
////
////  Created by Wit Owczarek on 04/12/2024.
////
//
//import Foundation
//import SceneKit
//
enum LaneType {
    case grass, road
}
//
//class LaneNode: SCNNode {
//    let type: LaneType
//    
//    init(type: LaneType, width: CGFloat) {
//        self.type = type
//        super.init()
//        
//        switch type {
//            case .grass:
//                guard let texture = UIImage(contentsOfFile: Bundle.main.path(forResource: "lightgrass", ofType: "png") ?? "") else {
//                    print("Failed to load texture")
//                    return
//                }
//                createLane(width: width, height: 0.4, image: texture)
//            case .road:
//                guard let texture = UIImage(contentsOfFile: Bundle.main.path(forResource: "darkgrass", ofType: "png") ?? "") else {
//                    print("Failed to load texture")
//                    return
//                }
//                createLane(width: width, height: 0.0, image: texture)
//        }
//    }
//    
//    func createLane(width: CGFloat, height: CGFloat, image: UIImage) {
//        let laneGeometry = SCNBox(width: width, height: height, length: 100, chamferRadius: 0)
//        laneGeometry.firstMaterial?.diffuse.contents = image
//        laneGeometry.firstMaterial?.diffuse.wrapT = .repeat
//        laneGeometry.firstMaterial?.diffuse.wrapS = .repeat
//        laneGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), 1, 1)
//        let laneNode = SCNNode(geometry: laneGeometry)
//        addChildNode(laneNode)
//        addElements(width, laneNode)
//    }
//    
//    func addElements(_ width: CGFloat, _ laneNode: SCNNode) {
////        var carGap = 0
////
////        for index in 0..<Int(width) {
////            if type == .grass {
////                if randomBool(odds: 7) {
////                    let vegetation = getVegetation()
////                    vegetation.position = SCNVector3(x: 10 - Float(index), y: 0, z: 0)
////                    laneNode.addChildNode(vegetation)
////                }
////            } else if type == .road {
////                carGap += 1
////                if carGap > 3 {
////                    guard let trafficNode = trafficNode else {
////                        continue
////                    }
////                    if randomBool(odds: 4) {
////                        carGap = 0
////                        let vehicle = getVehicle(for: trafficNode.type)
////                        vehicle.position = SCNVector3(x: 10 - Float(index), y: 0, z: 0)
////                        vehicle.eulerAngles = trafficNode.directionRight ? SCNVector3Zero : SCNVector3(x: 0, y: toRadians(angle: 180), z: 0)
////                        trafficNode.addChildNode(vehicle)
////                    }
////                }
////            }
////        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
import Foundation
import SceneKit

class LaneNode: SCNNode {
    let type: LaneType
    private var segments: [SCNNode] = []
    private let segmentLength: Float = 50.0
    private let numberOfSegments = 3
    
    init(type: LaneType, width: CGFloat) {
        self.type = type
        super.init()
        createInitialSegments(width: width)
    }
    
    private func createInitialSegments(width: CGFloat) {
        for i in 0..<numberOfSegments {
            let segment = createSegment(width: width)
            segment.position.z = Float(i) * -segmentLength
            addChildNode(segment)
            segments.append(segment)
        }
    }
    
    private func createSegment(width: CGFloat) -> SCNNode {
        let segmentNode = SCNNode()
        
        let laneGeometry = SCNBox(width: width,
                                  height: type == .grass ? 0.4 : 0.01,
                                length: CGFloat(segmentLength),
                                chamferRadius: 0
        )
        
        let material = SCNMaterial()
        if type == .grass {
            if let texturePath = Bundle.main.path(forResource: "lightgrass", ofType: "png"),
               let texture = UIImage(contentsOfFile: texturePath) {
                material.diffuse.contents = texture
                material.diffuse.wrapT = .repeat
                material.diffuse.wrapS = .repeat
                material.diffuse.contentsTransform = SCNMatrix4MakeScale(12.5, 12.5, 12.5)
            }
        } else {
            if let texturePath = Bundle.main.path(forResource: "darkgrass", ofType: "png"),
               let texture = UIImage(contentsOfFile: texturePath) {
                material.diffuse.contents = texture
                material.diffuse.wrapT = .repeat
                material.diffuse.wrapS = .repeat
                material.diffuse.contentsTransform = SCNMatrix4MakeScale(12.5, 12.5, 12.5)
            }
        }
        
        laneGeometry.materials = [material]
        let laneNode = SCNNode(geometry: laneGeometry)
        segmentNode.addChildNode(laneNode)
        
        return segmentNode
    }
    
    func update(playerPosition: SCNVector3) {
        for segment in segments {
            let distanceToPlayer = segment.worldPosition.z - playerPosition.z
            
            if distanceToPlayer > segmentLength * 1.5 {
                if let lastSegment = segments.min(by: { $0.worldPosition.z < $1.worldPosition.z }) {
                    segment.position.z = lastSegment.position.z - segmentLength
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
