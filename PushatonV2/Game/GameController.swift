import SwiftUI
import SceneKit

enum GameState {
    case menu, playing, gameOver
}

class GameController: NSObject {
    var sceneView: SCNView
    var scene: SCNScene!
    
    private var lastUpdateTime: TimeInterval = 0
    private var obstacleSpeed: Float = 10.0
    var isPlayerManeuvering = false
    var score: Int = 0
    var state: GameState = .menu
    
    var cameraNode: SCNNode = .init()
    var player = Player()
    var lane = Lane()
    var obstacle = Obstacle()

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
        setupGestures()
        
        obstacle.setup(self)
        player.setup(self)
        lane.setup(self)
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
}

extension GameController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    
    }
}

extension GameController: SCNPhysicsContactDelegate {
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
