//
//  UIApplication+Ext.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 20/12/2024.
//

import Foundation
import UIKit

extension UIApplication {
    static func getRootController() -> UIViewController? {
        if let topController = (Self
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }?.rootViewController)
        {
            return topController
        }
        return nil
    }
}
