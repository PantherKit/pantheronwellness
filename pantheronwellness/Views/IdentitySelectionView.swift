import SwiftUI

struct IdentitySelectionView: View {
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
                // Background
                theme.colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
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
                        
                        Text("Selecciona una identidad. Cambia cada día si lo deseas.")
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
                    .padding(.horizontal, 32)
                    .padding(.top, 60)
                    
                    Spacer(minLength: 40)
                    
                    // Identity Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(WellnessDimension.allCases.enumerated()), id: \.element) { index, dimension in
                            IdentityCard(
                                dimension: dimension,
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
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Continue Button
                    VStack(spacing: 16) {
                        AnimatedButton(
                            title: "Continuar",
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
                        
                        // Progress indicator
                        if coordinator.totalCompletions > 0 {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .font(.caption)
                                    .foregroundColor(theme.colors.secondary)
                                
                                Text("\(coordinator.totalCompletions) acciones completadas")
                                    .font(theme.typography.caption)
                                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                            }
                            .opacity(showContent ? 1 : 0)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.2), 
                                value: showContent
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            showContent = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showGrid = true
            }
        }
    }
}
