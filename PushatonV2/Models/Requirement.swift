//
//  Requirement.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation

struct Requirement: Identifiable {
    init(name: String, isMet: Bool) {
        self.name = name
        self.isMet = isMet
    }
    
    let id = UUID()
    let name: String
    var isMet: Bool = false
}
