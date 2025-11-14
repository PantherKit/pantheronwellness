import SwiftUI

struct DailyActionView: View {
    let dimension: WellnessDimension
    @ObservedObject var coordinator: AppCoordinator
    @Namespace private var animationNamespace
    @State private var showContent = false
    @State private var actionStarted = false
    @State private var timeRemaining = 120 // Será ajustado por micro-acción adaptativa
    @State private var timer: Timer?
    @State private var currentStep = 0
    @State private var showInstructions = false
    @Environment(\.appTheme) var theme
    
    // Obtener micro-acción adaptativa
    private var adaptiveAction: AdaptiveMicroAction {
        coordinator.getAdaptiveMicroAction(for: dimension)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with subtle gradient
                LinearGradient(
                    colors: [
                        theme.colors.background,
                        dimension.primaryColor.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header con información adaptativa
                    VStack(spacing: 24) {
                        HStack(spacing: 12) {
                            Text(adaptiveAction.level.emoji)
                                .font(.title)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Micro-acción \(adaptiveAction.level.displayName)")
                                    .font(theme.typography.headline)
                                    .foregroundColor(theme.colors.onBackground)
                                
                                Text("\(adaptiveAction.formattedDuration) • Personalizada para ti")
                                    .font(theme.typography.caption)
                                    .foregroundColor(dimension.primaryColor)
                            }
                            
                            Spacer()
                        }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : -20)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.2), 
                            value: showContent
                        )
                        
                        Text(adaptiveAction.personalityAdaptation)
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
                    
                    Spacer()
                    
