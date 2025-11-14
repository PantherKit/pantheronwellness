import SwiftUI

struct ProgressView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var selectedDimension: WellnessDimension?
    @State private var showContent = false
    @State private var showCircle = false
    @Environment(\.appTheme) var theme
    
    private var profile: UserProfile { coordinator.userProfile }
    private var sortedIdentities: [(dimension: WellnessDimension, identity: Identity)] {
        profile.identities
            .sorted { $0.value.evidenceCount > $1.value.evidenceCount }
            .map { (dimension: $0.key, identity: $0.value) }
    }
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                theme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 40) {
                        header
                            .padding(.horizontal, 32)
                            .padding(.top, 60)
                        
                        if let dominant = coordinator.dominantIdentity {
                            DominantIdentityCard(dimension: dominant.dimension, identity: dominant.identity)
                                .padding(.horizontal, 24)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.35),
                                    value: showContent
                                )
                        }
                        
                        identityRadar
                            .padding(.horizontal, 24)
                        
                        evidenceList
                            .padding(.horizontal, 24)
                        
                        actionButtons
                            .padding(.horizontal, 32)
                            .padding(.bottom, 50)
                    }
                }
            }
        }
        .onAppear {
            showContent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCircle = true
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 12) {
            Text("Tu identidad en evolución")
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.center)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)
                .animation(
                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.2),
                    value: showContent
                )
            
            HStack(spacing: 16) {
                MetricPill(title: "Evidencias", value: "\(profile.totalEvidences)")
                MetricPill(title: "Días activos", value: "\(profile.activeDaysCount)")
            }
            .opacity(showContent ? 1 : 0)
            .animation(
                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.3),
                value: showContent
            )
        }
    }
    
    private var identityRadar: some View {
        VStack(spacing: 24) {
            IdentityCircle(
                identities: profile.identities,
                selectedDimension: selectedDimension
            )
            .opacity(showCircle ? 1 : 0)
            .scaleEffect(showCircle ? 1 : 0.8)
            .animation(
                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.8).delay(0.4),
                value: showCircle
            )
            
            Text(selectedDimension != nil ? "Identidad seleccionada" : "Toca una identidad para ver detalles")
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onBackground.opacity(0.5))
                .opacity(showContent ? 1 : 0)
                .animation(
                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.0),
                    value: showContent
                )
        }
    }
    
    private var evidenceList: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Evidencias por identidad")
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
                .opacity(showContent ? 1 : 0)
                .animation(
                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.8),
                    value: showContent
                )
            
            LazyVStack(spacing: 12) {
                ForEach(Array(sortedIdentities.enumerated()), id: \.offset) { index, entry in
                    IdentityEvidenceCard(
                        dimension: entry.dimension,
                        identity: entry.identity,
                        isSelected: selectedDimension == entry.dimension
                    ) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            selectedDimension = selectedDimension == entry.dimension ? nil : entry.dimension
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(
                        .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                        .delay(1.0 + Double(index) * 0.08),
                        value: showContent
                    )
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            AnimatedButton(
                title: "Registrar evidencia hoy",
                action: {
                    coordinator.navigateToDailyCheckIn()
                },
                style: .primary
            )
            
            AnimatedButton(
                title: "Ver micro-evidencia anterior",
                action: {
                    coordinator.resetForNextDay()
                },
                style: .ghost
            )
        }
    }
}

// MARK: - Subviews

private struct MetricPill: View {
    let title: String
    let value: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(theme.typography.title3)
                .foregroundColor(theme.colors.onBackground)
            Text(title)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onBackground.opacity(0.6))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            Capsule()
                .fill(theme.colors.surface)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
        )
    }
}

private struct DominantIdentityCard: View {
    let dimension: WellnessDimension
    let identity: Identity
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Identidad dominante")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                Spacer()
                Text(identity.level.displayName)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
            }
            
            HStack(spacing: 16) {
                Image(systemName: dimension.iconName)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(dimension.primaryColor)
                    .frame(width: 64, height: 64)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(dimension.primaryColor.opacity(0.12))
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(dimension.identityStatement)
                        .font(theme.typography.title2)
                        .foregroundColor(theme.colors.onBackground)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 12) {
                        InfoChip(title: "Evidencias", value: "\(identity.evidenceCount)", color: dimension.primaryColor)
                        InfoChip(title: "Racha", value: "\(identity.currentStreak) días", color: dimension.primaryColor)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(theme.colors.surface)
                .shadow(color: dimension.primaryColor.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
}

private struct InfoChip: View {
    let title: String
    let value: String
    let color: Color
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(theme.typography.caption)
                .foregroundColor(color)
            Text(title)
                .font(theme.typography.overline)
                .foregroundColor(theme.colors.onBackground.opacity(0.5))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .background(
            Capsule()
                .fill(color.opacity(0.12))
        )
    }
}

private struct IdentityEvidenceCard: View {
    let dimension: WellnessDimension
    let identity: Identity
    let isSelected: Bool
    let onTap: () -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: dimension.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(dimension.primaryColor)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(dimension.primaryColor.opacity(0.12))
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(dimension.identityStatement)
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 16) {
                        Label("\(identity.evidenceCount) evidencias", systemImage: "sparkles")
                            .font(theme.typography.caption)
                            .foregroundColor(dimension.primaryColor)
                        
                        Label("Racha: \(identity.currentStreak)", systemImage: "flame.fill")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    }
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "chevron.down" : "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.colors.onBackground.opacity(0.4))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? dimension.primaryColor.opacity(0.4) : Color.clear, lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
