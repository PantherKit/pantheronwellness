import SwiftUI

struct FeedbackView: View {
    let dimension: WellnessDimension
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var showSparkles = false
    @State private var showPulse = false
    @Environment(\.appTheme) var theme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with gradient
                LinearGradient(
                    colors: [
                        dimension.primaryColor.opacity(0.1),
                        theme.colors.background
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Main feedback content
                    VStack(spacing: 40) {
                        // Icon with effects
                        ZStack {
                            // Pulse effect background
                            if showPulse {
                                PulseEffect(color: dimension.primaryColor)
                                    .frame(width: 100, height: 100)
                            }
                            
                            // Main icon
                            Image(systemName: dimension.iconName)
                                .font(.system(size: 64, weight: .medium))
                                .foregroundColor(dimension.primaryColor)
                                .opacity(showContent ? 1 : 0)
                                .scaleEffect(showContent ? 1 : 0.5)
                                .animation(
                                    .spring(response: 0.6, dampingFraction: 0.7).delay(0.2), 
                                    value: showContent
                                )
                            
                            // Sparkle effects
                            if showSparkles {
                                SparkleEffect(color: dimension.primaryColor)
                            }
                        }
                        
                        // Feedback text
                        VStack(spacing: 20) {
                            Text("Hoy actuaste como alguien que...")
                                .font(theme.typography.title2)
                                .foregroundColor(theme.colors.onBackground.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.4), 
                                    value: showContent
                                )
                            
                            Text(dimension.identityStatement.lowercased())
                                .font(theme.typography.headline)
                                .foregroundColor(dimension.primaryColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.6), 
                                    value: showContent
                                )
                            
                            Text("Un comportamiento a la vez instala tu nueva identidad.")
                                .font(theme.typography.body1)
                                .foregroundColor(theme.colors.onBackground.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(0.8), 
                                    value: showContent
                                )
                        }
                        
                        // Progress indicator
                        if let progress = coordinator.identityProgress[dimension] {
                            VStack(spacing: 12) {
                                HStack(spacing: 16) {
                                    // Streak indicator
                                    VStack(spacing: 4) {
                                        Text("\(progress.currentStreak)")
                                            .font(theme.typography.title1)
                                            .foregroundColor(dimension.primaryColor)
                                        
                                        Text("días seguidos")
                                            .font(theme.typography.caption)
                                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                                    }
                                    
                                    Divider()
                                        .frame(height: 40)
                                    
                                    // Total completions
                                    VStack(spacing: 4) {
                                        Text("\(progress.totalCompletions)")
                                            .font(theme.typography.title1)
                                            .foregroundColor(dimension.primaryColor)
                                        
                                        Text("veces total")
                                            .font(theme.typography.caption)
                                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(theme.colors.surface)
                                        .shadow(
                                            color: dimension.primaryColor.opacity(0.1),
                                            radius: 10,
                                            x: 0,
                                            y: 5
                                        )
                                )
                                .opacity(showContent ? 1 : 0)
                                .scaleEffect(showContent ? 1 : 0.9)
                                .animation(
                                    .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.0), 
                                    value: showContent
                                )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        AnimatedButton(
                            title: "Ver mi progreso",
                            action: {
                                coordinator.navigateToProgress()
                            },
                            style: .primary
                        )
                        
                        Button("Elegir otra identidad") {
                            coordinator.navigateBackToSelection()
                        }
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                        .opacity(showContent ? 1 : 0)
                        .animation(
                            .timingCurve(0.4, 0.0, 0.2, 1, duration: 0.6).delay(1.4), 
                            value: showContent
                        )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            // Sequence the animations
            showContent = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showPulse = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showSparkles = true
            }
        }
    }
}
