import SwiftUI
import Lottie

struct WelcomeScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var animationLoaded = false
    @State private var glowIntensity: Double = 0.6
    @State private var lottiePlaybackMode: LottiePlaybackMode = .playing(.toProgress(1, loopMode: .loop))
    @Environment(\.appTheme) var theme
    
    var body: some View {
        ZStack {
            // Premium Organic Background
            premiumBackground
            
            // Animated glow effect
            animatedGlow
            
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top Spacer - ajustado para mejor balance
                    Spacer(minLength: geometry.size.height * 0.08)
                    
                    // Hero Animation Section
                    heroAnimationSection
                    
                    // Content Section con headline potente
                    contentSection
                    
                    // Value Props
                    valuePropsSection
                    
                    // Flexible spacer - reducido para menos vacío
                    Spacer(minLength: geometry.size.height * 0.08)
                    
                    // Premium CTA Section con microinteracciones
                    ctaSection
                    
                    // Bottom safe spacing
                    Spacer(minLength: 50)
                }
            }
        }
        .onAppear {
            // Debug fonts
            #if DEBUG
            AppTypography.debugFontStatus()
            #endif
            
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
            
            // Breathing glow effect
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                glowIntensity = 1.0
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
    
    // MARK: - Animated Glow
    private var animatedGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        theme.colors.primary.opacity(0.15 * glowIntensity),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 250
                )
            )
            .frame(width: 500, height: 500)
            .blur(radius: 50)
            .offset(y: -200)
    }
    
    // MARK: - Hero Animation Section
    private var heroAnimationSection: some View {
        VStack(spacing: 0) {
            LottieView(animation: .named("stress"))
                .playbackMode(lottiePlaybackMode)
                .animationSpeed(0.7)
                .contentMode(.scaleAspectFit)
                .frame(width: showContent ? 240 : 180, height: showContent ? 240 : 180)
                .scaleEffect(showContent ? 1.0 : 0.85)
                .opacity(showContent ? 1.0 : 0)
                .animation(
                    .spring(response: 1.2, dampingFraction: 0.75, blendDuration: 0.3)
                    .delay(0.2),
                    value: showContent
                )
                .onAppear {
                    // Start animation después de un pequeño delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        lottiePlaybackMode = .playing(.toProgress(1, loopMode: .loop))
                        animationLoaded = true
                    }
                }
        }
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 16) {
            // App Name con Manrope Light
            Text("Wellty")
                .font(.manrope(72, weight: .light))
                .tracking(1.2)
                .foregroundColor(theme.colors.welcomeTextPrimary)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 25)
                .animation(
                    .spring(response: 0.9, dampingFraction: 0.75).delay(0.3),
                    value: showContent
                )
            
            // Headline potente y emocional
            Text("Instala la versión de ti\nque siempre quisiste ser")
                .font(.manrope(24, weight: .medium))
                .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .tracking(0.3)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.8).delay(0.5),
                    value: showContent
                )
            
            // Subheadline descriptivo
            Text("Micro-acciones de 2 minutos\nque cambian quién eres")
                .font(.manrope(16, weight: .regular))
                .foregroundColor(theme.colors.welcomeTextMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .tracking(0.2)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 15)
                .animation(
                    .easeOut(duration: 0.8).delay(0.7),
                    value: showContent
                )
        }
        .padding(.horizontal, 40)
        .padding(.top, 32)
    }
    
    // MARK: - Value Props Section
    private var valuePropsSection: some View {
        VStack(spacing: 14) {
            ValuePropRow(
                icon: "clock.fill",
                text: "Solo 2 minutos al día",
                delay: 0.9
            )
            .opacity(showContent ? 1 : 0)
            .offset(x: showContent ? 0 : -20)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.9), value: showContent)
            
            ValuePropRow(
                icon: "chart.line.uptrend.xyaxis",
                text: "Sin métricas abrumadoras",
                delay: 1.0
            )
            .opacity(showContent ? 1 : 0)
            .offset(x: showContent ? 0 : -20)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.0), value: showContent)
            
            ValuePropRow(
                icon: "sparkles",
                text: "Cambia quién eres, no solo qué haces",
                delay: 1.1
            )
            .opacity(showContent ? 1 : 0)
            .offset(x: showContent ? 0 : -20)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(1.1), value: showContent)
        }
        .padding(.horizontal, 48)
        .padding(.top, 24)
    }
    
    // MARK: - Premium CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            // Premium CTA Button con glow effect
            AnimatedButton(
                title: "Comenzar mi viaje",
                action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    coordinator.navigateToOnboarding()
                },
                style: .welcomePrimary
            )
            .scaleEffect(showContent ? 1.0 : 0.92)
            .opacity(showContent ? 1 : 0)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.75)
                .delay(1.3),
                value: showContent
            )
            .shadow(
                color: theme.colors.primary.opacity(0.3 * glowIntensity),
                radius: 20,
                y: 8
            )
            
            // Subtle credibility text
            Text("Basado en las 7 dimensiones del wellness")
                .font(.manrope(12, weight: .regular))
                .foregroundColor(theme.colors.welcomeTextMuted.opacity(0.7))
                .opacity(showContent ? 1 : 0)
                .animation(
                    .easeOut(duration: 0.6).delay(1.5),
                    value: showContent
                )
        }
        .padding(.horizontal, 32)
    }
}

// MARK: - Value Prop Row Component
struct ValuePropRow: View {
    let icon: String
    let text: String
    let delay: Double
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(theme.colors.primary)
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.manrope(15, weight: .regular))
                .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.8))
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(AppCoordinator())
}
