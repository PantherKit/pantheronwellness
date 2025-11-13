import SwiftUI

struct ProgressView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var selectedDimension: WellnessDimension?
    @State private var showContent = false
    @State private var showCircle = false
    @Environment(\.appTheme) var theme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                theme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 40) {
                        // Header
                        VStack(spacing: 16) {
                            Text("Tu Identidad en Evolución")
                                .font(theme.typography.headline)
                                .foregroundColor(theme.colors.onBackground)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : -20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.2), 
                                    value: showContent
                                )
                            
                            if coordinator.totalCompletions > 0 {
                                Text("\(coordinator.totalCompletions) acciones completadas")
                                    .font(theme.typography.body2)
                                    .foregroundColor(theme.colors.onBackground.opacity(0.7))
                                    .opacity(showContent ? 1 : 0)
                                    .animation(
                                        .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.3), 
                                        value: showContent
                                    )
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 60)
                        
                        // Identity Circle
                        VStack(spacing: 24) {
                            IdentityCircle(
                                progress: coordinator.identityProgress,
                                selectedDimension: selectedDimension
                            )
                            .opacity(showCircle ? 1 : 0)
                            .scaleEffect(showCircle ? 1 : 0.8)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.8).delay(0.4), 
                                value: showCircle
                            )
                            
                            Text("Toca una dimensión para ver detalles")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.onBackground.opacity(0.5))
                                .opacity(showContent ? 1 : 0)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.0), 
                                    value: showContent
                                )
                        }
                        
                        // Evidence Cards
                        VStack(spacing: 16) {
                            Text("Evidencias Recientes")
                                .font(theme.typography.title2)
                                .foregroundColor(theme.colors.onBackground)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 32)
                                .opacity(showContent ? 1 : 0)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.8), 
                                    value: showContent
                                )
                            
                            LazyVStack(spacing: 12) {
                                ForEach(Array(coordinator.identityProgress.keys.enumerated()), id: \.element) { index, dimension in
                                    if let progress = coordinator.identityProgress[dimension], progress.totalCompletions > 0 {
                                        EvidenceCard(
                                            dimension: dimension,
                                            progress: progress,
                                            onTap: {
                                                selectedDimension = selectedDimension == dimension ? nil : dimension
                                            }
                                        )
                                        .opacity(showContent ? 1 : 0)
                                        .offset(y: showContent ? 0 : 20)
                                        .animation(
                                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                                            .delay(1.0 + Double(index) * 0.1), 
                                            value: showContent
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            AnimatedButton(
                                title: "Elegir identidad de mañana",
                                action: {
                                    coordinator.navigateBackToSelection()
                                },
                                style: .primary
                            )
                            
                            if !coordinator.hasCompletedToday {
                                AnimatedButton(
                                    title: "Completar acción de hoy",
                                    action: {
                                        coordinator.navigateBackToSelection()
                                    },
                                    style: .secondary
                                )
                            }
                        }
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
}

struct EvidenceCard: View {
    let dimension: WellnessDimension
    let progress: IdentityProgress
    let onTap: () -> Void
    
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: dimension.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(dimension.primaryColor)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(dimension.primaryColor.opacity(0.1))
                    )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(evidenceText)
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 16) {
                        Text("\(progress.currentStreak) días seguidos")
                            .font(theme.typography.caption)
                            .foregroundColor(dimension.primaryColor)
                        
                        Text("\(progress.totalCompletions) veces total")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.colors.onBackground.opacity(0.4))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.colors.surface)
                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var evidenceText: String {
        let times = progress.totalCompletions
        let dimensionName = dimension.displayName.lowercased()
        
        if times == 1 {
            return "Actuaste como alguien \(dimensionName) 1 vez"
        } else {
            return "Actuaste como alguien \(dimensionName) \(times) veces"
        }
    }
}
