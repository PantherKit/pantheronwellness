import SwiftUI

struct HomePage: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.green)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .animation(.spring(response: 1.0, dampingFraction: 0.6), value: showContent)
                
                // Welcome Message
                VStack(spacing: 16) {
                    Text("¡Bienvenido a tu Wellness!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                    
                    Text("Tu assessment ha sido completado.\nPronto añadiremos más funcionalidades increíbles.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.5), value: showContent)
                }
                
                Spacer()
                
                // Assessment Info
                if let assessment = coordinator.currentAssessment {
                    VStack(spacing: 12) {
                        Text("Assessment Completado")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Puntaje: \(Int(assessment.overallScore))%")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text("Dimensiones recomendadas: \(assessment.recommendedDimensions.count)")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))
                    )
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(0.7), value: showContent)
                }
                
                Spacer()
            }
            .padding(.horizontal, 32)
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
