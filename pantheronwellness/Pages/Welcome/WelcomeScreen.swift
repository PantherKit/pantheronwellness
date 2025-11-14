import SwiftUI
import RiveRuntime

struct WelcomeScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var animationLoaded = false
    @Environment(\.appTheme) var theme
    
    var body: some View {
        ZStack {
            // Premium Organic Background
            premiumBackground
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top Spacer - responsive
                    Spacer(minLength: geometry.size.height * 0.1)
                    
                    // Hero Animation Section
                    heroAnimationSection
                    
                    // Content Section with generous spacing
                    contentSection
                    
                    // Flexible spacer
                    Spacer(minLength: geometry.size.height * 0.15)
                    
                    // Premium CTA Section
                    ctaSection
                    
                    // Bottom safe spacing
                    Spacer(minLength: 60)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.1)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Premium Background
    private var premiumBackground: some View {
        Image("backgroundOnboarding")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
    
    // MARK: - Hero Animation Section
    private var heroAnimationSection: some View {
        VStack(spacing: 0) {
            RiveViewModel(fileName: "meditation")
                .view()
                .frame(width: showContent ? 200 : 160, height: showContent ? 200 : 160)
                .scaleEffect(showContent ? 1.0 : 0.85)
                .opacity(showContent ? 1.0 : 0)
                .animation(
                    .spring(response: 1.2, dampingFraction: 0.75, blendDuration: 0.3)
                    .delay(0.2),
                    value: showContent
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animationLoaded = true
                    }
                }
        }
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 28) {
            // Primary Message
            VStack(spacing: 12) {
                Text("Wellty")
                    .font(.manrope(80, weight: .light))
                    .tracking(0.4)
                    .foregroundColor(theme.colors.welcomeTextPrimary)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 25)
                    .animation(
                        .easeOut(duration: 0.8).delay(0.5),
                        value: showContent
                    )
            }
            .multilineTextAlignment(.center)
            
            // Descriptive text with generous spacing
            Text("Micro-acciones de bienestar diseñadas\nespecialmente para ti")
                .font(theme.typography.body1)
                .foregroundColor(theme.colors.welcomeTextMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .tracking(0.2)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.8).delay(0.9),
                    value: showContent
                )
        }
        .padding(.horizontal, 40)
        .padding(.top, 40)
    }
    
    // MARK: - Premium CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            // Premium CTA Button
            AnimatedButton(
                title: "Comenzar mi viaje",
                action: {
                    coordinator.navigateToOnboarding()
                },
                style: .welcomePrimary
            )
            .scaleEffect(showContent ? 1.0 : 0.92)
            .opacity(showContent ? 1 : 0)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.8)
                .delay(1.1),
                value: showContent
            )
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(AppCoordinator())
}
