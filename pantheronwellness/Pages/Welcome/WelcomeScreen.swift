import SwiftUI
import Lottie

struct WelcomeScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var animationLoaded = false
    @State private var isButtonPressed = false
    @State private var wavePhase: Double = 0
    @State private var isTransitioning = false
    @State private var showOnboardingContent = false
    @State private var showExplanation = false
    @State private var showDimensionGrid = false
    @State private var isLottieActive = true
    @Namespace private var animationNamespace
    @Environment(\.appTheme) var theme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Capa Superior: Solo Lottie Animation
                VStack {
                    Spacer()
                    
                    heroAnimationSection(geometry: geometry)
                        .frame(height: geometry.size.height * 0.55)
                    
                    Spacer()
                }
                
                // Capa Inferior: Panel Blanco con Onda
                VStack {
                    Spacer()
                    
                    whiteContentPanel(geometry: geometry)
                        .frame(height: geometry.size.height * (showDimensionGrid ? 0.95 : (isTransitioning ? 0.9 : 0.5)))
                        .animation(
                            .spring(response: 1.2, dampingFraction: 0.75),
                            value: isTransitioning
                        )
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
            
            // Iniciar animación continua de olas (más lenta y relajante)
            startWaveAnimation()
        }
    
    }
    
    // MARK: - Hero Animation Section (Lottie + Background)
    private func heroAnimationSection(geometry: GeometryProxy) -> some View {
        ZStack {
            // Background Image
            Image("backgroundOnboarding")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .opacity(showContent ? 1.0 : 0)
                .animation(
                    .easeOut(duration: 1.0),
                    value: showContent
                )
            
            // LottieView encima del background
            LottieView(animation: .named("stress"))
                .playing(loopMode: isLottieActive ? .loop : .playOnce)
                .animationSpeed(0.7)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(showContent ? 1.4 : 1.0) // 40% más grande
                .offset(y: -geometry.size.height * 0.12) // 12% más arriba
                .opacity(showContent ? (isLottieActive ? 1.0 : 0.3) : 0)
                .animation(
                    .spring(response: 1.2, dampingFraction: 0.75),
                    value: showContent
                )
                .animation(
                    .easeOut(duration: 0.5),
                    value: isLottieActive
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
            // Panel blanco con forma de onda animada
            AnimatedWaveShape(
                phase: wavePhase,
                isTransitioning: isTransitioning,
                showingGrid: showDimensionGrid
            )
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
            
            // Contenido dentro del panel
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                if !showOnboardingContent {
                    // Welcome Content Section
                    contentSection
                    
                    Spacer(minLength: 20)
                    
                    // CTA Section con geometry para calcular width
                    ctaSection(geometry: geometry)
                } else if !showExplanation {
                    // Explanation Step
                    explanationSection(geometry: geometry)
                } else {
                    // Onboarding Dimension Selection Integrated
                    dimensionSelectionSection(geometry: geometry)
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 32)
        }
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 12) {
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
                .font(.manrope(24, weight: .regular))
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
                startTransition()
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
    
    // MARK: - Transition Functions
    private func startTransition() {
        withAnimation(.spring(response: 1.2, dampingFraction: 0.75)) {
            isTransitioning = true
        }
        
        // Cambiar velocidad de olas y desactivar Lottie después de la expansión
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLottieActive = false
            // Reiniciar animación de olas con velocidad más lenta
            startWaveAnimation()
            
            // Expandir aún más para el grid
            withAnimation(.spring(response: 1.0, dampingFraction: 0.75)) {
                showDimensionGrid = true
            }
        }
        
        // Fade out más rápido del texto inicial (20% más rápido)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.8)) {
                showOnboardingContent = true
            }
        }
    }
    
    // MARK: - Explanation Section
    private func explanationSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 32) {
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
                            endRadius: 60
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(Color(hex: 0x1A5A53))
            }
            .scaleEffect(showOnboardingContent ? 1 : 0.5)
            .animation(
                .spring(response: 1.0, dampingFraction: 0.6),
                value: showOnboardingContent
            )
            
            // Explanation Content
            VStack(spacing: 20) {
                Text("Personaliza tu experiencia")
                    .font(.manrope(32, weight: .bold))
                    .foregroundColor(theme.colors.welcomeTextPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(showOnboardingContent ? 1 : 0)
                    .offset(y: showOnboardingContent ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.8).delay(0.2),
                        value: showOnboardingContent
                    )
                
                VStack(spacing: 16) {
                    Text("Vamos a identificar las áreas de tu bienestar que más te importan en este momento.")
                        .font(.manrope(18, weight: .regular))
                        .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    Text("Esto nos ayudará a diseñar un journey completamente personalizado para ti, con acciones y recomendaciones adaptadas a tus necesidades.")
                        .font(.manrope(16, weight: .regular))
                        .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                }
                .opacity(showOnboardingContent ? 1 : 0)
                .offset(y: showOnboardingContent ? 0 : 15)
                .animation(
                    .easeOut(duration: 0.8).delay(0.4),
                    value: showOnboardingContent
                )
            }
            
            Spacer(minLength: 20)
            
            // Continue Button
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                startDimensionSelection()
            }) {
                Text("Comenzar selección")
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(theme.colors.welcomeTextPrimary)
                            .shadow(
                                color: theme.colors.welcomeTextPrimary.opacity(0.3),
                                radius: 16,
                                y: 6
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: geometry.size.width * 0.65)
            .opacity(showOnboardingContent ? 1 : 0)
            .scaleEffect(showOnboardingContent ? 1.0 : 0.9)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.75).delay(0.8),
                value: showOnboardingContent
            )
        }
    }
    
    private func startDimensionSelection() {
        // Expandir panel a 95% y mostrar grid
        withAnimation(.spring(response: 1.0, dampingFraction: 0.75)) {
            showExplanation = true
            showDimensionGrid = true
        }
    }
    
    // MARK: - Wave Animation Control
    private func startWaveAnimation() {
        let duration = isTransitioning ? 8.4 : 6.0 // 40% más lenta durante transición
        withAnimation(
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
        ) {
            wavePhase = .pi * 2 // Un ciclo completo
        }
    }
    
    // MARK: - Dimension Selection Section (Onboarding Integrated)
    private func dimensionSelectionSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Fixed Header Section
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
                                endRadius: 60
                            )
                        )
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(Color(hex: 0x1A5A53))
                }
                .scaleEffect(showDimensionGrid ? 1 : 0.5)
                .animation(
                    .spring(response: 1.0, dampingFraction: 0.6),
                    value: showDimensionGrid
                )
                
                // Title and subtitle
                VStack(spacing: 12) {
                    Text("¿Qué áreas de tu bienestar\nquieres mejorar?")
                        .font(.manrope(28, weight: .bold))
                        .foregroundColor(theme.colors.welcomeTextPrimary)
                        .multilineTextAlignment(.center)
                        .opacity(showDimensionGrid ? 1 : 0)
                        .offset(y: showDimensionGrid ? 0 : 20)
                        .animation(
                            .easeOut(duration: 0.8).delay(0.2),
                            value: showDimensionGrid
                        )
                    
                    Text("Selecciona 2 o 3 dimensiones.\nDiseñaremos tu journey personalizado.")
                        .font(.manrope(16, weight: .regular))
                        .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .opacity(showDimensionGrid ? 1 : 0)
                        .offset(y: showDimensionGrid ? 0 : 15)
                        .animation(
                            .easeOut(duration: 0.8).delay(0.4),
                            value: showDimensionGrid
                        )
                }
            }
            .padding(.bottom, 20)
            
            // Scrollable Grid Section
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // Dimension Grid (2x4 layout)
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(Array(WellnessDimension.allCases.enumerated()), id: \.element) { index, dimension in
                            IdentityCard(
                                dimension: dimension,
                                identity: nil,
                                isSelected: coordinator.selectedFocusDimensions.contains(dimension),
                                namespace: animationNamespace,
                                onTap: {
                                    coordinator.toggleFocusDimension(dimension)
                                },
                                style: .compact,
                                overrideColor: theme.colors.welcomeTextPrimary
                            )
                            .opacity(showDimensionGrid ? 1 : 0)
                            .offset(y: showDimensionGrid ? 0 : 30)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                                .delay(0.6 + Double(index) * 0.08),
                                value: showDimensionGrid
                            )
                        }
                    }
                    .padding(.horizontal, 8)
                    
                    // Continue Button
                    VStack(spacing: 12) {
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            coordinator.completeFocusSelection()
                        }) {
                            Text(buttonTitle)
                                .font(.manrope(16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .fill(coordinator.hasMinimumDimensionsSelected() ? theme.colors.welcomeTextPrimary : theme.colors.welcomeTextPrimary.opacity(0.5))
                                        .shadow(
                                            color: theme.colors.welcomeTextPrimary.opacity(0.3),
                                            radius: 16,
                                            y: 6
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: geometry.size.width * 0.65)
                        .disabled(!coordinator.hasMinimumDimensionsSelected())
                        .opacity(showDimensionGrid ? 1 : 0)
                        .scaleEffect(showDimensionGrid ? 1.0 : 0.9)
                        .animation(
                            .spring(response: 0.7, dampingFraction: 0.75).delay(1.2),
                            value: showDimensionGrid
                        )
                        
                        // Subtle hint text
                        Text("Puedes cambiar esto después")
                            .font(.manrope(12, weight: .regular))
                            .foregroundColor(theme.colors.welcomeTextMuted.opacity(0.7))
                            .opacity(showDimensionGrid ? 1 : 0)
                            .animation(
                                .easeOut(duration: 0.6).delay(1.4),
                                value: showDimensionGrid
                            )
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
            }
        }
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
    
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

// MARK: - Animated Wave Shape (Onda de Mar Suave con Animación)
struct AnimatedWaveShape: Shape {
    var phase: Double
    var isTransitioning: Bool
    var showingGrid: Bool
    
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Curvatura adaptativa: más sutil cuando se muestra el grid
        let waveHeight: CGFloat = showingGrid ? 15 : (isTransitioning ? 20 : 35)
        let waveFrequency: CGFloat = showingGrid ? 1.8 : (isTransitioning ? 2.0 : 2.5)
        
        // Inicio desde la esquina superior izquierda
        let startY = waveHeight * 0.6 + sin(0) * waveHeight * 0.4
        path.move(to: CGPoint(x: 0, y: startY))
        
        // Crear ondas suaves usando curvas Bézier
        let segments = 60 // Más segmentos = más suave
        let stepX = rect.width / CGFloat(segments)
        
        for i in 1...segments {
            let x = CGFloat(i) * stepX
            let normalizedX = x / rect.width
            
            // Función seno con phase para crear ondas animadas como el mar
            let sineWave = sin((normalizedX * waveFrequency * .pi * 2) + phase)
            let y = waveHeight * 0.6 + sineWave * waveHeight * 0.4
            
            let prevX = CGFloat(i - 1) * stepX
            let prevNormalizedX = prevX / rect.width
            let prevSineWave = sin((prevNormalizedX * waveFrequency * .pi * 2) + phase)
            let prevY = waveHeight * 0.6 + prevSineWave * waveHeight * 0.4
            
            // Calcular punto de control para curva suave
            let controlX = (prevX + x) / 2
            let controlNormalizedX = controlX / rect.width
            let controlSineWave = sin((controlNormalizedX * waveFrequency * .pi * 2) + phase)
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
