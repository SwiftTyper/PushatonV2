//
//  CountdownButton.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 22/12/2024.
//

import Foundation
import SwiftUI

struct CountdownThrottledButton<Content: View>: View {
    @State private var isDisabled: Bool = false
    @State private var timeRemaining: Double = 60
    @State private var timer: Timer?
    
    let action: () -> Void
    let label: () -> Content
    
    var body: some View {
        ZStack {
            if isDisabled {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .trim(from: 0, to: timeRemaining / 60)
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: timeRemaining)
                    
                    Text("\(Int(timeRemaining))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .frame(width: 24, height: 24)
                .padding(.leading, 2)
            } else {
                Button {
                    action()
                    startCountdown()
                } label: {
                    label()
                }
                .buttonStyle(TertiaryButtonStyle())
            }
        }
    }
    
    private func startCountdown() {
        isDisabled = true
        timeRemaining = 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                stopCountdown()
            }
        }
    }
    
    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isDisabled = false
        timeRemaining = 60
    }
}
