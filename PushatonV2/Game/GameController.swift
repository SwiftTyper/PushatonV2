import SwiftUI
import SceneKit

enum GameState {
    case menu, playing, gameOver
}

class GameController: NSObject {
    var sceneView: SCNView
    var scene: SCNScene!
    
    var speed: Float = 0.15 //m per frame so * 60 to get m/s
    var state: GameState = .menu
    
    var camera = Camera()
    var ground = Ground()
    var lane = Lane()
    var player = Player()
    var obstacle = Obstacle()
    var light = Light()

    init(sceneView: SCNView) {
        self.sceneView = sceneView
        super.init()
        initGame()
    }
    
    func initGame() {
        setupScene()
        setupGestures()
        camera.setup(self)
        ground.setup(self)
        lane.setup(self)
        player.setup(self)
        obstacle.setup(self)
        light.setup(self)
    }
    
    func resetGame() {
        state = .gameOver
        scene.rootNode.childNodes.forEach { node in
            node.removeFromParentNode()
            node.removeAllActions()
        }
        sceneView.isPlaying = false
    }
}

extension GameController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        lane.update(self)
        obstacle.update(self)
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
            self.player.die()
            self.resetGame()
        }
    }
}
