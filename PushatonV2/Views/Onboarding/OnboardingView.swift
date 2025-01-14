//
//  Onboardingiew.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 14/01/2025.
//

import Foundation
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var tabViewSelection: Int = 0
    var didSelectGetStarted: () -> Void
    
    init(didSelectGetStarted: @escaping () -> Void) {
        self.didSelectGetStarted = didSelectGetStarted
    }
}

struct OnboardingView {
    @StateObject var viewModel: OnboardingViewModel
}

extension OnboardingView: View {
    var body: some View {
        VStack(spacing: 0){
            TabView(selection: $viewModel.tabViewSelection) {
                Group {
                    OnboardingSlide(
                        title: "Welcome to Pushaton",
                        description: "Experience the fusion of calisthenics and gaming! Your real-life push-ups control the game – jump, dash and run",
                        icon: {
                            Image("AppIconImage")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                        }
                    )
                    .tag(0)
                    
                    OnboardingSlide(
                       title: "Real-Time 1v1 Racing",
                       description: "Race head-to-head against real players! Experience multiplayer battles where every second counts.",
                       icon: {
                           RoundedRectangle(cornerRadius: 30)
                               .foregroundStyle(Color.accentColor.opacity(0.3))
                               .frame(width: 150, height: 150)
                               .overlay(alignment: .center) {
                                   Image(systemName: "figure.run")
                                       .resizable()
                                       .aspectRatio(contentMode: .fit)
                                       .foregroundStyle(Color.accentColor)
                                       .frame(width: 100, height: 100)
                                       .offset(x: 5)
                               }
                       }
                   )
                   .tag(1)
                    
                    OnboardingSlide(
                        title: "Real Life Controls",
                        description: "Run by holding a pushup hold. \nPerform a pushup up motion to jump obstacles and dash below them by doing a pushup down action. ",
                        icon: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(Color.accentColor.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(alignment: .center) {
                                    Image(systemName: "figure.taichi")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.accentColor)
                                        .frame(width: 100, height: 100)
                                        .offset(x: 5)
                                }
                        }
                    )
                    .tag(2)
                    
                    OnboardingSlide(
                        title: "How To Play",
                        description: "Place your device 1-2m (4-7ft) away for full push-up capture. Ensure an unobstructed camera view for smooth gameplay. Assume a push-up position while focusing on the screen.",
                        icon: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(Color.accentColor.opacity(0.3))
                                .frame(width: 150, height: 150)
                                .overlay(alignment: .center) {
                                    Image(systemName: "list.bullet.clipboard")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(Color.accentColor)
                                        .frame(width: 100, height: 100)
                                }
                        }
                    )
                    .tag(3)
                }
                .padding(.bottom, 0.15 * UIScreen.main.bounds.height)
            }
            .tabViewStyle(.page)
            
            Button("Start Playing") {
                viewModel.didSelectGetStarted()
            }
            .buttonStyle(PrimaryButtonStyle(isDisabled: (viewModel.tabViewSelection != 3)))
            .disabled((viewModel.tabViewSelection != 3))
            .frame(maxWidth: 360, alignment: .bottom)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: UIScreen.main.bounds.size.height * 0.05, trailing: 16))
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.accentColor.opacity(0.25))
        }
    }
}
