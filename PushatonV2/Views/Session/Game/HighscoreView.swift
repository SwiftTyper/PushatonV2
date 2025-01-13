import SwiftUI

struct RayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY - 1))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY - rect.width * 0.03))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY + rect.width * 0.03))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + 1))
        path.closeSubpath()
        return path
    }
}

struct RayView: View {
    let delay: Double
    @State private var isAnimating = false
    
    var body: some View {
        RayShape()
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: .white.opacity(0.8), location: 0),
                        .init(color: .white.opacity(0.6), location: 0.3),
                        .init(color: .white.opacity(0), location: 1)
                    ],
                    startPoint: .trailing,
                    endPoint: .leading
                )
            )
            .frame(width: UIScreen.main.bounds.width * 3, height: 8)
            .offset(x: isAnimating ? -UIScreen.main.bounds.width * 2 : 0)
            .animation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                    .delay(delay),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct HighScoreView: View {
    let score: Int
    let dimissAction: () -> Void

    var body: some View {
        ZStack {
            Color.white
            
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.7),
                    Color.orange
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<9) { index in
                        RayView(delay: Double(index) * 0.15)
                            .rotationEffect(.degrees(Double(index) * 20 - 90))
                    }
                }
                .frame(width: geometry.size.width * 2)
                .position(
                    x: geometry.size.width * 1.4,
                    y: geometry.size.height / 2
                )
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("New High Score!")
                    .font(.largerTitle)
                    .foregroundColor(.secondaryText)
                
                Text("\(score)")
                    .font(.largestTitle)
                    .foregroundColor(.secondaryText)
                
                Spacer()
                Spacer()
                
                Text("Tap to continue")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                
                Spacer()
            }
        }
        .onTapGesture {
            dimissAction()
        }
        .onAppear {
            AudioPlayerManager.shared.play(.record)
        }
        .onDisappear() {
            AudioPlayerManager.shared.stopAudio(.record)
        }
    }
}


#Preview {
    HighScoreView(score: 2384) {
        
    }
}
