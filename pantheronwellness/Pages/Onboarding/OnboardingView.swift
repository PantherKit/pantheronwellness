import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: AppCoordinator
    @Namespace private var animationNamespace
    @State private var showContent = false
    @State private var showGrid = false
    @Environment(\.appTheme) var theme
    
    private var dimensions: [WellnessDimension] {
        WellnessDimension.allCases
    }
    
    private var buttonTitle: String {
        let count = coordinator.selectedFocusDimensions.count
        if count == 0 {
            return "Selecciona al menos 2"
        } else if count < coordinator.minFocusDimensions {
            return "Selecciona \(coordinator.minFocusDimensions - count) más"
        } else {
            return "Continuar (\(count)/\(coordinator.maxFocusDimensions))"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                theme.colors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        VStack(spacing: 20) {
                            // Hero Icon Animation
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: 0xB6E2D3).opacity(0.3),
                                                Color(hex: 0x1A5A53).opacity(0.1)
                                            ]),
                                            center: .center,
                                            startRadius: 30,
                                            endRadius: 100
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .scaleEffect(showContent ? 1 : 0.5)
                                    .animation(.spring(response: 1.0, dampingFraction: 0.6), value: showContent)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(Color(hex: 0x1A5A53))
                                    .scaleEffect(showContent ? 1 : 0.1)
                                    .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.3), value: showContent)
                            }
                            .padding(.top, 60)
                            
                            // Title and subtitle
                            VStack(spacing: 16) {
                                Text("¿Qué áreas de tu bienestar quieres mejorar?")
                                    .font(theme.typography.headline)
                                    .foregroundColor(theme.colors.onBackground)
                                    .multilineTextAlignment(.center)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 20)
                                    .animation(
                                        .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.4), 
                                        value: showContent
                                    )
                                
                                Text("Selecciona 2 o 3 dimensiones.\nDiseñaremos tu journey personalizado.")
                                    .font(theme.typography.body2)
                                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .opacity(showContent ? 1 : 0)
                                    .offset(y: showContent ? 0 : 20)
                                    .animation(
                                        .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.6), 
                                        value: showContent
                                    )
                            }
                            .padding(.horizontal, 32)
                        }
                        .padding(.bottom, 40)
                        
                        // Identity Grid (2x4 layout - más natural)
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(Array(dimensions.enumerated()), id: \.element) { index, dimension in
                                IdentityCard(
                                    dimension: dimension,
                                    identity: nil,
                                    isSelected: coordinator.selectedFocusDimensions.contains(dimension),
                                    namespace: animationNamespace,
                                    onTap: {
                                        coordinator.toggleFocusDimension(dimension)
                                    },
                                    style: .compact
                                )
                                .opacity(showGrid ? 1 : 0)
                                .offset(y: showGrid ? 0 : 30)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                                    .delay(0.8 + Double(index) * 0.08), 
                                    value: showGrid
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                        
                        // Continue Button
                        VStack(spacing: 12) {
                            AnimatedButton(
                                title: buttonTitle,
                                action: {
                                    coordinator.completeFocusSelection()
                                },
                                style: .primary
                            )
                            .disabled(!coordinator.hasMinimumDimensionsSelected())
                            .opacity(coordinator.hasMinimumDimensionsSelected() ? 1 : 0.5)
                            .animation(.easeInOut(duration: 0.3), value: coordinator.selectedFocusDimensions.count)
                            
                            // Subtle hint text
                            Text("Puedes cambiar esto después")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.onBackground.opacity(0.5))
                                .opacity(showContent ? 1 : 0)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.5), 
                                    value: showContent
                                )
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 50)
                    }
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
