import SwiftUI

struct DailyActionView: View {
    let dimension: WellnessDimension
    @ObservedObject var coordinator: AppCoordinator
    @Namespace private var animationNamespace
    @State private var showContent = false
    @State private var actionStarted = false
    @State private var timeRemaining = 120 // 2 minutes in seconds
    @State private var timer: Timer?
    @Environment(\.appTheme) var theme
    
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
                    // Header with matched geometry
                    VStack(spacing: 24) {
                        Text("Tu acción de hoy")
                            .font(theme.typography.headline)
                            .foregroundColor(theme.colors.onBackground)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : -20)
                            .animation(
                                .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.2), 
                                value: showContent
                            )
                        
                        Text("2 minutos para reforzar tu nueva identidad")
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
                        
                        // Action description
                        VStack(spacing: 12) {
                            Text(dimension.microAction)
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
                            
                            // Timer display
                            if actionStarted {
                                HStack(spacing: 8) {
                                    Image(systemName: "timer")
                                        .font(.caption)
                                        .foregroundColor(dimension.primaryColor)
                                    
                                    Text(timeString)
                                        .font(theme.typography.body2)
                                        .foregroundColor(dimension.primaryColor)
                                        .monospacedDigit()
                                }
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
                                title: "Iniciar acción",
                                action: startAction,
                                style: .primary
                            )
                        } else {
                            AnimatedButton(
                                title: timeRemaining > 0 ? "Completar antes" : "¡Acción completada!",
                                action: completeAction,
                                style: timeRemaining > 0 ? .secondary : .primary
                            )
                        }
                        
                        // Skip button
                        Button("Saltar por hoy") {
                            coordinator.navigateBackToSelection()
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
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Start timer
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
    
    private func completeAction() {
        timer?.invalidate()
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        coordinator.navigateToFeedback(dimension: dimension)
    }
}
