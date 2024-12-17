//
//  Notification+Name.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation

extension Notification.Name {
    // MARK: - Auth
    static let userLoggedIn = Notification.Name("userLoggedIn")
    static let userSignedUp = Notification.Name("userSignedUp")
    static let userConfirmedAccount = Notification.Name("userConfirmedAccount")
    static let userLoggedOut = Notification.Name("userLoggedOut")

    // MARK: - Sessions

    static let newSessionCreated = Notification.Name("newSessionCreated")

    // MARK: - IAPS
    static let userUpgraded = Notification.Name("userUpgraded")
}
