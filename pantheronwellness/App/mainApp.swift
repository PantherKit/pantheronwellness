//
//  pantheronwellnessApp.swift
//  pantheronwellness
//
//  Created by Emiliano Montes on 13/11/25.
//

import SwiftUI

@main
struct PantherOnWellnessApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            MainRouterView()
                .environmentObject(coordinator)
        }
    }
}

struct MainRouterView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            switch coordinator.currentView {
            case .welcome:
                WelcomeScreen()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .onboarding:
                OnboardingView(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .confirmation:
                ConfirmationView(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .assessmentWelcome:
                AssessmentWelcomePage(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .assessmentQuestion(let questionIndex):
                AssessmentQuestionPage(coordinator: coordinator, questionIndex: questionIndex)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .home:
                HomePage()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                
            // Mantener otras vistas para no romper el sistema existente
            case .identitySelection:
                IdentitySelectionView(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .dailyCheckIn:
                DailyCheckInView(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .dailyAction(let dimension):
                DailyActionView(dimension: dimension, coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                
            case .feedback(let dimension):
                FeedbackView(dimension: dimension, coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                
            case .progress:
                ProgressView(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
            }
        }
        .appTheme(.default)
        .animation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35), value: coordinator.currentView)
    }
}

#Preview {
    MainRouterView()
        .environmentObject(AppCoordinator())
}
