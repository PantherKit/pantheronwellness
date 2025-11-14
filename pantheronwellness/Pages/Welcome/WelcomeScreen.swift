import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color.blue.opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Hero Section
                VStack(spacing: 40) {
                    // App Icon/Logo
                    VStack(spacing: 24) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .blue.opacity(0.3),
                                        .purple.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                            )
                            .scaleEffect(showContent ? 1 : 0.7)
                            .animation(.spring(response: 1.0, dampingFraction: 0.6), value: showContent)
                    }
                    
                    // Title & Subtitle
                    VStack(spacing: 20) {
                        Text("Bienvenido a")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                        
                        Text("Codename Wellness")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)
                        
                        Text("Tu compañero para construir\nuna mejor versión de ti mismo")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.7), value: showContent)
                    }
                }
                
                Spacer()
                
                // CTA Button
                VStack(spacing: 16) {
                    Button(action: {
                        coordinator.navigateToOnboarding()
                    }) {
                        HStack(spacing: 12) {
                            Text("Comenzar")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "arrow.right")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .blue,
                                    .blue.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .scaleEffect(showContent ? 1.0 : 0.9)
                    .opacity(showContent ? 1 : 0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.9), value: showContent)
                    
                    Text("Tu camino hacia el bienestar comienza aquí")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .opacity(showContent ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(1.1), value: showContent)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            showContent = true
        }
    }
}

#Preview {
    WelcomeScreen()
        .environmentObject(AppCoordinator())
}
