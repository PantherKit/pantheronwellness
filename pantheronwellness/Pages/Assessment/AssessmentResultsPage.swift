import SwiftUI

struct AssessmentResultsPage: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    
    private var assessment: WellnessAssessment? {
        coordinator.currentAssessment
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)
                
                // Title
                Text("¡Assessment Completado!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                
                // Score Display
                if let assessment = assessment {
                    VStack(spacing: 16) {
                        Text("Tu Puntaje General")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(Int(assessment.overallScore))%")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        // Recommended Dimensions
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dimensiones Recomendadas:")
                                .font(.headline)
                            
                            ForEach(assessment.recommendedDimensions, id: \.self) { dimension in
                                Text("• \(dimension.displayName)")
                                    .font(.body)
                            }
                        }
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                } else {
                    Text("Error: No assessment data found")
                        .font(.title2)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    coordinator.navigateToIdentitySelection()
                }) {
                    HStack {
                        Text("Continuar")
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
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.9), value: showContent)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 50)
        }
        .onAppear {
            print("🔥 DEBUG: AssessmentResultsPage appeared")
            print("🔥 DEBUG: Assessment data: \(assessment != nil ? "Found" : "Missing")")
            if let assessment = assessment {
                print("🔥 DEBUG: Overall score: \(assessment.overallScore)")
                print("🔥 DEBUG: Recommended dimensions: \(assessment.recommendedDimensions.map { $0.displayName })")
            }
            showContent = true
        }
    }
}
