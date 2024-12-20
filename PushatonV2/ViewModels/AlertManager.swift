//
//  AlertManager.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 20/12/2024.
//

import Foundation
import SwiftUI
import UIKit

struct AlertManager {
    static func presentAlert(
        title: String = "Error",
        message: String = "Something went wrong!",
        primaryButton: UIAlertAction? = nil,
        secondaryButton: UIAlertAction? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let primaryButton = primaryButton {
            alertController.addAction(primaryButton)
        } else {
            let defaultButton = UIAlertAction(title: "Ok", style: .default) { _ in }
            alertController.addAction(defaultButton)
        }
        
        if let secondaryButton = secondaryButton {
            alertController.addAction(secondaryButton)
        }
        
        if let topController = UIApplication.getRootController() {
            var presentedVC = topController
            while let next = presentedVC.presentedViewController {
                presentedVC = next
            }
            DispatchQueue.main.async {
                presentedVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
