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
    
    private var heroMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5...11: return "¡Buenos días! Comienza tu día con bienestar"
        case 12...17: return "Momento perfecto para tu micro-acción"
        case 18...22: return "Cierra el día cuidando de ti"
        default: return "Tu bienestar te espera"
        }
    }
    
    private var heroSubtitle: String {
        if coordinator.userProfile.currentStreak > 0 {
            return "Llevas \(coordinator.userProfile.currentStreak) días construyendo tu mejor versión"
        } else {
            return "Cada pequeña acción cuenta en tu journey"
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Top Bar
                HomeTopBar(
                    userName: coordinator.userProfile.name,
                    greeting: contextualGreeting,
                    notificationCount: 0
                )
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Greeting
                HStack {
                    Text("Hola, \(coordinator.userProfile.name)")
                        .font(.manrope(28, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.1), value: showContent)
                
                // Hero Section
                HomeHeroSection(
                    message: heroMessage,
                    subtitle: heroSubtitle
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                
                // Activities Grid
                ActivitiesGrid(
                    activities: getActivities(),
                    onActivityTap: { dimension in
                        coordinator.navigateToActionTimer(dimension: dimension)
                    }
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 40)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                
                // Motivational Text
                Text("Tu constancia es lo que realmente transforma tu vida")
                    .font(.manrope(14, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, 16)
        }
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
