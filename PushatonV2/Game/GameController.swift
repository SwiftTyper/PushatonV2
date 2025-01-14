import SwiftUI
import Combine
import SceneKit

class GameController: NSObject {
    var gameMatchViewModel: GameMatchViewModel
    var playerViewModel: PlayerViewModel
    var predictionViewModel: PredictionViewModel
    
    var sceneView: SCNView
    var scene: SCNScene!
    var speed: Float = 0.15
    var previousPlayerState: String? = nil
    var cancellables: Set<AnyCancellable> = []
    
    var hud: GameHUD!
    var camera = Camera()
    var player = PlayerNode()

    init(
        sceneView: SCNView,
        gameMatchViewModel: GameMatchViewModel,
        playerViewModel: PlayerViewModel,
        predictionViewModel: PredictionViewModel
    ) {
        self.sceneView = sceneView
        self.gameMatchViewModel = gameMatchViewModel
        self.playerViewModel = playerViewModel
        self.predictionViewModel = predictionViewModel
        super.init()
        initGame()
    }
    
    func initGame() {
        setupGameStateObserver()
        setupPlayerStateObserver()
        
        setupScene()
        setupGestures()
        Lane.setup(self)
        player.setup(self)
        camera.setup(self)
       
        Obstacle.setup(self)
        Light.setup(self)
    }
    
    func setupGameStateObserver() {
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
    
    func setupPlayerStateObserver() {
        predictionViewModel.$predicted
            .sink(receiveValue: { [weak self] newState in
                self?.handlePlayerStateChanged(to: newState)
            })
            .store(in: &cancellables)
    }
    
    enum Action {
        case jump
        case dash
    }
    
    func getSuggestedAction() -> Action? {
        guard let obstacle = Obstacle.getClosestToPlayer() else { return nil }
        let zPosition = obstacle.position.z
        let isLow = (obstacle.boundingBox.max.y - obstacle.boundingBox.min.y) < 2
        
        if zPosition < 30 {
            if isLow {
                return Action.jump
            } else {
                return Action.dash
            }
        }
        return nil
    }
    
    func handlePlayerStateChanged(to playerState: String) {
        print(playerState)
        
        let isPlayerUp = (playerState == PushupClassifierV3.Label.pushupUp.rawValue || playerState == PushupClassifierV3.Label.pushupUpHold.rawValue)
        let wasPlayerDown = (previousPlayerState == nil || previousPlayerState == PushupClassifierV3.Label.pushupDownHold.rawValue || previousPlayerState == PushupClassifierV3.Label.pushupDown.rawValue)
        let isPlayerDown = (playerState == PushupClassifierV3.Label.pushupDown.rawValue || playerState == PushupClassifierV3.Label.pushupDownHold.rawValue)
        let wasPlayerUp = previousPlayerState == nil || previousPlayerState == PushupClassifierV3.Label.pushupUp.rawValue || previousPlayerState == PushupClassifierV3.Label.pushupUpHold.rawValue
        
        let action = getSuggestedAction()
        print(action)
        
        if (action == .jump || action == nil) && isPlayerUp && wasPlayerDown {
            player.jump()
        } else if (action == .dash || action == nil) && isPlayerDown && wasPlayerUp {
            player.dash()
        }
                
        previousPlayerState = playerState
    }
    
    func gameOver() {
//        if gameMatchViewModel.game?.status == .playing {
//            scene.rootNode.childNodes.forEach { node in
//                node.removeAllActions()
//            }
//            sceneView.isPlaying = false
//            
//            Task {
//                await playerViewModel.die()
//                await gameMatchViewModel.lost(player: playerViewModel.player, opponent: playerViewModel.opponent)
//            }
//        }
    }
}

extension GameController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        Lane.update(self)
        Obstacle.update(self)
        Coin.update(self)
    }
}
