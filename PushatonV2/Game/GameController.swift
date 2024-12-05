import SwiftUI
import SceneKit

enum GameState {
    case menu, playing, gameOver
}

class GameController: NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var sceneView: SCNView
    var scene: SCNScene!
    var player: SCNNode = .init()
    var cameraNode: SCNNode = .init()
    
    private var lastUpdateTime: TimeInterval = 0
    private var obstacleSpeed: Float = 10.0
    private var lanes: [LaneNode] = []
    var isPlayerManeuvering = false
    
    var score: Int = 0
    var state: GameState = .menu
    
    init(sceneView: SCNView) {
        self.sceneView = sceneView
        super.init()
        initGame()
    }
    
    func initGame() {
        setupScene()
        setupCamera()
        setupLighting()
        setupGround()
        createLanes()
        setupPlayer()
        setupGestures()
    }
    
    func resetGame() {
        state = .gameOver
        score = 0
        lastUpdateTime = 0
        isPlayerManeuvering = false
        
        scene.rootNode.childNodes.forEach { node in
            node.removeFromParentNode()
        }
        scene.rootNode.removeAllActions()
        scene = nil
    }
    
    private func setupScene() {
        scene = .init()
        sceneView.delegate = self
        sceneView.scene = scene
        sceneView.backgroundColor = .skyBlue
        sceneView.allowsCameraControl = false
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showPhysicsShapes]
        scene.physicsWorld.contactDelegate = self
    }
    
     
     func createLanes() {
         let roadLane = LaneNode(type: .road, width: 5)
         roadLane.position = SCNVector3(x: 0, y: 0, z: 0)
         lanes.append(roadLane)
         scene.rootNode.addChildNode(roadLane)
         
         let leftGrassLane = LaneNode(type: .grass, width: 4)
         leftGrassLane.position = SCNVector3(x: -4.5, y: 0, z: 0)
         lanes.append(leftGrassLane)
         scene.rootNode.addChildNode(leftGrassLane)
         
         let rightGrassLane = LaneNode(type: .grass, width: 4)
         rightGrassLane.position = SCNVector3(x: 4.5, y: 0, z: 0)
         lanes.append(rightGrassLane)
         scene.rootNode.addChildNode(rightGrassLane)
     }
     
     func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
         guard state == .playing else {
             lastUpdateTime = 0
             return
         }
         
         // Update lane positions
         lanes.forEach { lane in
             lane.update(playerPosition: player.position)
         }
         
         // Existing obstacle spawning code...
         if lastUpdateTime == 0 {
             lastUpdateTime = time
         }
         
         let deltaTime = time - lastUpdateTime
         if deltaTime > 1.5 {
             spawnObstacle()
             lastUpdateTime = time
             
             DispatchQueue.main.async {
                 self.score += 1
             }
         }
     }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        let isPlayerA = nodeA.physicsBody?.categoryBitMask == CollisionCategory.player.rawValue
        let isPlayerB = nodeB.physicsBody?.categoryBitMask == CollisionCategory.player.rawValue
        
        if (isPlayerA && nodeB.physicsBody?.categoryBitMask == CollisionCategory.obstacle.rawValue) ||
            (isPlayerB && nodeA.physicsBody?.categoryBitMask == CollisionCategory.obstacle.rawValue) {
            self.resetGame()
        }
    }
}
