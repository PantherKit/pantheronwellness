import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var showChips = false
    @Environment(\.appTheme) var theme
    
    private var selectedDimensions: [WellnessDimension] {
        Array(coordinator.selectedFocusDimensions)
    }
    
    var body: some View {
        ZStack {
            // Background
            theme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Success Icon
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    theme.colors.primary.opacity(0.2),
                                    theme.colors.primary.opacity(0.05)
                                ]),
                                center: .center,
                                startRadius: 30,
                                endRadius: 80
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(showContent ? 1 : 0.5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundColor(theme.colors.primary)
                        .scaleEffect(showContent ? 1 : 0.1)
                        .animation(.spring(response: 1.0, dampingFraction: 0.6).delay(0.2), value: showContent)
                }
                .padding(.bottom, 32)
                
                // Title
                VStack(spacing: 16) {
                    Text("Perfecto, vamos a\nenfocarnos en:")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onBackground)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.3),
                            value: showContent
                        )
                    
                    // Chips with selected dimensions
                    VStack(spacing: 12) {
                        ForEach(Array(selectedDimensions.enumerated()), id: \.element) { index, dimension in
                            DimensionChip(dimension: dimension)
                                .opacity(showChips ? 1 : 0)
                                .offset(x: showChips ? 0 : -30)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                                    .delay(0.5 + Double(index) * 0.1),
                                    value: showChips
                                )
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Text("Tu journey personalizado está listo")
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.8),
                            value: showContent
                        )
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // CTA Button
                VStack(spacing: 16) {
                    AnimatedButton(
                        title: "Comenzar mi viaje",
                        action: {
                            coordinator.navigateToHome()
                        },
                        style: .primary
                    )
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(
                        .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.0),
                        value: showContent
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            showContent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showChips = true
            }
        }
    }
}

// MARK: - Dimension Chip
struct DimensionChip: View {
    let dimension: WellnessDimension
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: dimension.iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(dimension.primaryColor)
            
            Text(dimension.displayName)
                .font(theme.typography.body1)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.onSurface)
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(dimension.primaryColor)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(dimension.primaryColor.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(dimension.primaryColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

#Preview {
    let coordinator = AppCoordinator()
    coordinator.selectedFocusDimensions = [.physical, .mental, .emotional]
    return ConfirmationView(coordinator: coordinator)
}

