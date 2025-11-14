//
//  ContentView.swift
//  pantheronwellness
//
//  Created by Emiliano Montes on 13/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        ZStack {
            switch coordinator.currentView {
            case .onboarding:
                OnboardingView(coordinator: coordinator)
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
                
            case .assessmentResults:
                AssessmentResultsPage(coordinator: coordinator)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                
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
    ContentView()
}
