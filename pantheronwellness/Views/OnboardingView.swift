import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var animateButton = false
    @Environment(\.appTheme) var theme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                theme.colors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Rive Animation
                    VStack(spacing: 32) {
                        RiveViewModel(fileName: "meditation")
                            .view()
                            .frame(width: 200, height: 200)
                            .opacity(showContent ? 1 : 0)
                            .scaleEffect(showContent ? 1 : 0.8)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.8).delay(0.2), 
                                value: showContent
                            )
                        
                        // Title and subtitle
                        VStack(spacing: 16) {
                            Text("Instala tu nueva identidad")
                                .font(theme.typography.display)
                                .foregroundColor(theme.colors.onBackground)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.4), 
                                    value: showContent
                                )
                            
                            Text("Elige quién quieres ser hoy.\nTe guiaremos con una acción de 2 minutos.")
                                .font(theme.typography.body1)
                                .foregroundColor(theme.colors.onBackground.opacity(0.8))
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
                    
                    Spacer()
                    
                    // CTA Button
                    VStack(spacing: 16) {
                        AnimatedButton(
                            title: "Comenzar",
                            action: {
                                coordinator.navigateToIdentitySelection()
                            },
                            style: .primary
                        )
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.8), 
                            value: showContent
                        )
                        
                        // Subtle hint text
                        Text("Wellness 2.0 • Construye tu identidad")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onBackground.opacity(0.5))
                            .opacity(showContent ? 1 : 0)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.0), 
                                value: showContent
                            )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            showContent = true
        }
    }
}
