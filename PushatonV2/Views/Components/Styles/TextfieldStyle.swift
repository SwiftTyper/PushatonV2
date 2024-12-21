//
//  TextfieldStyle.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 18/12/2024.
//

import Foundation
import SwiftUI

struct LimitedTextFieldStyle: ViewModifier {
    @Binding var isPasswordHidden: Bool
    let isPassword: Bool
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            if isPassword {
                Button {
                    isPasswordHidden.toggle()
                } label: {
                    Image(systemName: "eye")
                        .symbolVariant(isPasswordHidden ? .slash : .none)
                        .contentTransition(.symbolEffect)
                        .animation(.easeInOut(duration: 0.2), value: isPasswordHidden)
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color(UIColor.tertiarySystemFill))
        .cornerRadius(12)
    }
}

extension View {
    func limitedTextFieldStyle(isPassword: Bool = false, isPasswordHidden: Binding<Bool> = .constant(false)) -> some View {
        modifier(LimitedTextFieldStyle(isPasswordHidden: isPasswordHidden, isPassword: isPassword))
    }
}
