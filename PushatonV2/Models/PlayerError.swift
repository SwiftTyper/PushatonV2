//
//  PlayerError.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 29/12/2024.
//

import Foundation

enum PlayerError: Error {
    case playerAlreadyExists
    
    var errorDescription: String {
        return "This username already exists. Choose a different username."
    }
}
