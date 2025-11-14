import SwiftUI

struct AssessmentResultsPage: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var showContent = false
    @State private var showPersonality = false
    @State private var showInsights = false
    @State private var showRecommendations = false
    
    private var assessment: WellnessAssessment? {
        coordinator.currentAssessment
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 20) {
                        // Celebration Animation
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: 0xB6E2D3).opacity(0.3),
                                            Color(hex: 0x1A5A53).opacity(0.1)
                                        ]),
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(showContent ? 1.0 : 0.5)
                                .animation(.spring(response: 1.0, dampingFraction: 0.6), value: showContent)
                            
                            Text(assessment?.personalityType.emoji ?? "✨")
                                .font(.system(size: 48))
                                .scaleEffect(showContent ? 1.0 : 0.1)
                                .animation(.spring(response: 1.2, dampingFraction: 0.6).delay(0.3), value: showContent)
                        }
                        
                        VStack(spacing: 12) {
                            Text("¡Tu Perfil Wellness!")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .opacity(showPersonality ? 1 : 0)
                                .offset(y: showPersonality ? 0 : 20)
                                .animation(.easeOut(duration: 0.6).delay(0.5), value: showPersonality)
                            
                            Text("Basado en tus respuestas, hemos creado tu perfil personalizado")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .opacity(showPersonality ? 1 : 0)
                                .offset(y: showPersonality ? 0 : 20)
                                .animation(.easeOut(duration: 0.6).delay(0.7), value: showPersonality)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    
                    // Overall Score
                    if let assessment = assessment {
                        VStack(spacing: 16) {
                            Text("Tu Puntaje Wellness")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                                    .frame(width: 120, height: 120)
                                
                                Circle()
                                    .trim(from: 0, to: showContent ? assessment.overallScore / 100.0 : 0)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex: 0x1A5A53),
                                                Color(hex: 0xB6E2D3)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeInOut(duration: 1.5).delay(0.8), value: showContent)
                                
                                Text("\(Int(assessment.overallScore))")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: 0x1A5A53))
                            }
                        }
                        .opacity(showPersonality ? 1 : 0)
                        .scaleEffect(showPersonality ? 1.0 : 0.8)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.9), value: showPersonality)
                    }
                    
                    // Personality Type Card
                    if let assessment = assessment {
                        PersonalityTypeCard(personalityType: assessment.personalityType)
                            .opacity(showPersonality ? 1 : 0)
                            .offset(y: showPersonality ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(1.1), value: showPersonality)
                    }
                    
                    // Insights Section
                    if let assessment = assessment {
                        VStack(spacing: 20) {
                            Text("Tus Insights Personalizados")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .opacity(showInsights ? 1 : 0)
                                .animation(.easeOut(duration: 0.4).delay(1.3), value: showInsights)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(Array(assessment.getInsights().enumerated()), id: \.element.id) { index, insight in
                                    InsightCard(insight: insight)
                                        .opacity(showInsights ? 1 : 0)
                                        .offset(y: showInsights ? 0 : 20)
                                        .animation(.easeOut(duration: 0.4).delay(1.5 + Double(index) * 0.1), value: showInsights)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Recommended Dimensions
                    if let assessment = assessment {
                        VStack(spacing: 20) {
                            Text("Dimensiones Recomendadas")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .opacity(showRecommendations ? 1 : 0)
                                .animation(.easeOut(duration: 0.4).delay(1.8), value: showRecommendations)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                                ForEach(Array(assessment.recommendedDimensions.enumerated()), id: \.element) { index, dimension in
                                    RecommendedDimensionCard(
                                        dimension: dimension,
                                        priority: index + 1
                                    )
                                    .opacity(showRecommendations ? 1 : 0)
                                    .scaleEffect(showRecommendations ? 1.0 : 0.8)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(2.0 + Double(index) * 0.1), value: showRecommendations)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // Action Button
                    Button(action: {
                        coordinator.navigateToIdentitySelection()
                    }) {
                        HStack(spacing: 12) {
                            Text("Crear mi Plan Personalizado")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Image(systemName: "sparkles")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: 0x1A5A53),
                                    Color(hex: 0xB6E2D3)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color(hex: 0x1A5A53).opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 32)
                    .opacity(showRecommendations ? 1 : 0)
                    .scaleEffect(showRecommendations ? 1.0 : 0.9)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(2.5), value: showRecommendations)
                    
                    // Bottom Spacing
                    Color.clear.frame(height: 40)
                }
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showContent = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showPersonality = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                showInsights = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                showRecommendations = true
            }
        }
    }
}

// MARK: - Personality Type Card
struct PersonalityTypeCard: View {
    let personalityType: WellnessPersonalityType
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Text(personalityType.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(personalityType.displayName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Tu tipo de personalidad wellness")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Text(personalityType.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.orange)
                
                Text(personalityType.primaryRecommendation)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: 0x1A5A53).opacity(0.3),
                                    Color(hex: 0xB6E2D3).opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .padding(.horizontal, 24)
    }
}

// MARK: - Insight Card
struct InsightCard: View {
    let insight: AssessmentInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: iconFor(insight.type))
                    .foregroundColor(colorFor(insight.type))
                    .font(.title3)
                
                Text(insight.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(insight.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            Text(insight.recommendation)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(colorFor(insight.type))
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private func iconFor(_ type: InsightType) -> String {
        switch type {
        case .personality: return "person.crop.circle.fill"
        case .strength: return "star.fill"
        case .opportunity: return "target"
        case .balance: return "scale.3d"
        }
    }
    
    private func colorFor(_ type: InsightType) -> Color {
        switch type {
        case .personality: return Color(hex: 0x1A5A53)
        case .strength: return .green
        case .opportunity: return .orange
        case .balance: return Color(hex: 0xB6E2D3)
        }
    }
}

// MARK: - Recommended Dimension Card
struct RecommendedDimensionCard: View {
    let dimension: WellnessDimension
    let priority: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("#\(priority)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(Circle().fill(dimension.primaryColor))
                
                Spacer()
                
                Image(systemName: dimension.iconName)
                    .font(.title2)
                    .foregroundColor(dimension.primaryColor)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(dimension.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text("Prioridad \(priority == 1 ? "alta" : priority == 2 ? "media" : "baja")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .frame(height: 100)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(dimension.primaryColor.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(dimension.primaryColor.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    AssessmentResultsPage(coordinator: AppCoordinator())
}