                    // Action Card with matched geometry effects
                    VStack(spacing: 32) {
                        // Icon (matches from selection)
                        Image(systemName: dimension.iconName)
                            .font(.system(size: 48, weight: .medium))
                            .foregroundColor(dimension.primaryColor)
                            .matchedGeometryEffect(
                                id: "icon-\(dimension.rawValue)", 
                                in: animationNamespace,
                                properties: .frame,
                                isSource: false
                            )
                        
                        VStack(spacing: 16) {
                            // Identity name (matches from selection)
                            Text(dimension.displayName)
                                .font(theme.typography.title1)
                                .foregroundColor(theme.colors.onBackground)
                                .matchedGeometryEffect(
                                    id: "title-\(dimension.rawValue)", 
                                    in: animationNamespace,
                                    properties: .frame,
                                    isSource: false
                                )
                            
                            // Identity statement
                            Text(dimension.identityStatement)
                                .font(theme.typography.body1)
                                .foregroundColor(theme.colors.onBackground.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1 : 0)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.6), 
                                    value: showContent
                                )
                        }
                        
                        if let identity = identity {
                            evidenceSummary(identity: identity)
                                .opacity(showContent ? 1 : 0)
                                .transition(.opacity)
                        }
                        
                        // Adaptive Action Content
                        VStack(spacing: 20) {
                            // Main Description
                            Text(adaptiveAction.description)
                                .font(theme.typography.title2)
                                .foregroundColor(theme.colors.onBackground)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.8), 
                                    value: showContent
                                )
                            
                            // Step-by-step instructions (when started)
                            if actionStarted && showInstructions {
                                AdaptiveInstructionsView(
                                    adaptiveAction: adaptiveAction,
                                    currentStep: $currentStep,
                                    dimension: dimension
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                            }
                            
                            // Timer display with adaptive duration
                            if actionStarted {
                                HStack(spacing: 12) {
                                    Image(systemName: "timer")
                                        .font(.title3)
                                        .foregroundColor(dimension.primaryColor)
                                    
                                    VStack(spacing: 4) {
                                        Text(timeString)
                                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                                            .foregroundColor(dimension.primaryColor)
                                        
                                        Text("Tiempo restante")
                                            .font(theme.typography.caption)
                                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    // Step progress
                                    if showInstructions {
                                        VStack(spacing: 4) {
                                            Text("\(currentStep + 1)/\(adaptiveAction.instructions.count)")
                                                .font(.system(size: 18, weight: .semibold))
                                                .foregroundColor(dimension.primaryColor)
                                            
                                            Text("Pasos")
                                                .font(theme.typography.caption)
                                                .foregroundColor(theme.colors.onBackground.opacity(0.6))
                                        }
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(dimension.primaryColor.opacity(0.1))
                                )
                                .opacity(actionStarted ? 1 : 0)
                                .scaleEffect(actionStarted ? 1 : 0.8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: actionStarted)
                            }
                        }
                    }
                    .padding(32)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(theme.colors.surface)
                            .matchedGeometryEffect(
                                id: "background-\(dimension.rawValue)", 
                                in: animationNamespace,
                                properties: .frame,
                                isSource: false
                            )
                            .shadow(
                                color: dimension.primaryColor.opacity(0.2),
                                radius: 20,
                                x: 0,
                                y: 10
                            )
                    )
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.9)
                    .animation(
                        .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.8).delay(0.4), 
                        value: showContent
                    )
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        if !actionStarted {
                            AnimatedButton(
                                title: "Comenzar micro-acción",
                                action: startAction,
                                style: .primary
                            )
                        } else {
                            HStack(spacing: 12) {
                                // Next Step Button (if instructions are shown)
                                if showInstructions && currentStep < adaptiveAction.instructions.count - 1 {
                                    AnimatedButton(
                                        title: "Siguiente paso",
                                        action: nextStep,
                                        style: .secondary
                                    )
                                }
                                
                                // Complete Button
                                AnimatedButton(
                                    title: timeRemaining > 0 ? "Completar ahora" : "¡Evidencia registrada!",
                                    action: completeAction,
                                    style: timeRemaining > 0 ? .secondary : .primary
                                )
                            }
                        }
                        
                        // Toggle Instructions Button (when started)
                        if actionStarted {
                            Button(showInstructions ? "Ocultar instrucciones" : "Ver pasos detallados") {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                    showInstructions.toggle()
                                }
                            }
                            .font(theme.typography.body2)
                            .foregroundColor(dimension.primaryColor)
                        }
                        
                        // Skip button
                        Button("Elegir otra identidad") {
                            coordinator.navigateBackToDailyCheckIn()
                        }
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                        .opacity(showContent ? 1 : 0)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.2), 
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
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func startAction() {
        actionStarted = true
        currentStep = 0
        
        // Set adaptive duration
        timeRemaining = Int(adaptiveAction.estimatedDuration)

        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Show instructions after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showInstructions = true
            }
        }
        
        // Start timer with adaptive duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                // Auto complete when timer reaches 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completeAction()
                }
            }
        }
    }
    
    private func nextStep() {
        if currentStep < adaptiveAction.instructions.count - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep += 1
            }
            
            // Haptic feedback for step progression
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    private func completeAction() {
        timer?.invalidate()
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        coordinator.navigateToFeedback(dimension: dimension)
    }
    
    // MARK: - Helpers
    private var identity: Identity? {
        coordinator.userProfile.identities[dimension]
    }
    
    // MARK: - Computed Properties
    private var contextualTimeOfDay: TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5...11: return .morning
        case 12...17: return .afternoon
        case 18...22: return .evening
        default: return .night
        }
    }
    
    private var adaptiveDescription: String {
        return adaptiveAction.getContextualDescription(for: contextualTimeOfDay)
    }
    
    @ViewBuilder
    private func evidenceSummary(identity: Identity) -> some View {
        VStack(spacing: 12) {
            Text("\(identity.level.emoji) Identidad \(identity.level.displayName)")
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onBackground.opacity(0.7))
            
            HStack(spacing: 12) {
                evidenceMetric(title: "Evidencias", value: "\(identity.evidenceCount)")
                evidenceMetric(title: "Racha", value: "\(identity.currentStreak) días")
            }
        }
    }
    
    private func evidenceMetric(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(theme.typography.title3)
                .foregroundColor(dimension.primaryColor)
            Text(title)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onBackground.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}
