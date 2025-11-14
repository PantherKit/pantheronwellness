import Foundation

// MARK: - Wellness Assessment
struct WellnessAssessment: Codable, Identifiable {
    let id: UUID
    let completedAt: Date
    let responses: [WellnessDimension: AssessmentResponse]
    
    init() {
        self.id = UUID()
        self.completedAt = Date()
        self.responses = [:]
    }
    
    init(responses: [WellnessDimension: AssessmentResponse]) {
        self.id = UUID()
        self.completedAt = Date()
        self.responses = responses
    }
    
    var overallScore: Double {
        let totalScore = responses.values.reduce(0) { $0 + $1.score }
        return Double(totalScore) / Double(responses.count) / 5.0 * 100.0
    }
    
    var recommendedDimensions: [WellnessDimension] {
        let sortedByScore = responses.sorted { $0.value.score < $1.value.score }
        return Array(sortedByScore.prefix(3).map { $0.key })
    }
    
    var personalityType: WellnessPersonalityType {
        let scores = responses.mapValues { $0.score }
        
        let physicalScore = scores[.physical] ?? 3
        let professionalScore = scores[.professional] ?? 3
        let socialScore = scores[.social] ?? 3
        let emotionalScore = scores[.emotional] ?? 3
        let spiritualScore = scores[.spiritual] ?? 3
        let mentalScore = scores[.mental] ?? 3
        
        let achieverScore = physicalScore + professionalScore
        let nurturerScore = socialScore + emotionalScore
        let seekerScore = spiritualScore + mentalScore
        
        if achieverScore >= nurturerScore && achieverScore >= seekerScore {
            return .achiever
        } else if nurturerScore >= seekerScore {
            return .nurturer
        } else {
            return .seeker
        }
    }
    
    func getInsights() -> [AssessmentInsight] {
        var insights: [AssessmentInsight] = []
        
        // Insight basado en personalidad
        insights.append(AssessmentInsight(
            type: .personality,
            title: personalityType.displayName,
            description: personalityType.description,
            recommendation: personalityType.primaryRecommendation
        ))
        
        // Insight de fortaleza
        if let strongestDimension = responses.max(by: { $0.value.score < $1.value.score }) {
            insights.append(AssessmentInsight(
                type: .strength,
                title: "Tu fortaleza: \(strongestDimension.key.displayName)",
                description: "Tienes una base sólida en esta dimensión.",
                recommendation: "Usa esta fortaleza para construir otras áreas."
            ))
        }
        
        // Insight de oportunidad
        if let weakestDimension = responses.min(by: { $0.value.score < $1.value.score }) {
            insights.append(AssessmentInsight(
                type: .opportunity,
                title: "Oportunidad: \(weakestDimension.key.displayName)",
                description: "Esta área tiene el mayor potencial de crecimiento.",
                recommendation: "Enfócate aquí para ver cambios significativos."
            ))
        }
        
        return insights
    }
}

// MARK: - Assessment Response
struct AssessmentResponse: Codable {
    let dimension: WellnessDimension
    let score: Int // 1-5
    let confidence: Double // 0.0-1.0
    let answeredAt: Date
    
    init(dimension: WellnessDimension, score: Int) {
        self.dimension = dimension
        self.score = score
        self.confidence = 1.0 // Para MVP, siempre alta confianza
        self.answeredAt = Date()
    }
}

// MARK: - Assessment Insight
struct AssessmentInsight: Codable, Identifiable {
    let id: UUID
    let type: InsightType
    let title: String
    let description: String
    let recommendation: String
    
    init(type: InsightType, title: String, description: String, recommendation: String) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.description = description
        self.recommendation = recommendation
    }
}

enum InsightType: String, Codable {
    case personality = "personality"
    case strength = "strength"
    case opportunity = "opportunity"
    case balance = "balance"
}

// MARK: - Wellness Personality Types
enum WellnessPersonalityType: String, CaseIterable, Codable {
    case achiever = "achiever"
    case nurturer = "nurturer"
    case seeker = "seeker"
    case creator = "creator"
    
    var displayName: String {
        switch self {
        case .achiever: return "El Conquistador"
        case .nurturer: return "El Cuidador"
        case .seeker: return "El Explorador"
        case .creator: return "El Creativo"
        }
    }
    
    var description: String {
        switch self {
        case .achiever:
            return "Te enfocas en el crecimiento físico y profesional. Eres orientado a resultados y disfrutas los desafíos."
        case .nurturer:
            return "Priorizas las conexiones emocionales y sociales. Cuidas tanto de ti como de otros."
        case .seeker:
            return "Buscas significado profundo y tranquilidad mental. La espiritualidad y mindfulness son importantes."
        case .creator:
            return "Tienes un enfoque balanceado y adaptable. Te gusta experimentar con diferentes aspectos del bienestar."
        }
    }
    
    var primaryRecommendation: String {
        switch self {
        case .achiever:
            return "Comienza con identidades físicas o profesionales para aprovechar tu motivación natural."
        case .nurturer:
            return "Enfócate en identidades emocionales y sociales para potenciar tu naturaleza cuidadora."
        case .seeker:
            return "Inicia con identidades mentales y espirituales para alinear con tu búsqueda interior."
        case .creator:
            return "Experimenta con diferentes identidades cada semana para mantener variedad."
        }
    }
    
    var emoji: String {
        switch self {
        case .achiever: return "🏆"
        case .nurturer: return "💝"
        case .seeker: return "🧭"
        case .creator: return "🎨"
        }
    }
}
