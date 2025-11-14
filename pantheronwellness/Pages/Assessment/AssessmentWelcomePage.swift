import SwiftUI

struct AssessmentWelcomePage: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Main Content
                    VStack(spacing: 32) {
                        // Icon Animation
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: 0x1A5A53).opacity(0.1),
                                                Color(hex: 0xB6E2D3).opacity(0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .scaleEffect(showContent ? 1.0 : 0.8)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: showContent)
                                
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 48, weight: .light))
                                    .foregroundColor(Color(hex: 0x1A5A53))
                                    .scaleEffect(showContent ? 1.0 : 0.5)
                                    .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: showContent)
                            }
                        }
                        
                        // Title and Description
                        VStack(spacing: 20) {
                            Text("Conoce tu Wellness")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 20)
                                .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                            
                            VStack(spacing: 12) {
                                Text("Vamos a crear tu perfil personalizado")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("7 preguntas rápidas para entender tu estado actual de bienestar y diseñar micro-acciones perfectas para ti.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            }
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(0.8), value: showContent)
                        }
                        
                        // Features Preview
                        VStack(spacing: 16) {
                            HStack(spacing: 16) {
                                FeaturePreviewCard(
                                    icon: "target",
                                    title: "Personalizado",
                                    description: "Acciones adaptadas a ti"
                                )
                                
                                FeaturePreviewCard(
                                    icon: "clock",
                                    title: "Rápido",
                                    description: "Solo 2-3 minutos"
                                )
                            }
                            
                            HStack(spacing: 16) {
                                FeaturePreviewCard(
                                    icon: "brain",
                                    title: "Inteligente",
                                    description: "IA que aprende contigo"
                                )
                                
                                FeaturePreviewCard(
                                    icon: "chart.line.uptrend.xyaxis",
                                    title: "Progresivo",
                                    description: "Evoluciona contigo"
                                )
                            }
                        }
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 40)
                        .animation(.easeOut(duration: 0.6).delay(1.0), value: showContent)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                    
                    // Action Button
                    VStack(spacing: 16) {
                        Button(action: {
                            coordinator.beginAssessmentQuestions()
                        }) {
                            HStack(spacing: 12) {
                                Text("Comenzar Assessment")
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
                                        Color(hex: 0x1A5A53),
                                        Color(hex: 0x1A5A53).opacity(0.8)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color(hex: 0x1A5A53).opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .scaleEffect(showContent ? 1.0 : 0.9)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(1.2), value: showContent)
                        
                        Text("Aproximadamente 3 minutos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .opacity(showContent ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(1.4), value: showContent)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            showContent = true
        }
    }
}

// MARK: - Feature Preview Card
struct FeaturePreviewCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: 0x1A5A53))
                .frame(height: 24)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Preview
#Preview {
    AssessmentWelcomePage(coordinator: AppCoordinator())
}
