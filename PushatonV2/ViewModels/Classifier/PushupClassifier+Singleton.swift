//
//  PushupClassifier+Singleton.swift
//
//
//  Created by Wit Owczarek on 15/12/2024.
//

import CoreML

extension PushupClassifierV4 {
    
    static let shared: PushupClassifierV4 = {
        let defaultConfig = MLModelConfiguration()
        
        guard let pushupClassifer = try? PushupClassifierV4(configuration: defaultConfig) else {
            fatalError("Pushup Classifier failed to initialize.")
        }
        
        return pushupClassifer
    }()
}

