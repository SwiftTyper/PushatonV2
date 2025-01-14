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
    var technique: SCNTechnique? = nil
    
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
        player.setup(self)
        camera.setup(self)
        
        setupFog()
        Ground.setup(self)
        Lane.setup(self)
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
    
//    func handlePlayerStateChanged(to playerState: String) {
//        if (playerState == PushupClassifierV4.Label.pushupUp.getTitle()) &&
//            (previousPlayerState == nil || previousPlayerState == PushupClassifierV4.Label.pushupDown.getTitle())
//        {
//            player.jump()
////            if playerStateController.canEnterState(JumpingState.self) {
////                run(Sound.jump.action)
////            }
////            playerStateController.enter(JumpingState.self)
//        }
//        
//        previousPlayerState = playerState
//    }
    func handlePlayerStateChangedWithPrediction(to playerState: String) {
        let obstacle = Obstacle.getClosestToPlayer()
        let zPosition = obstacle.position.z
        let isLow = (obstacle.boundingBox.max.y - obstacle.boundingBox.min.y) < 2
        if zPosition < 10 {
            if isLow {
                //the suggested action would be to jump
            } else {
                //the suggested action would be to dash
            }
        }
        
    
        
    }
    
    func handlePlayerStateChanged(to playerState: String) {
        if playerState != ActionPrediction.lowConfidencePrediction.label && playerState != ActionPrediction.startingPrediction.label && playerState != ActionPrediction.noPersonPrediction.label {
            if (playerState == PushupClassifierV4.Label.pushupDown.getTitle()){
                //&& (previousPlayerState == PushupClassifierV4.Label.pushupUp.getTitle())
               
                print(previousPlayerState)
                print(playerState)
                print("dashed")
                player.dash()
            }
            
            // Going from pushup-down to pushup-up = JUMP
            if (playerState == PushupClassifierV4.Label.pushupUp.getTitle())
                //&&(previousPlayerState == PushupClassifierV4.Label.pushupDown.getTitle())
            {
                player.jump()
                print(previousPlayerState)
                print(playerState)
                print("jumped")
            }
            
            // Store the state for next comparison
            previousPlayerState = playerState
        }
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
    
    func setupFog() {
        scene.fogStartDistance = 10
        scene.fogEndDistance = 50
    }
    
//    func setupFog() {
//          // Set initial fog properties
//          scene.fogStartDistance = 10
//          scene.fogEndDistance = 50
//          scene.fogDensityExponent = 2.0
//          scene.fogColor = Color.white
////          scene.fogColor = Any(Color.white)
//          
//          // Optional: Create a method to adjust fog based on player movement
//          updateFogBasedOnPlayer()
//      }
//      
//      func updateFogBasedOnPlayer() {
//          // Add this to your renderer delegate or wherever you update game state
//          let playerPosition = player.position
//          
//          // Adjust fog based on player's forward position (z-axis)
//          // As player moves forward, fog gets more intense
//          let baseFogStart: CGFloat = 10
//          let baseFogEnd: CGFloat = 50
//          
//          // Reduce fog distances as player moves forward
//          let distanceFactor = CGFloat(abs(playerPosition.z)) * 0.1
//          scene.fogStartDistance = max(5, baseFogStart - distanceFactor)
//          scene.fogEndDistance = max(20, baseFogEnd - distanceFactor)
//          
//          // Optional: Adjust density for more dramatic effect
//          scene.fogDensityExponent = 2.0 + CGFloat(abs(playerPosition.z)) * 0.05
//      }
}

extension GameController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        Lane.update(self)
        Obstacle.update(self)
        Coin.update(self)
    }
}
