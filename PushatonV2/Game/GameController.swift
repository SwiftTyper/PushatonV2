import SwiftUI
import SceneKit

class GameController: NSObject {
    @Binding var isGameShown: Bool
    var sceneView: SCNView
    var scene: SCNScene!
    var speed: Float = 0.15
    
    var camera = Camera()
    var ground = Ground()
    var lane = Lane()
    var player = Player()
    var obstacle = Obstacle()
    var light = Light()

    init(sceneView: SCNView, isGameShown: Binding<Bool>) {
        self.sceneView = sceneView
        self._isGameShown = isGameShown
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
    
    func gameOver() {
        scene.rootNode.childNodes.forEach { node in
            node.removeAllActions()
        }
        sceneView.isPlaying = false
        
        DispatchQueue.main.async {
            let gameOverView = GameOverView(sceneView: self.sceneView)
            self.sceneView.addSubview(gameOverView)
        }
    }
}

extension GameController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        lane.update(self)
        obstacle.update(self)
    }
}
