//
//  PopupView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 14/01/2025.
//

import Foundation
import SwiftUI
import Amplify

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
                
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.title)
                        .foregroundStyle(Color.primaryText)
                    
                    Form {
                        Toggle("Sound", isOn: AudioPlayerManager.shared.$isAudioEnabled)
                        
                        Button("Sign Out") {
                            Task {
                                await Amplify.Auth.signOut()
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .frame(width: 300, height: 180)
                .padding()
                .background(Color.primaryBackground)
                .cornerRadius(20)
                .shadow(radius: 10)
                .overlay(alignment: .topTrailing){
                    Button {
                       isShowing = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(Color.primaryText)
                    }
                    .padding([.top, .trailing], 15)
                }
            }
        }
    }
}

#Preview {
    PopupView(isShowing: .constant(true))
}
