//
//  PopupView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 14/01/2025.
//

import Foundation
import SwiftUI

struct PopupView: View {
    @Binding var isShowing: Bool
    @State private var toggleValue = false
    
    var body: some View {
        ZStack {
            if isShowing {
                Color.white.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isShowing = false
                    }
                
                VStack(spacing: 20) {
                    Text("Settings")
                        .font(.headline)
                    
                    Toggle("Sound", isOn: $toggleValue)
                        .padding(.horizontal)
                }
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .overlay {
                    Button {
                       isShowing = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct TestView: View {
    @State private var showPopup = false
    
    var body: some View {
        ZStack {
            // Main content
            Button("Show Popup") {
                showPopup = true
            }
            
            // Popup
            PopupView(isShowing: $showPopup)
        }
    }
}

#Preview {
    TestView()
}
