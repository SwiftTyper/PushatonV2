//
//  PushupClassifier+Label.swift
//
//
//  Created by Wit Owczarek on 15/12/2024.
//

import Foundation

extension PushupClassifierV4 {
    enum Label: Int, CaseIterable {
        case pushupUp = 0
        case pushupDown = 1
        case other = 2
        
        func getTitle() -> String {
            switch self {
                case .pushupUp: "Pushup Up"
                case .pushupDown: "Pushup Down"
                case .other: "Other"
            }
        }
        
        init(_ int: Int) {
            guard let label = Label(rawValue: int) else {
                fatalError("get good")
            }
            self = label
        }
    }
}
