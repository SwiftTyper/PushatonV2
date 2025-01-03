import SwiftUI
import Combine
import SceneKit

class GameController: NSObject {
    var gameMatchViewModel: GameMatchViewModel
    var playerViewModel: PlayerViewModel
    var sceneView: SCNView
    var scene: SCNScene!
    var speed: Float = 0.15
    
    var hud: GameHUD!
    var camera = Camera()
    var ground = Ground()
    var lane = Lane()
    var player = PlayerNode()
    var obstacle = Obstacle()
    var light = Light()
    var coin = Coin()

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
        setupListener()
        setupScene()
        setupGestures()
        camera.setup(self)
        ground.setup(self)
        lane.setup(self)
        player.setup(self)
        obstacle.setup(self)
        light.setup(self)
    }
    
    
    func setupListener() {
        Task { @MainActor in
            for await game in gameMatchViewModel.gameStream {
                if game?.status == .finished && self.sceneView.isPlaying == true {
                    self.scene.rootNode.childNodes.forEach { node in
                        node.removeAllActions()
                    }
                    self.sceneView.isPlaying = false
                }
            }
        }
    }
    
    func gameOver() {
//        if gameMatchViewModel.game?.status == .playing {
//            scene.rootNode.childNodes.forEach { node in
//                node.removeAllActions()
//            }
//            sceneView.isPlaying = false
//            
//            Task { await gameMatchViewModel.lost(playerId: playerViewModel.playerId) }
//        }
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
        Coin.update(self)
    }
}
