//
//  LoginStatus.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import Amplify

enum LoginStatus: Equatable {
    case notDetermined
    case loggedIn
    case loggedOut
    case onboarding
}
