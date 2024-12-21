//
//  String+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 21/12/2024.
//

import Foundation

extension Character {
    var isActualSymbol: Bool {
        return "^$*.[]{}()?\"!@#%&/\\,><':;|_~`+=-".contains(self)
    }
}
