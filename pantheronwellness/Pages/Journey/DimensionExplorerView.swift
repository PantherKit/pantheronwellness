import SwiftUI

struct DimensionExplorerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @Environment(\.appTheme) var theme
    
    private var profile: UserProfile { coordinator.userProfile }
    
    // Dimensiones elegidas en onboarding (2-3)
    private var focusedDimensions: [WellnessDimension] {
        profile.selectedWellnessFocus
    }
    
    // Dimensiones no elegidas (4-5 restantes)
    private var unexploredDimensions: [WellnessDimension] {
        WellnessDimension.allCases.filter { !profile.selectedWellnessFocus.contains($0) }
    }
    
    // Check si ya completó una dimensión hoy
    private func isCompletedToday(_ dimension: WellnessDimension) -> Bool {
        profile.todaysDimensionCompleted.contains(dimension)
    }
    
    // Check si puede ganar bonus
    private func canEarnBonus(_ dimension: WellnessDimension) -> Bool {
        // Puede ganar bonus si:
        // 1. Ya completó al menos una dimensión hoy
        // 2. Esta dimensión no está completada hoy
        return profile.hasCompletedTodayAction && !isCompletedToday(dimension)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con back button
                HStack {
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        coordinator.navigateToMainTab()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(theme.colors.onBackground)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(theme.colors.onBackground.opacity(0.08))
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.4), value: showContent)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Title Section
                        VStack(spacing: 16) {
                            Text("🌟 Explora Tu Bienestar")
                                .font(.manrope(32, weight: .bold))
                                .foregroundColor(theme.colors.onBackground)
                            
                            Text("Elige otra dimensión para hoy\ny gana +15 XP bonus")
                                .font(.manrope(16, weight: .regular))
                                .foregroundColor(theme.colors.onBackground.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                        
                        // TUS DIMENSIONES (elegidas en onboarding)
                        if !focusedDimensions.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Tus Dimensiones")
                                    .font(.manrope(20, weight: .bold))
                                    .foregroundColor(theme.colors.onBackground)
                                
                                VStack(spacing: 12) {
                                    ForEach(Array(focusedDimensions.enumerated()), id: \.element) { index, dimension in
                                        DimensionExplorerCard(
                                            dimension: dimension,
                                            isCompleted: isCompletedToday(dimension),
                                            canEarnBonus: canEarnBonus(dimension),
                                            onTap: {
                                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                                impactFeedback.impactOccurred()
                                                coordinator.navigateToActionTimer(dimension: dimension)
                                            }
                                        )
                                        .opacity(showContent ? 1 : 0)
                                        .offset(x: showContent ? 0 : -30)
                                        .animation(.easeOut(duration: 0.5).delay(0.3 + Double(index) * 0.08), value: showContent)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        }
                        
                        // OTRAS DIMENSIONES (no elegidas en onboarding)
                        if !unexploredDimensions.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Otras Dimensiones")
                                    .font(.manrope(20, weight: .bold))
                                    .foregroundColor(theme.colors.onBackground)
                                
                                VStack(spacing: 12) {
                                    ForEach(Array(unexploredDimensions.enumerated()), id: \.element) { index, dimension in
                                        DimensionExplorerCard(
                                            dimension: dimension,
                                            isCompleted: false,
                                            canEarnBonus: profile.hasCompletedTodayAction,
                                            onTap: {
                                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                                impactFeedback.impactOccurred()
                                                coordinator.navigateToActionTimer(dimension: dimension)
                                            }
                                        )
                                        .opacity(showContent ? 1 : 0)
                                        .offset(x: showContent ? 0 : -30)
                                        .animation(.easeOut(duration: 0.5).delay(0.5 + Double(index) * 0.08), value: showContent)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        }
                        
                        // Hint text
                        Text("Toca cualquier dimensión para comenzar")
                            .font(.manrope(14, weight: .regular))
                            .foregroundColor(theme.colors.onBackground.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .opacity(showContent ? 1 : 0)
                            .animation(.easeOut(duration: 0.6).delay(0.8), value: showContent)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 24)
                }
            }
        }
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - DimensionExplorerCard

private struct DimensionExplorerCard: View {
    let dimension: WellnessDimension
    let isCompleted: Bool
    let canEarnBonus: Bool
    let onTap: () -> Void
    @Environment(\.appTheme) var theme
    
    var statusText: String? {
        if isCompleted {
            return "✓ Completado hoy"
        } else if canEarnBonus {
            return "+15 XP"
        }
        return nil
    }
    
    var statusColor: Color {
        if isCompleted {
            return Color(hex: 0x34C759)
        } else if canEarnBonus {
            return Color.orange
        }
        return theme.colors.onBackground.opacity(0.6)
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: dimension.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(dimension.primaryColor)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(dimension.primaryColor.opacity(0.12))
                    )
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(dimension.displayName)
                        .font(.manrope(17, weight: .semibold))
                        .foregroundColor(theme.colors.onBackground)
                    
                    Text(dimension.identityStatement)
                        .font(.manrope(14, weight: .regular))
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Status badge
                if let status = statusText {
                    Text(status)
                        .font(.manrope(13, weight: .semibold))
                        .foregroundColor(statusColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(statusColor.opacity(0.12))
                        )
                }
                
                // Arrow
                if !isCompleted {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(theme.colors.onBackground.opacity(0.4))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isCompleted ? 
                                    Color(hex: 0x34C759).opacity(0.3) : 
                                    theme.colors.onBackground.opacity(0.08),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isCompleted)
        .opacity(isCompleted ? 0.6 : 1.0)
        .scaleEffect(isCompleted ? 0.98 : 1.0)
    }
}

#Preview {
    DimensionExplorerView()
        .environmentObject(AppCoordinator())
}
