//
//  PushupClassifier+PredictionAction.swift
//
//
//  Created by Wit Owczarek on 15/12/2024.
//

import CoreML

extension PushupClassifierV4 {
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let correctlyShaped = reshapeArray(window)
            let output = try prediction(input: correctlyShaped)
            let actions = processModelOutput(output.linear_1)
            let finalOutput = actions.first ?? ActionPrediction.startingPrediction
            print(finalOutput)
            return finalOutput
        } catch {
            fatalError("Pushup Classifier prediction error: \(error)")
        }
    }
    
    func processModelOutput(_ output: MLMultiArray) -> [ActionPrediction] {
        var predictions: [ActionPrediction] = []
        let softmaxValues = softmax(output)
        
        for i in 0..<Label.allCases.count {
            let probability = softmaxValues[i].floatValue
            predictions.append(
                ActionPrediction(
                    label: Label.allCases[i].getTitle(),
                    confidence: Double(probability)
                )
            )
        }
        return predictions.sorted { $0.confidence > $1.confidence }
    }

    func softmax(_ input: MLMultiArray) -> MLMultiArray {
        guard let output = try? MLMultiArray(shape: input.shape, dataType: .float32) else {
            fatalError("Couldn't create output array")
        }

        var expSum: Float = 0
        for i in 0..<input.count {
            let expValue = exp(input[i].floatValue)
            output[i] = NSNumber(value: expValue)
            expSum += expValue
        }

        for i in 0..<output.count {
            output[i] = NSNumber(value: output[i].floatValue / expSum)
        }

        return output
    }
    
    func reshapeArray(_ inputArray: MLMultiArray) -> MLMultiArray {
        guard let outputArray = try? MLMultiArray(
            shape: [1,38,30] as [NSNumber],
            dataType: inputArray.dataType
        ) else {
            fatalError("Couldn't create output array")
        }
        
        for i in 0..<30 {
            for j in 0..<38 {
                let sourceIndex = [0, i, j] as [NSNumber]
                let targetIndex = [0, j, i] as [NSNumber]
                outputArray[targetIndex] = inputArray[sourceIndex]
            }
        }
        
        return outputArray
    }
}
