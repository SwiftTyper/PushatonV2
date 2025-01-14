//
//  PushupClassifier+PredictionAction.swift
//
//
//  Created by Wit Owczarek on 15/12/2024.
//

import CoreML

extension PushupClassifierV3 {
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let output = try prediction(poses: window)
            let label = output.label
            guard let propability = output.labelProbabilities[label] else {
                return .lowConfidencePrediction
            }
            let action = ActionPrediction(label: label, confidence: propability)
            return action
        } catch {
            fatalError("Pushup Classifier prediction error: \(error)")
        }
    }
}
