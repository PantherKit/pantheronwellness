import SwiftUI

struct DailyCheckInView: View {
    @ObservedObject var coordinator: AppCoordinator
    @Namespace private var animationNamespace
    @State private var selectedDimension: WellnessDimension?
    @State private var showContent = false
    @State private var showGrid = false
    @Environment(\.appTheme) var theme
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                theme.colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                        .padding(.horizontal, 32)
                        .padding(.top, 60)
                    
                    sleepQualitySelector
                        .padding(.top, 32)
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.4),
                            value: showContent
                        )
                    
                    Spacer(minLength: 24)
                    
                    identityGrid
                        .padding(.horizontal, 24)
                    
                    Spacer(minLength: 24)
                    
                    footer
                        .padding(.horizontal, 32)
                        .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            selectedDimension = coordinator.selectedDimension
            showContent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showGrid = true
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 16) {
            Text("¿Quién quieres ser hoy?")
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.center)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)
                .animation(
                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.2),
                    value: showContent
                )
            
            Text("Cada acción es una evidencia que instala tu identidad.")
                .font(theme.typography.body2)
                .foregroundColor(theme.colors.onBackground.opacity(0.7))
                .multilineTextAlignment(.center)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)
                .animation(
                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.3),
                    value: showContent
                )
        }
    }
    
    private var sleepQualitySelector: some View {
        VStack(spacing: 12) {
            HStack {
                Text("¿Cómo dormiste?")
                    .font(theme.typography.body1)
                    .foregroundColor(theme.colors.onBackground)
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(SleepQuality.allCases, id: \.self) { quality in
                    Button {
                        coordinator.setSleepQuality(quality)
                    } label: {
                        VStack(spacing: 6) {
                            Text(quality.emoji)
                                .font(.system(size: 28))
                            Text(quality.displayName)
                                .font(theme.typography.caption)
                                .foregroundColor(textColor(for: quality))
                        }
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(backgroundColor(for: quality))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(borderColor(for: quality), lineWidth: 1.5)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(coordinator.selectedSleepQuality == quality ? 1.02 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: coordinator.selectedSleepQuality)
                }
            }
        }
    }
    
    private var identityGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Array(WellnessDimension.allCases.enumerated()), id: \.element) { index, dimension in
                IdentityCard(
                    dimension: dimension,
                    identity: coordinator.userProfile.identities[dimension],
                    isSelected: selectedDimension == dimension,
                    namespace: animationNamespace,
                    onTap: {
                        selectedDimension = dimension
                    }
                )
                .opacity(showGrid ? 1 : 0)
                .offset(y: showGrid ? 0 : 30)
                .animation(
                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                    .delay(0.5 + Double(index) * 0.1),
                    value: showGrid
                )
            }
        }
    }
    
    private var footer: some View {
        VStack(spacing: 16) {
            AnimatedButton(
                title: "Elegir micro-evidencia",
                action: {
                    if let dimension = selectedDimension {
                        coordinator.navigateToDailyAction(dimension: dimension)
                    }
                },
                style: .primary
            )
            .disabled(selectedDimension == nil)
            .opacity(selectedDimension != nil ? 1 : 0.5)
            .animation(.easeInOut(duration: 0.3), value: selectedDimension)
            
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(theme.colors.secondary)
                
                Text("Has acumulado \(coordinator.totalEvidences) evidencias de tu identidad")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
            }
            .opacity(showContent ? 1 : 0)
            .animation(
                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.0),
                value: showContent
            )
        }
    }
    
    private func textColor(for quality: SleepQuality) -> Color {
        coordinator.selectedSleepQuality == quality ? theme.colors.onPrimary : theme.colors.onBackground.opacity(0.7)
    }
    
    private func backgroundColor(for quality: SleepQuality) -> Color {
        coordinator.selectedSleepQuality == quality ? theme.colors.primary : theme.colors.surface
    }
    
    private func borderColor(for quality: SleepQuality) -> Color {
        coordinator.selectedSleepQuality == quality ? theme.colors.primary : theme.colors.outline.opacity(0.4)
    }
}
