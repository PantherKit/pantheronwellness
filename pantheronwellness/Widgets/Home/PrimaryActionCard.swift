import SwiftUI
import Lottie

struct PrimaryActionCard: View {
    let dimension: WellnessDimension
    let onStart: () -> Void
    @Environment(\.appTheme) var theme
    @State private var isPressed = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                // Lottie Animation (sin círculo)
                LottieView(animation: .named("relaxingAnimation"))
                    .playing(loopMode: .loop)
                    .animationSpeed(0.8)
                    .frame(width: 220, height: 160)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: -45)
            
                // Identity Statement
                Text(dimension.identityStatement)
                    .font(.manrope(20, weight: .bold))
                    .foregroundColor(theme.colors.onBackground)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                
                // Micro-action
                Text(dimension.microAction)
                    .font(.manrope(15, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                
                // CTA Button
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    onStart()
                }) {
                    HStack(spacing: 12) {
                        Text("Comenzar ahora")
                            .font(.manrope(17, weight: .bold))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(dimension.primaryColor)
                            .shadow(
                                color: dimension.primaryColor.opacity(0.4),
                                radius: isPressed ? 4 : 12,
                                y: isPressed ? 2 : 6
                            )
                    )
                    .scaleEffect(isPressed ? 0.97 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = pressing
                    }
                }, perform: {})
            }
            .padding(28)
            .background(
                ZStack {
                    // Background gradient de dimensión
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [
                                    dimension.primaryColor.opacity(0.15),
                                    dimension.primaryColor.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Fade out overlay
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.65),
                            Color.white
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                }

            )
            
            // Dimension Tag - Esquina superior derecha
            Text(dimension.displayName)
                .font(.manrope(13, weight: .semibold))
                .foregroundColor(dimension.primaryColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(dimension.primaryColor.opacity(0.15))
                )
                .padding([.top, .trailing], 20)
        }
    }
}

#Preview {
    PrimaryActionCard(
        dimension: .physical,
        onStart: {}
    )
    .padding()
}
