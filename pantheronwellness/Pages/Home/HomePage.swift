import SwiftUI

struct HomePage: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @Environment(\.appTheme) var theme
    
    private var focusedDimensions: [WellnessDimension] {
        coordinator.userProfile.selectedWellnessFocus
    }
    
    var body: some View {
        ZStack {
            // Background
            theme.colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Placeholder Icon
                Image(systemName: "sparkles")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(theme.colors.primary)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)
                
                // Message
                VStack(spacing: 16) {
                    Text("Tu Wellness Journey")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onBackground)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                    
                    if !focusedDimensions.isEmpty {
                        VStack(spacing: 8) {
                            Text("Estás enfocado en:")
                                .font(theme.typography.body2)
                                .foregroundColor(theme.colors.onBackground.opacity(0.6))
                            
                            HStack(spacing: 8) {
                                ForEach(focusedDimensions.prefix(3), id: \.self) { dimension in
                                    HStack(spacing: 6) {
                                        Image(systemName: dimension.iconName)
                                            .font(.system(size: 14, weight: .medium))
                                        Text(dimension.displayName)
                                            .font(theme.typography.caption)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(dimension.primaryColor.opacity(0.1))
                                    )
                                    .foregroundColor(dimension.primaryColor)
                                }
                            }
                        }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                    }
                    
                    Text("Pronto añadiremos más funcionalidades increíbles")
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
        }
        .onAppear {
            showContent = true
        }
    }
}

#Preview {
    HomePage()
        .environmentObject(AppCoordinator())
}
