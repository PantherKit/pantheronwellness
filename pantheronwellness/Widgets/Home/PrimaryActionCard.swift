import SwiftUI

struct PrimaryActionCard: View {
    let dimension: WellnessDimension
    let onStart: () -> Void
    @Environment(\.appTheme) var theme
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Badge: "Tu acción de hoy"
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.orange)
                
                Text("Tu acción de hoy")
                    .font(.manrope(14, weight: .semibold))
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.15))
            )
            
            // Dimension Icon + Name
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    dimension.primaryColor.opacity(0.2),
                                    dimension.primaryColor.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: dimension.iconName)
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(dimension.primaryColor)
                }
                
                Text(dimension.displayName)
                    .font(.manrope(18, weight: .bold))
                    .foregroundColor(theme.colors.onBackground)
            }
            
            // Identity Statement
            Text(dimension.identityStatement)
                .font(.manrope(20, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            // Micro-action
            Text(dimension.microAction)
                .font(.manrope(15, weight: .regular))
                .foregroundColor(theme.colors.onBackground.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            // Time badge
            HStack(spacing: 6) {
                Image(systemName: "timer")
                    .font(.system(size: 14, weight: .medium))
                Text("2 min")
                    .font(.manrope(14, weight: .semibold))
            }
            .foregroundColor(dimension.primaryColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(dimension.primaryColor.opacity(0.1))
            )
            
            // CTA Button
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                onStart()
            }) {
                HStack(spacing: 8) {
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
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: 0x34C759),
                                    Color(hex: 0x30B350)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(
                            color: Color(hex: 0x34C759).opacity(0.4),
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
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 20,
                    x: 0,
                    y: 8
                )
        )
    }
}

#Preview {
    PrimaryActionCard(
        dimension: .physical,
        onStart: {}
    )
    .padding()
}
