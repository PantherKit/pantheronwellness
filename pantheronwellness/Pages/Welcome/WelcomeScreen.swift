import SwiftUI
import Lottie

struct WelcomeScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    // Secuencia de animación premium
    @State private var showBackground = false      // T0.0s
    @State private var showLottie = false          // T1.0s
    @State private var showWavePanel = false       // T2.2s
    @State private var showContent = false         // T2.8s
    
    // Estados existentes
    @State private var animationLoaded = false
    @State private var isButtonPressed = false
    @State private var wavePhase: Double = 0
    @State private var isTransitioning = false
    @State private var showOnboardingContent = false
    @State private var showHowItWorks = false  // NUEVO: Para carousel educativo
    @State private var howItWorksPage: Int = 0  // NUEVO: Página actual del carousel
    @State private var showExplanation = false
    @State private var showDimensionGrid = false
    @State private var showConfirmation = false
    @State private var isLottieActive = true
    @State private var currentCarouselIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var showNameInput = false
    @State private var userName: String = ""
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
            
            // Secuencia de animación premium y calm
            startPremiumAnimationSequence()
            
            // Iniciar animación continua de olas
            startWaveAnimation()
        }
    
    }
    
    // MARK: - Hero Animation Section (Lottie + Background)
    private func heroAnimationSection(geometry: GeometryProxy) -> some View {
        ZStack {
            // Background Image - Aparece primero (T0.0s)
            Image("backgroundOnboarding")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .opacity(showBackground ? 1.0 : 0)
                .animation(
                    .easeOut(duration: 1.2),
                    value: showBackground
                )
            
            // LottieView - Aparece después con scale elegante (T1.0s)
            LottieView(animation: .named("stress"))
                .playing(loopMode: isLottieActive ? .loop : .playOnce)
                .animationSpeed(0.7)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(showLottie ? 1.4 : 0) // Crece desde 0 (invisible)
                .offset(y: -geometry.size.height * 0.12)
                .opacity(isLottieActive ? 1.0 : 0.3) // Sin fade, siempre visible
                .animation(
                    .spring(response: 1.4, dampingFraction: 0.7),
                    value: showLottie
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
            // Panel blanco con forma de onda animada - Sube desde abajo (T2.2s)
            AnimatedWaveShape(
                phase: wavePhase,
                isTransitioning: isTransitioning,
                showingGrid: showDimensionGrid
            )
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, y: -5)
                .offset(y: showWavePanel ? 0 : geometry.size.height * 0.3)
                .opacity(showWavePanel ? 1 : 0)
                .animation(
                    .spring(response: 1.2, dampingFraction: 0.8),
                    value: showWavePanel
                )
            
            // Contenido dentro del panel
            VStack(spacing: 0) {
                Spacer(minLength: 40)
                
                if !showOnboardingContent {
                    // Welcome Content Section
                    contentSection
                    
                    Spacer(minLength: 20)
                    
                    // CTA Section con geometry para calcular width
                    ctaSection(geometry: geometry)
                } else if !showHowItWorks {
                    // How It Works Carousel (NUEVO)
                    howItWorksCarousel(geometry: geometry)
                } else if showHowItWorks && !showNameInput {
                    // Name Input Section
                    nameInputSection(geometry: geometry)
                } else if !showExplanation {
                    // Explanation Step
                    explanationSection(geometry: geometry)
                } else if !showConfirmation {
                    // Onboarding Dimension Selection Integrated
                    dimensionSelectionSection(geometry: geometry)
                } else {
                    // Confirmation Section
                    confirmationSection(geometry: geometry)
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
            Text("No más datos.\nInstala tu nueva identidad.")
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
            Text("Una micro-acción de 2 minutos al día · 7 dimensiones del wellness")
                .font(.manrope(12, weight: .regular))
                .foregroundColor(theme.colors.welcomeTextMuted.opacity(0.7))
                .multilineTextAlignment(.center)
                .opacity(showContent ? 1 : 0)
                .animation(
                    .easeOut(duration: 0.6).delay(1.5),
                    value: showContent
                )
        }
    }
    
    // MARK: - Premium Animation Sequence
    private func startPremiumAnimationSequence() {
        // T0.0s: Background aparece inmediatamente
        withAnimation(.easeOut(duration: 1.2)) {
            showBackground = true
        }
        
        // T1.0s: Lottie scale + Wave panel suben simultáneamente
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.spring(response: 1.4, dampingFraction: 0.7)) {
                showLottie = true
                showWavePanel = true  // Sube al mismo tiempo
            }
        }
        
        // T1.6s: Contenido aparece (después del wave panel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Transition Functions
    private func startTransition() {
        // Crossfade simultáneo premium - sin delays ni flash
        withAnimation(.easeInOut(duration: 0.4)) {
            showContent = false
            showOnboardingContent = true
        }
        
        // Panel expansion ligeramente más lenta para suavidad
        withAnimation(.spring(response: 1.0, dampingFraction: 0.75)) {
            isTransitioning = true
        }
    }
    
    private func continueToHowItWorks() {
        // Transición al carousel educativo
        withAnimation(.easeInOut(duration: 0.6)) {
            showHowItWorks = true
        }
    }
    
    private func continueToNameInput() {
        // Transición al name input
        // Solo marcamos showHowItWorks = true
        // La condición showHowItWorks && !showNameInput mostrará el Name Input
        withAnimation(.easeInOut(duration: 0.6)) {
            showHowItWorks = true
        }
    }
    
    private func continueToExplanation() {
        // Guardar nombre en UserProfile
        coordinator.userProfile.name = userName.isEmpty ? "Usuario" : userName
        coordinator.saveUserProfile()
        
        // Cambiar velocidad de olas y desactivar Lottie
        isLottieActive = false
        startWaveAnimation()
        
        // Continuar a explanation
        withAnimation(.easeInOut(duration: 0.6)) {
            showNameInput = true  // Marcar name input como completado
            showExplanation = false  // Mostrar explanation
        }
        
        // Expandir panel para el grid
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.75)) {
                showDimensionGrid = true
            }
        }
    }
    
    // MARK: - Name Input Section
    private func nameInputSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {  // Control total del spacing
            // Lottie Icon - Sunrise Animation
            LottieView(animation: .named("sunriseAnimation"))
                .playing(loopMode: .loop)
                .animationSpeed(0.8)
                .frame(width: 340, height: 250)
                .scaleEffect(showOnboardingContent ? 1 : 0.5)
                .animation(
                    .spring(response: 1.0, dampingFraction: 0.6),
                    value: showOnboardingContent
                )
            
            Spacer().frame(height: 12)  // Entre Lottie y texto
            
            // Title and description (grupo cohesivo)
            VStack(spacing: 12) {  // Más íntimo: 18 → 12
                Text("¿Cómo te gustaría que te llamemos?")
                    .font(.manrope(32, weight: .bold))
                    .foregroundColor(theme.colors.welcomeTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(showOnboardingContent ? 1 : 0)
                    .offset(y: showOnboardingContent ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.8).delay(0.2),
                        value: showOnboardingContent
                    )
                
                Text("Tu journey personal comienza aquí.\nBasado en las 7 dimensiones del wellness.")
                    .font(.manrope(16, weight: .regular))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(showOnboardingContent ? 1 : 0)
                    .offset(y: showOnboardingContent ? 0 : 15)
                    .animation(
                        .easeOut(duration: 0.8).delay(0.4),
                        value: showOnboardingContent
                    )
            }
            
            Spacer().frame(height: 24)  // Separación clara del input
            
            // TextField Minimalista
            VStack(spacing: 8) {
                TextField("Me gusta que me digan...", text: $userName)
                    .font(.manrope(20, weight: .regular))
                    .foregroundColor(theme.colors.welcomeTextPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                
                // Línea inferior minimalista
                Rectangle()
                    .fill(theme.colors.welcomeTextPrimary.opacity(0.3))
                    .frame(height: 1)
                    .frame(maxWidth: 200)
            }
            .opacity(showOnboardingContent ? 1 : 0)
            .offset(y: showOnboardingContent ? 0 : 20)
            .animation(
                .easeOut(duration: 0.8).delay(0.6),
                value: showOnboardingContent
            )
            
            Spacer().frame(height: 44)  // Compacto pero elegante
            
            // Buttons (grupo de acciones)
            VStack(spacing: 244) {
                // Continue Button
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    // Dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    continueToExplanation()
                }) {
                    Text("Continuar")
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
                
                // Skip text
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    // Dismiss keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    continueToExplanation()
                }) {
                    Text("Prefiero no decirlo")
                        .font(.manrope(14, weight: .regular))
                        .foregroundColor(theme.colors.welcomeTextMuted.opacity(0.7))
                }
                .opacity(showOnboardingContent ? 1 : 0)
                .animation(
                    .easeOut(duration: 0.6).delay(1.0),
                    value: showOnboardingContent
                )
            }
        }
    }
    
    // MARK: - How It Works Carousel (con Lottie Fijo)
    private func howItWorksCarousel(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            // Lottie FIJO en la parte superior
            LottieView(animation: .named("sunriseAnimation"))
                .playing(loopMode: .loop)
                .animationSpeed(0.8)
                .frame(width: 340, height: 250)
                .scaleEffect(showOnboardingContent ? 1 : 0.5)
                .animation(
                    .spring(response: 1.0, dampingFraction: 0.6),
                    value: showOnboardingContent
                )
            
            Spacer().frame(height: 12)
            
            // Contenido dinámico con fade in/out
            ZStack {
                if howItWorksPage == 0 {
                    howItWorksContent1()
                        .transition(.opacity)
                } else {
                    howItWorksContent2()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.4), value: howItWorksPage)
            
            Spacer().frame(height: 24)
            
            // Botón Siguiente / Comenzar
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                
                if howItWorksPage == 0 {
                    // Ir a página 2
                    withAnimation(.easeInOut(duration: 0.4)) {
                        howItWorksPage = 1
                    }
                } else {
                    // Ir a name input
                    continueToNameInput()
                }
            }) {
                Text(howItWorksPage == 0 ? "Siguiente" : "Comenzar mi journey →")
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
            
            Spacer().frame(height: 20)
            
            // Indicador de página (dots)
            HStack(spacing: 8) {
                Circle()
                    .fill(howItWorksPage == 0 ? theme.colors.welcomeTextPrimary : theme.colors.welcomeTextPrimary.opacity(0.3))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(howItWorksPage == 1 ? theme.colors.welcomeTextPrimary : theme.colors.welcomeTextPrimary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
            .opacity(showOnboardingContent ? 1 : 0)
            .animation(.easeOut(duration: 0.6).delay(1.0), value: showOnboardingContent)
        }
    }
    
    // Contenido de la página 1
    private func howItWorksContent1() -> some View {
        VStack(spacing: 16) {
            Text("Wellty te ayuda a instalar\nel software de una nueva\nidentidad.")
                .font(.manrope(24, weight: .bold))
                .foregroundColor(theme.colors.welcomeTextPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
            
            Text("Cada pequeña acción cuenta.\nCada día construyes quién eres.")
                .font(.manrope(18, weight: .regular))
                .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
        }
        .padding(.horizontal, 24)
    }
    
    // Contenido de la página 2
    private func howItWorksContent2() -> some View {
        VStack(spacing: 20) {
            Text("El ciclo de\nidentidad")
                .font(.manrope(24, weight: .bold))
                .foregroundColor(theme.colors.welcomeTextPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            
            VStack(spacing: 12) {
                Text("1. Eliges quién quieres ser")
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.9))
                
                Text("↓")
                    .font(.system(size: 20))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.4))
                
                Text("2. Completas 1 micro-acción")
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.9))
                
                Text("↓")
                    .font(.system(size: 20))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.4))
                
                Text("3. Creas evidencia")
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.9))
                
                Text("↓")
                    .font(.system(size: 20))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.4))
                
                Text("4. Refuerzas tu identidad")
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.9))
            }
            
            Text("2 minutos al día.\n7 dimensiones del wellness.\nUna identidad a la vez.")
                .font(.manrope(14, weight: .regular))
                .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.top, 8)
        }
        .padding(.horizontal, 24)
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
                Text("¿En qué dimensiones\nquieres enfocarte?")
                    .font(.manrope(32, weight: .bold))
                    .foregroundColor(theme.colors.welcomeTextPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .opacity(showOnboardingContent ? 1 : 0)
                    .offset(y: showOnboardingContent ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.8).delay(0.2),
                        value: showOnboardingContent
                    )
                
                VStack(spacing: 16) {
                    Text("Selecciona 2-3 dimensiones que quieras fortalecer.")
                        .font(.manrope(18, weight: .regular))
                        .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    Text("Cada día podrás elegir una acción de estas áreas.\nNo te preocupes, podrás cambiarlas después.")
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
    
    private func showConfirmationView() {
        // Fade out carousel y mostrar confirmation
        withAnimation(.easeInOut(duration: 0.6)) {
            showConfirmation = true
        }
    }
    
    // MARK: - Wave Animation Control
    private func startWaveAnimation() {
        let duration = isTransitioning ? 8.4 : 10.0 // Más lenta en estado inicial: 6.0 → 10.0
        withAnimation(
            .linear(duration: duration)
            .repeatForever(autoreverses: false)
        ) {
            wavePhase = .pi * 2 // Un ciclo completo
        }
    }
    
    // MARK: - Dimension Selection Section (Carousel Curveado)
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
                    
                    Text("Selecciona 2 o 3 dimensiones.\nDesliza para explorar.")
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
            .padding(.bottom, 30)
            
            // Curved Carousel Section
            carouselView(geometry: geometry)
                .frame(height: 280)
                .padding(.bottom, 30)
            
            // Continue Button
            VStack(spacing: 12) {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showConfirmationView()
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
        }
    }
    
    // MARK: - Curved Carousel View
    private func carouselView(geometry: GeometryProxy) -> some View {
        // Card width optimizado a 50% para fit perfecto de 3 cards
        let cardWidth: CGFloat = geometry.size.width * 0.5
        let cardHeight: CGFloat = 240
        // Spacing mínimo para compacidad
        let spacing: CGFloat = 8
        // Spacer para centrar primera/última card
        let sideSpacing: CGFloat = (geometry.size.width - cardWidth) / 2
        
        return ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    // Leading spacer para centrar primera card
                    Spacer()
                        .frame(width: sideSpacing)
                    
                    ForEach(Array(WellnessDimension.allCases.enumerated()), id: \.element) { index, dimension in
                        GeometryReader { cardGeo in
                            let minX = cardGeo.frame(in: .global).minX
                            let screenWidth = geometry.size.width
                            let centerX = screenWidth / 2
                            let cardCenterX = minX + (cardWidth / 2)
                            let distance = cardCenterX - centerX
                            
                            // Transformaciones 3D pronunciadas
                            let rotation = Double(distance / screenWidth) * 35  // ±35° rotación
                            let scale = max(0.7, 1.0 - abs(distance / screenWidth) * 0.3)
                            let yOffset = abs(distance / screenWidth) * 40  // Curvatura pronunciada
                            let opacity = max(0.5, 1.0 - abs(distance / screenWidth) * 0.5)  // Mejor visibilidad lateral
                            
                            IdentityCard(
                                dimension: dimension,
                                identity: nil,
                                isSelected: coordinator.selectedFocusDimensions.contains(dimension),
                                namespace: animationNamespace,
                                onTap: {
                                    // Scroll to center + toggle selection
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        proxy.scrollTo(dimension, anchor: .center)
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        coordinator.toggleFocusDimension(dimension)
                                    }
                                },
                                style: .compact,
                                overrideColor: theme.colors.welcomeTextPrimary
                            )
                            .frame(width: cardWidth, height: cardHeight)
                            .rotation3DEffect(
                                .degrees(rotation),
                                axis: (x: 0, y: 1, z: 0),
                                perspective: 0.5
                            )
                            .scaleEffect(scale)
                            .offset(y: yOffset)
                            .opacity(opacity)
                            .opacity(showDimensionGrid ? 1 : 0)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)
                                .delay(0.6 + Double(index) * 0.08),
                                value: showDimensionGrid
                            )
                        }
                        .frame(width: cardWidth, height: cardHeight)
                        .id(dimension)
                    }
                    
                    // Trailing spacer para centrar última card
                    Spacer()
                        .frame(width: sideSpacing)
                }
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                // Centrar en la primera card al aparecer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                        proxy.scrollTo(WellnessDimension.allCases.first, anchor: .center)
                    }
                }
            }
        }
    }
    
    // MARK: - Confirmation Section
    private func confirmationSection(geometry: GeometryProxy) -> some View {
        VStack(spacing: 32) {
            // Success Icon
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
                
                Image(systemName: "checkmark")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundColor(Color(hex: 0x1A5A53))
            }
            .scaleEffect(showConfirmation ? 1 : 0.5)
            .animation(
                .spring(response: 0.8, dampingFraction: 0.6),
                value: showConfirmation
            )
            
            // Title
            VStack(spacing: 16) {
                Text("Perfecto, vamos a\nenfocarnos en:")
                    .font(.manrope(28, weight: .bold))
                    .foregroundColor(theme.colors.welcomeTextPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(showConfirmation ? 1 : 0)
                    .offset(y: showConfirmation ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.3),
                        value: showConfirmation
                    )
                
                // Dimension Chips
                VStack(spacing: 12) {
                    ForEach(Array(coordinator.selectedFocusDimensions.enumerated()), id: \.element) { index, dimension in
                        DimensionChip(dimension: dimension)
                            .opacity(showConfirmation ? 1 : 0)
                            .offset(x: showConfirmation ? 0 : -30)
                            .animation(
                                .easeOut(duration: 0.5).delay(0.5 + Double(index) * 0.1),
                                value: showConfirmation
                            )
                    }
                }
                .padding(.vertical, 8)
                
                Text("Tu journey personalizado está listo")
                    .font(.manrope(16, weight: .regular))
                    .foregroundColor(theme.colors.welcomeTextPrimary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .opacity(showConfirmation ? 1 : 0)
                    .offset(y: showConfirmation ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.6).delay(0.8),
                        value: showConfirmation
                    )
            }
            
            Spacer(minLength: 20)
            
            // CTA Button
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                coordinator.completeFocusSelection()
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
                                color: theme.colors.welcomeTextPrimary.opacity(0.3),
                                radius: 16,
                                y: 6
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: geometry.size.width * 0.65)
            .opacity(showConfirmation ? 1 : 0)
            .offset(y: showConfirmation ? 0 : 30)
            .animation(
                .spring(response: 0.7, dampingFraction: 0.75).delay(1.0),
                value: showConfirmation
            )
        }
    }
    
    // MARK: - Dimension Chip Component
    private struct DimensionChip: View {
        let dimension: WellnessDimension
        @Environment(\.appTheme) var theme
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: dimension.iconName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: 0x1A5A53))
                
                Text(dimension.displayName)
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(Color(hex: 0x1A5A53))
                
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: 0x1A5A53))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: 0xB6E2D3).opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: 0x1A5A53).opacity(0.2), lineWidth: 1)
                    )
            )
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
        let waveHeight: CGFloat = showingGrid ? 15 : (isTransitioning ? 20 : 25)  // Menos pronunciada: 35 → 25
        let waveFrequency: CGFloat = showingGrid ? 1.8 : (isTransitioning ? 2.0 : 1.5)  // Menos frecuencia: 2.5 → 1.5
        
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
