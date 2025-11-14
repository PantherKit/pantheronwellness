import SwiftUI

struct ActionHeroCard: View {
    let dimension: WellnessDimension
    let onStart: () -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 20) {
            // Dimension Badge
            HStack(spacing: 8) {
                Image(systemName: dimension.iconName)
                    .font(.system(size: 16, weight: .medium))
                Text(dimension.displayName)
                    .font(theme.typography.body2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(dimension.primaryColor.opacity(0.15))
            )
            .foregroundColor(dimension.primaryColor)
            
            // Identity Statement
            Text(dimension.identityStatement)
                .font(theme.typography.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.onSurface)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
            
            // Micro Action
            VStack(spacing: 8) {
                Text(dimension.microAction)
                    .font(theme.typography.body1)
                    .foregroundColor(theme.colors.onSurface.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text("2 minutos")
                        .font(theme.typography.caption)
                }
                .foregroundColor(theme.colors.onSurface.opacity(0.6))
            }
            
            // CTA Button
            Button(action: onStart) {
                HStack(spacing: 8) {
                    Text("Comenzar")
                        .font(theme.typography.button)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(dimension.primaryColor)
                        .shadow(color: dimension.primaryColor.opacity(0.3), radius: 8, y: 4)
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
        )
    }
}

// MARK: - Completed Hero Card
struct CompletedHeroCard: View {
    let dimension: WellnessDimension
    let onViewProgress: () -> Void
    let onDoMore: () -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 20) {
            // Success Icon
            ZStack {
                Circle()
                    .fill(dimension.primaryColor.opacity(0.15))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(dimension.primaryColor)
            }
            
            // Title
            VStack(spacing: 8) {
                Text("¡Completaste tu día!")
                    .font(theme.typography.title2)
                    .fontWeight(.bold)
                    .foregroundColor(theme.colors.onSurface)
                
                Text("Actuaste como alguien \(dimension.displayName.lowercased())")
                    .font(theme.typography.body2)
                    .foregroundColor(theme.colors.onSurface.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                Button(action: onViewProgress) {
                    Text("Ver mi progreso")
                        .font(theme.typography.button)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(dimension.primaryColor)
                        )
                }
                
                Button(action: onDoMore) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text("Hacer otra dimensión (+15 XP)")
                            .font(theme.typography.body2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(dimension.primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(dimension.primaryColor.opacity(0.1))
                    )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        ActionHeroCard(dimension: .mental, onStart: {})
            .padding()
        
        CompletedHeroCard(
            dimension: .physical,
            onViewProgress: {},
            onDoMore: {}
        )
        .padding()
    }
}

