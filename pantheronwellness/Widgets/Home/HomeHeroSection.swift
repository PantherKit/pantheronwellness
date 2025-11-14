import SwiftUI

struct HomeHeroSection: View {
    let message: String
    let subtitle: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 20) {
            // Hero Visual
            ZStack {
                // Background gradient circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(hex: 0xFFB6D9).opacity(0.3),
                                Color(hex: 0xFFB6D9).opacity(0.1)
                            ],
                            center: .center,
                            startRadius: 30,
                            endRadius: 80
                        )
                    )
                    .frame(width: 140, height: 140)
                
                // Icon
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(Color(hex: 0xFF69B4))
                    .symbolRenderingMode(.hierarchical)
            }
            .padding(.top, 20)
            
            // Message
            VStack(spacing: 12) {
                Text(message)
                    .font(.manrope(20, weight: .bold))
                    .foregroundColor(theme.colors.onBackground)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.manrope(14, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: 0xFFE5F0).opacity(0.5),
                            Color(hex: 0xFFE5F0).opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

#Preview {
    HomeHeroSection(
        message: "¡Buenos días! Comienza tu día con bienestar",
        subtitle: "Cada pequeña acción cuenta en tu journey"
    )
    .padding()
}
