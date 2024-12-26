import SwiftUI
import SceneKit

class GameController: NSObject {
    var gameMatchViewModel: GameMatchViewModel
    var playerViewModel: PlayerViewModel
    var sceneView: SCNView
    var scene: SCNScene!
    var speed: Float = 0.15
    
    var camera = Camera()
    var ground = Ground()
    var lane = Lane()
    var player = PlayerNode()
    var obstacle = Obstacle()
    var light = Light()
    
    var hearts: [SCNNode] = []
    var isHit: Bool = false

    init(
        sceneView: SCNView,
        gameMatchViewModel: GameMatchViewModel,
        playerViewModel: PlayerViewModel
    ) {
        self.sceneView = sceneView
        self.gameMatchViewModel = gameMatchViewModel
        self.playerViewModel = playerViewModel
        super.init()
        initGame()
    }
    
    func initGame() {
        setupScene()
        setupGestures()
        setupHearts()
        camera.setup(self)
        ground.setup(self)
        lane.setup(self)
        player.setup(self)
        obstacle.setup(self)
        light.setup(self)
    }
    
    func setupHearts() {
        for i in 0..<3 {
            let heartGeometry = SCNText(string: "❤️", extrusionDepth: 0)
            let heartNode = SCNNode(geometry: heartGeometry)
            
            heartNode.scale = SCNVector3(1,1,1)
            heartNode.position = SCNVector3(Float(-0.3 + Double(i) * 0.2), 3.5, -0.5)
            
            let billboardConstraint = SCNBillboardConstraint()
            heartNode.constraints = [billboardConstraint]
            
            hearts.append(heartNode)
            scene.rootNode.addChildNode(heartNode)
        }
    }
     
    func loseLife() {
        if isHit == false {
            self.isHit = true
            
            if hearts.count > 0 {
                hearts.last!.removeFromParentNode()
                hearts.removeLast()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isHit = false
                }
            }
            
            if hearts.count == 0 {
                gameOver()
            }
        }
    }
    
    func gameOver() {
        scene.rootNode.childNodes.forEach { node in
            node.removeAllActions()
        }
        sceneView.isPlaying = false
        
        Task { await gameMatchViewModel.lost(playerId: playerViewModel.playerId) }
        
//        DispatchQueue.main.async {
//            let gameOverView = GameOverView(sceneView: self.sceneView)
//            self.sceneView.addSubview(gameOverView)
//        }
    }
}

extension GameController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        lane.update(self)
        obstacle.update(self)
    }
}
