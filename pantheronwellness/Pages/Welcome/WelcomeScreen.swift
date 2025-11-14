import SwiftUI
import Lottie

struct WelcomeScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var animationLoaded = false
    @State private var isButtonPressed = false
    @Environment(\.appTheme) var theme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Capa Superior: Solo Lottie Animation
                VStack {
                    Spacer()
                    
                    heroAnimationSection
                        .frame(height: geometry.size.height * 0.55)
                    
                    Spacer()
                }
                
                // Capa Inferior: Panel Blanco con Onda
                VStack {
                    Spacer()
                    
                    whiteContentPanel(geometry: geometry)
                        .frame(height: geometry.size.height * 0.5)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Debug fonts
            #if DEBUG
            AppTypography.debugFontStatus()
            #endif
            
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Hero Animation Section (Solo Lottie)
    private var heroAnimationSection: some View {
        VStack(spacing: 0) {
            LottieView(animation: .named("stress"))
                .playing(loopMode: .loop)
                .animationSpeed(0.7)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(showContent ? 1.4 : 1.0) // 40% más grande
                .opacity(showContent ? 1.0 : 0)
                .animation(
                    .spring(response: 1.2, dampingFraction: 0.75),
                    value: showContent
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animationLoaded = true
                    }
                }
        }
    }
    
    // MARK: - White Content Panel con Onda
    private func whiteContentPanel(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            // Panel blanco con forma de onda
            WaveShape()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
            
            // Contenido dentro del panel
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                // Content Section
                contentSection
                
                Spacer(minLength: 32)
                
                // CTA Section con geometry para calcular width
                ctaSection(geometry: geometry)
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 20) {
            // App Name con Manrope Bold
            Text("Wellty")
                .font(.manrope(72, weight: .bold))
                .tracking(1.2)
                .foregroundColor(theme.colors.welcomeTextPrimary)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 25)
                .animation(
                    .spring(response: 0.9, dampingFraction: 0.75).delay(0.3),
                    value: showContent
                )
            
            // Headline potente y emocional con Semibold
            Text("Instala la versión de ti\nque siempre quisiste ser")
                .font(.manrope(24, weight: .semibold))
                .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .tracking(0.3)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.8).delay(0.5),
                    value: showContent
                )
        }
    }
    
    
    // MARK: - Premium CTA Section
    private func ctaSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            // Premium CTA Button - 1/3 del width, centrado
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                coordinator.navigateToOnboarding()
            }) {
                Text("Comenzar mi viaje")
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(theme.colors.welcomeTextPrimary)
                            .shadow(
                                color: theme.colors.welcomeTextPrimary.opacity(isButtonPressed ? 0.2 : 0.3),
                                radius: isButtonPressed ? 8 : 16,
                                y: isButtonPressed ? 2 : 6
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: geometry.size.width * 0.65) // Más ancho (65% del width)
            .scaleEffect(isButtonPressed ? 0.97 : (showContent ? 1.0 : 0.92))
            .opacity(showContent ? 1 : 0)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.75)
                .delay(1.3),
                value: showContent
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isButtonPressed = true
                    }
                    .onEnded { _ in
                        isButtonPressed = false
                    }
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
    }
}

// MARK: - Wave Shape (Onda de Mar Suave)
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let waveHeight: CGFloat = 35
        let waveFrequency: CGFloat = 2.5 // Número de ondas completas (más suave)
        
        // Inicio desde la esquina superior izquierda
        let startY = waveHeight * 0.6 + sin(0) * waveHeight * 0.4
        path.move(to: CGPoint(x: 0, y: startY))
        
        // Crear ondas suaves usando curvas Bézier
        let segments = 60 // Más segmentos = más suave
        let stepX = rect.width / CGFloat(segments)
        
        for i in 1...segments {
            let x = CGFloat(i) * stepX
            let normalizedX = x / rect.width
            
            // Función seno para crear ondas suaves como el mar
            let sineWave = sin(normalizedX * waveFrequency * .pi * 2)
            let y = waveHeight * 0.6 + sineWave * waveHeight * 0.4
            
            let prevX = CGFloat(i - 1) * stepX
            let prevNormalizedX = prevX / rect.width
            let prevSineWave = sin(prevNormalizedX * waveFrequency * .pi * 2)
            let prevY = waveHeight * 0.6 + prevSineWave * waveHeight * 0.4
            
            // Calcular punto de control para curva suave
            let controlX = (prevX + x) / 2
            let controlNormalizedX = controlX / rect.width
            let controlSineWave = sin(controlNormalizedX * waveFrequency * .pi * 2)
            let controlY = waveHeight * 0.6 + controlSineWave * waveHeight * 0.4
            
            // Ajustar punto de control para suavidad adicional
            let adjustedControlY = (prevY + y) / 2 + (controlY - (prevY + y) / 2) * 0.3
            
            path.addQuadCurve(
                to: CGPoint(x: x, y: y),
                control: CGPoint(x: controlX, y: adjustedControlY)
            )
        }
        
        // Cerrar el path: esquina inferior derecha -> inferior izquierda -> inicio
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
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
