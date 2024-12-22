//
//  VerificationView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 17/12/2024.
//

import Foundation
import SwiftUI

struct VerificationView: View {
    @State var fields: [String] = Array(repeating: "", count: 6)
    @FocusState var activeField: OTPField?
    
    init(
        verifyAction: @escaping (String) -> Void,
        resendAction: @escaping () -> Void
    ) {
        self.verifyAction = verifyAction
        self.resendAction = resendAction
    }
    
    let verifyAction: (String) -> Void
    let resendAction: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 14) {
                ForEach(0..<6, id: \.self) { index in
                    VStack(spacing: 8) {
                        TextField("", text: $fields[index])
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .focused($activeField, equals: activeStateForIndex(index: index))
                        
                        Rectangle()
                            .fill(activeField == activeStateForIndex(index: index) ? .blue : .gray.opacity(0.3))
                            .frame(height: 4)
                    }
                    .frame(width: 40)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .safeAreaInset(edge: .bottom) { bottomToolbar }
        .navigationTitle("Code Verification")
        .onChange(of: fields) { oldValue, newValue in
            optCondition(value: newValue)
        }
    }
}

extension VerificationView {
    var bottomToolbar: some View {
        VStack(alignment: .center, spacing: 15){
            Divider()
        
            VStack(alignment: .center, spacing: 24) {
                Button {
                    let code = String(fields.reduce("", +))
                    verifyAction(code)
                } label: {
                    Text("Verify")
                }
                .disabled(checkStates())
                .buttonStyle(PrimaryButtonStyle(isDisabled: checkStates()))
                
                if activeField == nil {
                    HStack {
                        Text("Didn't receive code?")
                            .font(.body)
                            .foregroundStyle(Color.secondary)
                        
                        CountdownThrottledButton {
                            resendAction()
                        } label: {
                            Text("Resend")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, activeField != nil ? 15 : 30)
        }
        .background(Color(UIColor.systemBackground))
    }
}

extension VerificationView {
    func checkStates() -> Bool {
        for index in 0..<6 {
            if fields[index].isEmpty { return true }
        }
        return false
    }
    
    func optCondition(value: [String]) {
        for index in 0..<5 {
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        for index in 1...5 {
            if value[index].isEmpty && !value[index-1].isEmpty {
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        for index in 0..<6 {
            if value[index].count > 1 {
                fields[index] = String(value[index].last!)
            }
        }
    }
    
    func activeStateForIndex(index: Int) -> OTPField {
        switch index {
            case 0: return .field1
            case 1: return .field2
            case 2: return .field3
            case 3: return .field4
            case 4: return .field5
            default: return .field6
        }
    }
    
    enum OTPField {
       case field1
       case field2
       case field3
       case field4
       case field5
       case field6
    }
}

#Preview {
    NavigationStack {
        VerificationView(
            verifyAction: { _ in },
            resendAction: {}
        )
    }
}
