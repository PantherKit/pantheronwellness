import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case progress = "Progreso"
    case profile = "Perfil"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .profile: return "person.fill"
        }
    }
    
    var iconUnselected: String {
        switch self {
        case .home: return "house"
        case .progress: return "chart.line.uptrend.xyaxis"
        case .profile: return "person"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedTab: Tab = .home
    @Environment(\.appTheme) var theme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            TabView(selection: $selectedTab) {
                HomePage()
                    .tag(Tab.home)
                
                ProgressView(coordinator: coordinator)
                    .tag(Tab.progress)
                
                ProfilePlaceholderView()
                    .tag(Tab.profile)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Environment(\.appTheme) var theme
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: animation
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    
                    // Haptic feedback
                    let impact = UIImpactFeedbackGenerator(style: .light)
                    impact.impactOccurred()
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 12, y: 4)
        )
    }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
    let tab: Tab
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: isSelected ? tab.icon : tab.iconUnselected)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? theme.colors.primary : theme.colors.onSurface.opacity(0.4))
                    .frame(height: 24)
                
                Text(tab.rawValue)
                    .font(theme.typography.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? theme.colors.primary : theme.colors.onSurface.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(theme.colors.primary.opacity(0.08))
                            .matchedGeometryEffect(id: "tab_background", in: namespace)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Profile Placeholder
struct ProfilePlaceholderView: View {
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "person.circle")
                    .font(.system(size: 64))
                    .foregroundColor(theme.colors.primary)
                
                Text("Perfil")
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                
                Text("Próximamente")
                    .font(theme.typography.body2)
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppCoordinator())
}

