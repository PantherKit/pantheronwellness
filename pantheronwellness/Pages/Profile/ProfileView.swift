import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var showLogoutAlert = false
    @Environment(\.appTheme) var theme
    
    private var profile: UserProfile { coordinator.userProfile }
    
    private var memberSinceText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "es_ES")
        return "Miembro desde \(formatter.string(from: profile.startDate))"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 32) {
                // Header con Avatar
                VStack(spacing: 16) {
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: 0xB6E2D3),
                                        Color(hex: 0x1A5A53)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Text(profile.name.prefix(1).uppercased())
                            .font(.manrope(32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(showContent ? 1 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: showContent)
                    
                    // Nombre
                    Text(profile.name)
                        .font(.manrope(24, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.2), value: showContent)
                    
                    // Fecha inicio
                    Text(memberSinceText)
                        .font(.manrope(14, weight: .regular))
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.3), value: showContent)
                }
                .padding(.top, 60)
                
                // Stats Grid 2x2
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tus Estadísticas")
                        .font(.manrope(18, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.4), value: showContent)
                    
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ProfileStatCard(
                            icon: "flame.fill",
                            value: "\(profile.currentStreak)",
                            label: "días",
                            color: .orange
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.45), value: showContent)
                        
                        ProfileStatCard(
                            icon: "bolt.fill",
                            value: "\(profile.totalXP)",
                            label: "XP",
                            color: .yellow
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.53), value: showContent)
                        
                        ProfileStatCard(
                            icon: "star.fill",
                            value: UserLevel.level(for: profile.totalXP).emoji,
                            label: UserLevel.level(for: profile.totalXP).displayName,
                            color: .purple
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.61), value: showContent)
                        
                        ProfileStatCard(
                            icon: "calendar.badge.checkmark",
                            value: "\(profile.totalActiveDays)",
                            label: "días activos",
                            color: Color(hex: 0x34C759)
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.69), value: showContent)
                    }
                }
                .padding(.horizontal, 20)
                
                // Settings Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Configuración")
                        .font(.manrope(18, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.7), value: showContent)
                    
                    VStack(spacing: 8) {
                        ProfileSettingRow(
                            icon: "person.crop.circle",
                            title: "Editar Perfil",
                            subtitle: "Próximamente",
                            isEnabled: false,
                            action: {}
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.75), value: showContent)
                        
                        ProfileSettingRow(
                            icon: "bell.badge",
                            title: "Notificaciones",
                            subtitle: "Próximamente",
                            isEnabled: false,
                            action: {}
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.8), value: showContent)
                        
                        ProfileSettingRow(
                            icon: "square.grid.2x2",
                            title: "Tus Dimensiones Focus",
                            subtitle: "Cambiar selección",
                            isEnabled: false,
                            action: {}
                        )
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.85), value: showContent)
                    }
                }
                .padding(.horizontal, 20)
                
                // Logout Button
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    showLogoutAlert = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                        
                        Text("Cerrar Sesión")
                            .font(.manrope(16, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.3), lineWidth: 1.5)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 32)
                .opacity(showContent ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.9), value: showContent)
                
                // Version
                Text("Versión 1.0.0")
                    .font(.manrope(12, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.4))
                    .opacity(showContent ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(1.0), value: showContent)
                
                Spacer(minLength: 100)
            }
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .alert("¿Cerrar sesión?", isPresented: $showLogoutAlert) {
            Button("Cancelar", role: .cancel) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
            Button("Cerrar Sesión", role: .destructive) {
                let impactFeedback = UINotificationFeedbackGenerator()
                impactFeedback.notificationOccurred(.warning)
                coordinator.logout()
            }
        } message: {
            Text("Volverás a la pantalla de bienvenida. Podrás iniciar sesión nuevamente en cualquier momento.")
        }
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - Subcomponents

private struct ProfileStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.manrope(20, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
            
            Text(label)
                .font(.manrope(12, weight: .medium))
                .foregroundColor(theme.colors.onBackground.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        )
    }
}

private struct ProfileSettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isEnabled: Bool
    let action: () -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isEnabled ? theme.colors.primary : theme.colors.onBackground.opacity(0.4))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(isEnabled ? theme.colors.primary.opacity(0.1) : theme.colors.onBackground.opacity(0.05))
                    )
                
                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.manrope(16, weight: .semibold))
                        .foregroundColor(theme.colors.onBackground)
                    
                    Text(subtitle)
                        .font(.manrope(13, weight: .regular))
                        .foregroundColor(theme.colors.onBackground.opacity(0.5))
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(theme.colors.onBackground.opacity(0.3))
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppCoordinator())
}
