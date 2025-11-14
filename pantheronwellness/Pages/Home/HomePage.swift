import SwiftUI

struct HomePage: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @Environment(\.appTheme) var theme
    
    private var suggestedDimension: WellnessDimension? {
        coordinator.getSuggestedDimensionForToday()
    }
    
    private var hasCompletedToday: Bool {
        coordinator.userProfile.hasCompletedTodayAction
    }
    
    private var streak: Int {
        coordinator.userProfile.currentStreak
    }
    
    private var totalXP: Int {
        coordinator.userProfile.totalXP
    }
    
    private var currentLevel: UserLevel {
        coordinator.userProfile.currentLevel
    }
    
    private var weeklyProgress: Double {
        coordinator.userProfile.weeklyGoalProgress
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                HomeHeader(
                    userName: coordinator.userProfile.name,
                    streak: streak,
                    dayNumber: coordinator.userProfile.activeDaysCount + 1
                )
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Hero Card - Main Action
                if let dimension = suggestedDimension {
                    if hasCompletedToday {
                        CompletedHeroCard(
                            dimension: dimension,
                            onViewProgress: {
                                // Navigate to progress tab
                            },
                            onDoMore: {
                                // Start another action
                            }
                        )
                        .padding(.horizontal, 20)
                    } else {
                        ActionHeroCard(
                            dimension: dimension,
                            onStart: {
                                coordinator.navigateToActionTimer(dimension: dimension)
                            }
                        )
                        .padding(.horizontal, 20)
                    }
                }
                
                // Stats Row
                StatsRow(
                    streak: streak,
                    weeklyGoal: weeklyProgress,
                    totalXP: totalXP,
                    level: currentLevel
                )
                .padding(.horizontal, 20)
                
                // Journey Progress
                JourneyProgressSection(
                    focusedDimensions: coordinator.userProfile.selectedWellnessFocus,
                    identities: coordinator.userProfile.identities
                )
                .padding(.horizontal, 20)
                
                // Daily Challenge
                if let challenge = coordinator.userProfile.currentDailyChallenge {
                    DailyChallengeCard(challenge: challenge)
                        .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, 16)
        }
        .background(theme.colors.background.ignoresSafeArea())
        .onAppear {
            coordinator.resetDailyState()
            showContent = true
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(AppCoordinator())
}

#Preview {
    HomePage()
        .environmentObject(AppCoordinator())
}
