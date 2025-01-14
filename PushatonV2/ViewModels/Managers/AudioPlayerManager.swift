//
//  AudioPlayerManager.swift
//
//
//  Created by Wit Owczarek on 19/02/2024.
//

import Foundation
import AVFoundation
import SwiftUI

class AudioPlayerManager {
    @AppStorage("isAudioEnabled") var isAudioEnabled: Bool = true
    static let shared = AudioPlayerManager()
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() { configure() }
    deinit { stopAllAudio() }
    
    func play(_ file: File) {
        guard isAudioEnabled else { return }
        if file == .background {
            self.playSound(named: "background", numberOfLoops: -1, volume: 0.1)
        } else {
            self.playSound(named: file.rawValue, withExtension: file.getExtension())
        }
    }
    
    func stopAudio(_ file: File) {
        audioPlayers[file.rawValue]?.stop()
        audioPlayers.removeValue(forKey: file.rawValue)
    }
    
    func stopAllAudio() {
        audioPlayers.values.forEach { $0.stop() }
        audioPlayers.removeAll()
    }
}

extension AudioPlayerManager {
    enum File : String{
        case background
        case countdown
        case record
        
        func getExtension() -> String {
            switch self {
                case .background: "mp3"
                case .countdown: "wav"
                case .record: "mp3"
            }
        }
    }
}

extension AudioPlayerManager {
    private func configure() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                options: [.mixWithOthers, .duckOthers]
            )
            
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error while configuring audio session: \(error.localizedDescription)")
        }
    }
    
    private func playSound(
        named name: String,
        withExtension ext: String = "mp3",
        numberOfLoops: Int = 0,
        volume: Float = 1.0
    ) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Sound file \(name).\(ext) not found")
            return
        }
        
        do {
            if let existingPlayer = audioPlayers[name] {
                existingPlayer.stop()
                audioPlayers.removeValue(forKey: name)
            }
            
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = numberOfLoops
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            audioPlayers[name] = player
        } catch {
            print("Error playing sound \(name): \(error.localizedDescription)")
        }
    }
}
