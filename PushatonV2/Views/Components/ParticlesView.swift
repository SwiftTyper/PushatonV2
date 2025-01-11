//
//  ParticlesView.swift
//  PushatonV2
//
//  Created by Wit Owczarek on 11/01/2025.
//

import Foundation
import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var scale: CGFloat
    var opacity: Double
    var speed: Double
}

struct ParticlesView: View {
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.white)
                        .frame(width: 4, height: 4)
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .position(particle.position)
                }
            }
            .onAppear {
                // Initialize particles
                for _ in 0..<20 {
                    particles.append(createRandomParticle(in: geometry.size))
                }
            }
            .onReceive(timer) { _ in
                updateParticles(in: geometry.size)
            }
        }
    }
    
    private func createRandomParticle(in size: CGSize) -> Particle {
        Particle(
            position: CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            ),
            scale: CGFloat.random(in: 0.5...1.5),
            opacity: Double.random(in: 0.3...0.7),
            speed: Double.random(in: 0...1)
        )
    }
    
    private func updateParticles(in size: CGSize) {
        for index in particles.indices {
            var particle = particles[index]
            particle.position.y -= particle.speed
            
            if particle.position.y < -10 {
                particles[index] = createRandomParticle(in: size)
                particles[index].position.y = size.height + 10
            } else {
                particles[index] = particle
            }
        }
    }
}
