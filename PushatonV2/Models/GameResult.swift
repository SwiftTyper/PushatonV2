//
//  GameResult.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 26/12/2024.
//

import Foundation

enum GameResult: String {
    case won
    case lost
    case tie
}

extension GameResult {
    func getTitle(difference: Int) -> String {
        switch self {
            case .won: return "Congrats!!"
            case .lost: return difference < 10 ? "So Close!" : "Game Over!"
            case .tie: return "Tie."
        }
    }
}
