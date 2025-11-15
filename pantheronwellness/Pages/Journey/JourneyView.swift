import SwiftUI

struct JourneyView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    @Environment(\.appTheme) var theme
    
    private var profile: UserProfile { coordinator.userProfile }
    
    private var weekProgress: Int {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let completedThisWeek = profile.dailyProgressHistory.filter {
            $0.date >= weekStart
        }
        return completedThisWeek.count
    }
    
    private var hasCompletedToday: Bool {
        !profile.todaysDimensionCompleted.isEmpty
    }
    
    // Dimensiones que el usuario seleccionó en onboarding (2-3)
    private var focusedDimensions: [WellnessDimension] {
        profile.selectedWellnessFocus
    }
    
    // Dimensiones que NO seleccionó (4-5 restantes)
    private var unexploredDimensions: [WellnessDimension] {
        WellnessDimension.allCases.filter { !profile.selectedWellnessFocus.contains($0) }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tu Journey")
                        .font(.manrope(32, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                        .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)
                    
                    // Stats Row
                    HStack(spacing: 16) {
                        StatMiniCard(
                            icon: "flame.fill",
                            value: "\(profile.currentStreak)",
                            label: "días",
                            color: Color.orange
                        )
                        
                        StatMiniCard(
                            icon: "bolt.fill",
                            value: "\(profile.totalXP)",
                            label: "XP",
                            color: Color.yellow
                        )
                        
                        StatMiniCard(
                            icon: "chart.bar.fill",
                            value: "\(weekProgress)/7",
                            label: "semana",
                            color: Color(hex: 0x34C759)
                        )
                    }
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 50)
                
                // Dimensiones Activas
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tus Dimensiones Activas")
                        .font(.manrope(20, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(focusedDimensions.enumerated()), id: \.element) { index, dimension in
                            let identity = profile.identities[dimension]
                            let days = identity?.evidenceCount ?? 0
                            
                            DimensionProgressBar(
                                dimension: dimension,
                                days: days,
                                maxDays: 7
                            )
                            .opacity(showContent ? 1 : 0)
                            .offset(x: showContent ? 0 : -30)
                            .animation(.easeOut(duration: 0.5).delay(0.3 + Double(index) * 0.1), value: showContent)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                
                // CTA - Estado dependiente (movido aquí, justo después de Dimensiones Activas)
                CTAButton(
                    hasCompletedToday: hasCompletedToday,
                    action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        coordinator.navigateToDimensionExplorer()
                    }
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                
                // Micro-Celebración
                if hasCompletedToday, let lastDimension = profile.todaysDimensionCompleted.last {
                    MicroCelebrationCard(dimension: lastDimension)
                        .padding(.horizontal, 20)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)
                }
                
                // Balance de Bienestar
                BalanceCard(
                    focusedCount: focusedDimensions.count,
                    unexploredCount: unexploredDimensions.count,
                    hasCompletedToday: hasCompletedToday
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                
                Spacer(minLength: 80)
            }
            .padding(.vertical, 16)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - Subcomponents

private struct StatMiniCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.manrope(18, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
            
            Text(label)
                .font(.manrope(12, weight: .medium))
                .foregroundColor(theme.colors.onBackground.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

private struct DimensionProgressBar: View {
    let dimension: WellnessDimension
    let days: Int
    let maxDays: Int
    @Environment(\.appTheme) var theme
    
    var progress: Double {
        Double(min(days, maxDays)) / Double(maxDays)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: dimension.iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(dimension.primaryColor)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(dimension.primaryColor.opacity(0.12))
                )
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                Text(dimension.displayName)
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(theme.colors.onBackground)
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.colors.onBackground.opacity(0.1))
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 4)
                            .fill(dimension.primaryColor)
                            .frame(width: geometry.size.width * progress)
                    }
                }
                .frame(height: 8)
                
                Text("\(days) días activos")
                    .font(.manrope(12, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

private struct MicroCelebrationCard: View {
    let dimension: WellnessDimension
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("✨ Hoy actuaste como...")
                .font(.manrope(14, weight: .semibold))
                .foregroundColor(dimension.primaryColor)
            
            Text(dimension.identityStatement)
                .font(.manrope(18, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
            
            Text("Tu identidad se está instalando con consistencia 🌱")
                .font(.manrope(14, weight: .regular))
                .foregroundColor(theme.colors.onBackground.opacity(0.7))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(dimension.primaryColor.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(dimension.primaryColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

private struct BalanceCard: View {
    let focusedCount: Int
    let unexploredCount: Int
    let hasCompletedToday: Bool
    @Environment(\.appTheme) var theme
    
    var suggestionText: String {
        if hasCompletedToday {
            return "¡Increíble! ¿Qué tal explorar otra dimensión hoy?"
        } else {
            return "Tienes \(unexploredCount) dimensiones más por descubrir"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Balance de Bienestar")
                .font(.manrope(20, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
            
            HStack(spacing: 24) {
                // Activas
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(0..<focusedCount, id: \.self) { _ in
                            Circle()
                                .fill(Color(hex: 0x34C759))
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    Text("\(focusedCount) activas")
                        .font(.manrope(14, weight: .semibold))
                        .foregroundColor(theme.colors.onBackground)
                }
                
                Divider()
                    .frame(height: 40)
                
                // Por explorar
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(0..<min(unexploredCount, 4), id: \.self) { _ in
                            Circle()
                                .fill(theme.colors.onBackground.opacity(0.2))
                                .frame(width: 12, height: 12)
                        }
                    }
                    
                    Text("\(unexploredCount) por explorar")
                        .font(.manrope(14, weight: .semibold))
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.colors.onBackground.opacity(0.03))
            )
            
            Text(suggestionText)
                .font(.manrope(14, weight: .regular))
                .foregroundColor(theme.colors.onBackground.opacity(0.7))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }
}

private struct CTAButton: View {
    let hasCompletedToday: Bool
    let action: () -> Void
    @Environment(\.appTheme) var theme
    
    var buttonText: String {
        hasCompletedToday ? "Explorar otra dimensión" : "Comenzar mi acción de hoy"
    }
    
    var buttonSubtext: String? {
        hasCompletedToday ? "Gana +15 XP bonus" : nil
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text(buttonText)
                        .font(.manrope(17, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                if let subtext = buttonSubtext {
                    Text(subtext)
                        .font(.manrope(13, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
            }
            .padding(.horizontal, hasCompletedToday ? 28 : 32)
            .padding(.vertical, hasCompletedToday ? 16 : 18)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: 0x34C759), Color(hex: 0x30B350)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: 0x34C759).opacity(0.3), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasCompletedToday)
    }
}

#Preview {
    JourneyView(coordinator: AppCoordinator())
}
