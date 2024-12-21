//
//  HapticManager.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation
import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.safePrepare()
        generator.safeNotificationOccurred(type)
    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.safePrepare()
        generator.safeImpactOccurred()
    }
}

extension UINotificationFeedbackGenerator {
    func safePrepare() {
        DispatchQueue.main.async {
            self.prepare()
        }
    }

    func safeNotificationOccurred(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            self.notificationOccurred(type)
        }
    }
}

extension UIImpactFeedbackGenerator {
    func safePrepare() {
        DispatchQueue.main.async {
            self.prepare()
        }
    }
    
    func safeImpactOccurred() {
        DispatchQueue.main.async {
            self.impactOccurred()
        }
    }
}
