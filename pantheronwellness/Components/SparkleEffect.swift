import SwiftUI

struct SparkleEffect: View {
    let color: Color
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { index in
                SparkleParticle(
                    color: color,
                    delay: Double(index) * 0.1,
                    angle: Double(index) * 45
                )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct SparkleParticle: View {
    let color: Color
    let delay: Double
    let angle: Double
    
    @State private var opacity: Double = 0
    @State private var scale: Double = 0
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(color)
            .opacity(opacity)
            .scaleEffect(scale)
            .offset(
                x: cos(angle * .pi / 180) * offset,
                y: sin(angle * .pi / 180) * offset
            )
            .onAppear {
                withAnimation(
                    .easeOut(duration: 1.0)
                    .delay(delay)
                ) {
                    opacity = 1
                    scale = 1
                    offset = 40
                }
                
                withAnimation(
                    .easeIn(duration: 0.5)
                    .delay(delay + 0.5)
                ) {
                    opacity = 0
                    scale = 0.5
                }
            }
    }
}

struct PulseEffect: View {
    let color: Color
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    
    var body: some View {
        Circle()
            .stroke(color.opacity(0.3), lineWidth: 2)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeOut(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    scale = 3
                    opacity = 0
                }
            }
    }
}
