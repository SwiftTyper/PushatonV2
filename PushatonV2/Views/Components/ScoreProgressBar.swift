//
//  ScoreProgressionBar.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 10/01/2025.
//

import Foundation
import SwiftUI

struct ScoreProgressBar: View {
    let score: Int
    let maxScore: Int
    let opponentId: String
    
    private let height: CGFloat = 38
    
    var mainThumbHeight: CGFloat {
        height * 1.2
    }
    
    var opponentThumbHeight: CGFloat {
        height * 1.4
    }
    
    private var progress: CGFloat {
        CGFloat(score) / CGFloat(maxScore)
    }
    
    var background: some View {
        Capsule()
            .fill(Color(red: 0.15, green: 0.2, blue: 0.4))
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
            .frame(height: height)
    }
    
    var foreground: some View {
        UnevenRoundedRectangle(topLeadingRadius: height/2, bottomLeadingRadius: height/2)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.3, green: 0.7, blue: 1.0),
                        Color(red: 0.2, green: 0.5, blue: 0.9)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                UnevenRoundedRectangle(topLeadingRadius: height/2, bottomLeadingRadius: height/2)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .blur(radius: 0.5)
            )
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.0)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .mask(
                        UnevenRoundedRectangle(topLeadingRadius: height/2, bottomLeadingRadius: height/2)
                    )
            )
            .frame(height: height)
    }
    
    var mainThumb: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.8, blue: 1.0),
                            Color(red: 0.2, green: 0.6, blue: 0.9)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0.0)
                                ]),
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                        .padding(2)
                )
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
            
            Text("\(score)")
                .foregroundColor(.primaryText)
                .font(.system(size: 16, weight: .bold))
                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
        }
        .frame(width: mainThumbHeight, height: mainThumbHeight)
        .overlay {
            Text("You")
                .font(.headline)
                .foregroundStyle(.primaryText)
                .offset(y: -mainThumbHeight)
        }
    }
    
    var opponentThumb: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.15, green: 0.2, blue: 0.4))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            Text("\(maxScore)")
                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.1))
                .font(.system(size: 16, weight: .bold))
                .shadow(color: .black.opacity(0.3), radius: 1, y: 1)
        }
        .frame(width: opponentThumbHeight, height: opponentThumbHeight)
        .overlay {
            Text(opponentId)
                .font(.headline)
                .foregroundStyle(Color(red: 0.15, green: 0.2, blue: 0.4))
                .fixedSize()
                .offset(y: -mainThumbHeight)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                background
                    .frame(maxWidth: geometry.size.width - opponentThumbHeight/2)
                
                opponentThumb
                    .position(
                        x: geometry.size.width - opponentThumbHeight/2,
                        y: geometry.size.height/2
                    )
                
                foreground
                    .frame(width: (geometry.size.width - opponentThumbHeight/2) * progress)
                
                mainThumb
                    .position(
                      x: max(mainThumbHeight/2, min((geometry.size.width - opponentThumbHeight/2) * progress, geometry.size.width)),
                      y: geometry.size.height/2
                    )
            }
        }
        .frame(height: opponentThumbHeight)
    }
}

#Preview {
    ScoreProgressBar(
        score: 200,
        maxScore: 300,
        opponentId: "Player123"
    )
}
