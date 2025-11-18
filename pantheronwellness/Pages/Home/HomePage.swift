import SwiftUI

struct HomePage: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @Environment(\.appTheme) var theme
    
    private var contextualGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5...11: return "¿Cómo amaneciste hoy?"
        case 12...17: return "¿Cómo va tu día?"
        case 18...22: return "¿Cómo te sientes esta noche?"
        default: return "¿Cómo estás?"
        }
    }
    
    private var mainGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5...11: return "Buenos días ☀️"
        case 12...18: return "Buenas tardes"
        case 19...22: return "Buenas noches 🌙"
        default: return "Hola"
        }
    }
    
    private var suggestedDimension: WellnessDimension? {
        coordinator.getSuggestedDimensionForToday()
    }
    
    private var weekProgress: Int {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let completedThisWeek = coordinator.userProfile.dailyProgressHistory.filter {
            $0.date >= weekStart
        }
        return completedThisWeek.count
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                // Top Bar
                HomeTopBar(
                    userName: coordinator.userProfile.name,
                    greeting: contextualGreeting,
                    notificationCount: 0
                )
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.6), value: showContent)
                
                // Greeting
                HStack {
                    Text(coordinator.userProfile.name.isEmpty 
                         ? mainGreeting 
                         : "Hola, \(coordinator.userProfile.name)")
                        .font(.manrope(28, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)
                
                // Primary Action Card
                if let dimension = suggestedDimension {
                    PrimaryActionCard(
                        dimension: dimension,
                        onStart: {
                            coordinator.navigateToActionTimer(dimension: dimension)
                        }
                    )
                    .padding(.horizontal, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                }
                
                // Stats Row
                StatsRowCompact(
                    streak: coordinator.userProfile.currentStreak,
                    totalXP: coordinator.userProfile.totalXP,
                    weekProgress: weekProgress
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                
                // Progress Section
                ProgressSection(
                    activities: getActivities()
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                
                // Motivational Text
                Text("Tu constancia es lo que realmente transforma tu vida")
                    .font(.manrope(14, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, 16)
        }
        .ignoresSafeArea(.container, edges: .top)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            coordinator.resetDailyState()
            showContent = true
        }
    }
    
    private func getActivities() -> [ActivitySummary] {
        return coordinator.userProfile.selectedWellnessFocus.map { dimension in
            let identity = coordinator.userProfile.identities[dimension]
            let days = identity?.evidenceCount ?? 0
            
            return ActivitySummary(
                dimension: dimension,
                days: days,
                illustration: dimension.iconName
            )
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
