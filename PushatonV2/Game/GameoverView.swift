//import UIKit
//import SceneKit
//
//class GameOverView: UIView {
//    init(sceneView: SCNView) {
//        super.init(frame: sceneView.bounds)
//        
//        // Setup blur
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = bounds
//        addSubview(blurView)
//        
//        // Game Over label
//        let gameOverLabel = UILabel()
//        gameOverLabel.text = "GAME OVER"
//        gameOverLabel.font = .boldSystemFont(ofSize: 80)
//        gameOverLabel.textColor = .white
//        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(gameOverLabel)
//        
//        // Tap to restart label
//        let tapToRestartLabel = UILabel()
//        tapToRestartLabel.text = "Tap to Continue"
//        tapToRestartLabel.font = .systemFont(ofSize: 48)
//        tapToRestartLabel.textColor = .white
//        tapToRestartLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(tapToRestartLabel)
//        
//        // Center labels
//        NSLayoutConstraint.activate([
//            gameOverLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            gameOverLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            
//            tapToRestartLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            tapToRestartLabel.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 20)
//        ])
//        
//        // Animate in
//        alpha = 0
//        UIView.animate(withDuration: 0.1) {
//            self.alpha = 1
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
