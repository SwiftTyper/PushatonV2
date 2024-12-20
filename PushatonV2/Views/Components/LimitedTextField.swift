//
//  LimitedTextField.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation
import SwiftUI

struct LimitedTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var focused: Bool
    @Binding var nextResponder: Bool
    @Binding var isPassword: Bool
    
    let characterLimit: Int
    let placeholder: String
    let autocorrectionType: UITextAutocorrectionType
    let autocapitalizationType: UITextAutocapitalizationType
    
    init(text: Binding<String>, focused: Binding<Bool> = .constant(false), nextResponder: Binding<Bool> = .constant(false), characterLimit: Int, placeholder: String, isPassword: Binding<Bool> = .constant(false), autocorrectionType: UITextAutocorrectionType = .no, autocapitalizationType: UITextAutocapitalizationType = .none) {
        self._text = text
        self._focused = focused
        self._nextResponder = nextResponder
        self._isPassword = isPassword
        self.characterLimit = characterLimit
        self.placeholder = placeholder
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.autocorrectionType = autocorrectionType
        textField.autocapitalizationType = autocapitalizationType
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isPassword
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isPassword
        
        if focused && context.coordinator.didBecomeFirstResponder != true {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
                context.coordinator.didBecomeFirstResponder = true
                context.coordinator.didResignFirstResponder = false
            }
        } else if !focused && context.coordinator.didResignFirstResponder != true {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
                context.coordinator.didBecomeFirstResponder = false
                context.coordinator.didResignFirstResponder = true
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: LimitedTextField
        var didBecomeFirstResponder: Bool? = nil
        var didResignFirstResponder: Bool? = nil
        
        init(_ parent: LimitedTextField) {
            self.parent = parent
        }
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return range.location < parent.characterLimit
        }
    
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.focused = true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            didBecomeFirstResponder = false
            didResignFirstResponder = true
            parent.focused = false
            parent.nextResponder = true
            return true
        }
    }
}
