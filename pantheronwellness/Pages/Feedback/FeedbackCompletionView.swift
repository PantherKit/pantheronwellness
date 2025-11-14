import SwiftUI

struct FeedbackCompletionView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    let dimension: WellnessDimension
    let xpEarned: Int
    let newStreak: Int
    
    @State private var showContent = false
    @State private var showConfetti = false
    @State private var scale: CGFloat = 0.5
    @Environment(\.appTheme) var theme
    
    var body: some View {
        ZStack {
            // Background
            dimension.primaryColor.opacity(0.05)
                .ignoresSafeArea()
            
            // Confetti
            if showConfetti {
                ConfettiView()
            }
            
            VStack(spacing: 32) {
                Spacer()
                
                // Success Animation
                ZStack {
                    // Outer Circle
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    dimension.primaryColor.opacity(0.3),
                                    dimension.primaryColor.opacity(0.1)
                                ]),
                                center: .center,
                                startRadius: 30,
                                endRadius: 100
                            )
                        )
                        .frame(width: 160, height: 160)
                        .scaleEffect(scale)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: scale)
                    
                    // Checkmark
                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(dimension.primaryColor)
                        .scaleEffect(scale)
                        .animation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.2), value: scale)
                }
                
                // Message
                VStack(spacing: 16) {
                    Text("¡Increíble!")
                        .font(theme.typography.display)
                        .fontWeight(.bold)
                        .foregroundColor(theme.colors.onBackground)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                    
                    Text("Hoy actuaste como alguien \(dimension.displayName.lowercased())")
                        .font(theme.typography.title3)
                        .foregroundColor(theme.colors.onBackground.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)
                }
                .padding(.horizontal, 32)
                
                // Rewards Section
                VStack(spacing: 16) {
                    // XP Earned
                    HStack(spacing: 12) {
                        Image(systemName: "bolt.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("+\(xpEarned) XP")
                                .font(theme.typography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.colors.onSurface)
                            
                            Text("Experience Points")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.onSurface.opacity(0.6))
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                    )
                    
                    // Streak
                    HStack(spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.title2)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(newStreak) días")
                                .font(theme.typography.title2)
                                .fontWeight(.bold)
                                .foregroundColor(theme.colors.onSurface)
                            
                            Text(newStreak == 1 ? "Nueva racha" : "Racha actual")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.onSurface.opacity(0.6))
                        }
                        
                        Spacer()
                        
                        if newStreak >= 5 {
                            Text("🔥")
                                .font(.system(size: 32))
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                    )
                }
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.7), value: showContent)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    coordinator.navigateToHome()
                }) {
                    Text("Continuar")
                        .font(theme.typography.button)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(dimension.primaryColor)
                                .shadow(color: dimension.primaryColor.opacity(0.3), radius: 8, y: 4)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(1.0), value: showContent)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scale = 1.0
                showContent = true
                showConfetti = true
            }
            
            // Play success sound
            let impact = UINotificationFeedbackGenerator()
            impact.notificationOccurred(.success)
            
            // Hide confetti after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showConfetti = false
            }
        }
    }
}

// MARK: - Confetti View
struct ConfettiView: View {
    @State private var confettiPieces: [ConfettiPiece] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confettiPieces) { piece in
                    ConfettiShape()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size)
                        .position(piece.position)
                        .rotationEffect(piece.rotation)
                        .opacity(piece.opacity)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                generateConfetti(in: geometry.size)
            }
        }
    }
    
    private func generateConfetti(in size: CGSize) {
        let colors: [Color] = [.red, .yellow, .blue, .green, .purple, .orange, .pink]
        
        for i in 0..<50 {
            let piece = ConfettiPiece(
                id: UUID(),
                color: colors.randomElement() ?? .blue,
                size: CGFloat.random(in: 8...15),
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: -100...size.height * 0.3)
                ),
                rotation: Angle(degrees: Double.random(in: 0...360)),
                opacity: 1.0
            )
            
            withAnimation(
                Animation.linear(duration: Double.random(in: 2...4))
                    .delay(Double(i) * 0.02)
            ) {
                var fallingPiece = piece
                fallingPiece.position.y = size.height + 50
                fallingPiece.rotation = Angle(degrees: piece.rotation.degrees + Double.random(in: 360...720))
                fallingPiece.opacity = 0
                confettiPieces.append(fallingPiece)
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id: UUID
    let color: Color
    let size: CGFloat
    var position: CGPoint
    var rotation: Angle
    var opacity: Double
}

struct ConfettiShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: rect)
        return path
    }
}

#Preview {
    FeedbackCompletionView(
        dimension: .mental,
        xpEarned: 30,
        newStreak: 8
    )
    .environmentObject(AppCoordinator())
}

