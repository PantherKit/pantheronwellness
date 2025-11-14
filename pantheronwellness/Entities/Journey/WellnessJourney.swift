import Foundation

// MARK: - Wellness Journey
struct WellnessJourney: Codable, Identifiable {
    let id: UUID
    let userAssessment: WellnessAssessment
    let phases: [JourneyPhase]
    var currentPhaseIndex: Int
    let startDate: Date
    let personalityType: WellnessPersonalityType
    
    init(assessment: WellnessAssessment) {
        self.id = UUID()
        self.userAssessment = assessment
        self.personalityType = assessment.personalityType
        self.currentPhaseIndex = 0
        self.startDate = Date()
        self.phases = JourneyPhase.createPersonalizedPhases(for: assessment)
    }
    
    var currentPhase: JourneyPhase? {
        guard currentPhaseIndex < phases.count else { return nil }
        return phases[currentPhaseIndex]
    }
    
    var nextPhase: JourneyPhase? {
        guard currentPhaseIndex + 1 < phases.count else { return nil }
        return phases[currentPhaseIndex + 1]
    }
    
    var progressPercentage: Double {
        guard !phases.isEmpty else { return 0 }
        return Double(currentPhaseIndex) / Double(phases.count) * 100
    }
    
    var totalDuration: TimeInterval {
        return phases.reduce(0) { $0 + $1.duration }
    }
    
    mutating func advanceToNextPhase() -> Bool {
        if currentPhaseIndex + 1 < phases.count {
            currentPhaseIndex += 1
            return true
        }
        return false
    }
    
    func getCurrentGoals() -> [WellnessGoal] {
        return currentPhase?.goals ?? []
    }
    
    func getNextMilestone() -> JourneyMilestone? {
        return currentPhase?.milestone
    }
}

// MARK: - Journey Phase
struct JourneyPhase: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let duration: TimeInterval // En días
    let focusDimensions: [WellnessDimension]
    let goals: [WellnessGoal]
    let milestone: JourneyMilestone
    let requiredEvidences: Int
    
    init(name: String, description: String, duration: TimeInterval, focusDimensions: [WellnessDimension], goals: [WellnessGoal], milestone: JourneyMilestone, requiredEvidences: Int = 7) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.duration = duration
        self.focusDimensions = focusDimensions
        self.goals = goals
        self.milestone = milestone
        self.requiredEvidences = requiredEvidences
    }
    
    static func createPersonalizedPhases(for assessment: WellnessAssessment) -> [JourneyPhase] {
        let recommendedDimensions = assessment.recommendedDimensions
        let personalityType = assessment.personalityType
        
        var phases: [JourneyPhase] = []
        
        // Fase 1: Construcción de Base (Semana 1-2)
        let primaryDimension = recommendedDimensions.first ?? .physical
        phases.append(JourneyPhase(
            name: "Construir Base",
            description: "Establece tu primera identidad wellness de forma consistente",
            duration: 14, // 14 días
            focusDimensions: [primaryDimension],
            goals: [
                WellnessGoal(
                    title: "Identidad \(primaryDimension.displayName)",
                    description: "Completa 10 micro-acciones en esta dimensión",
                    targetValue: 10,
                    currentValue: 0,
                    dimension: primaryDimension
                )
            ],
            milestone: JourneyMilestone(
                title: "Primera Identidad Activada",
                description: "Has comenzado a instalar tu nueva identidad",
                celebrationMessage: "¡Increíble! Ya no eres quien eras hace 2 semanas.",
                unlockedFeatures: ["Nivel Building desbloqueado"]
            ),
            requiredEvidences: 10
        ))
        
        // Fase 2: Profundización (Semana 3-4)
        let secondaryDimension = recommendedDimensions.count > 1 ? recommendedDimensions[1] : .emotional
        phases.append(JourneyPhase(
            name: "Profundizar Identidad",
            description: "Expande tu práctica y añade una segunda dimensión",
            duration: 14,
            focusDimensions: [primaryDimension, secondaryDimension],
            goals: [
                WellnessGoal(
                    title: "Maestría \(primaryDimension.displayName)",
                    description: "Alcanza nivel Building en tu dimensión principal",
                    targetValue: 7,
                    currentValue: 0,
                    dimension: primaryDimension
                ),
                WellnessGoal(
                    title: "Nueva Dimensión",
                    description: "Inicia práctica en \(secondaryDimension.displayName)",
                    targetValue: 5,
                    currentValue: 0,
                    dimension: secondaryDimension
                )
            ],
            milestone: JourneyMilestone(
                title: "Identidad Dual",
                description: "Tienes dos identidades wellness activas",
                celebrationMessage: "Tu transformación se está acelerando. Eres multidimensional.",
                unlockedFeatures: ["Micro-acciones avanzadas", "Insights personalizados"]
            )
        ))
        
        // Fase 3: Integración (Semana 5-6)
        let tertiaryDimension = recommendedDimensions.count > 2 ? recommendedDimensions[2] : .mental
        phases.append(JourneyPhase(
            name: "Integración Holística",
            description: "Balancea múltiples dimensiones hacia la plenitud",
            duration: 14,
            focusDimensions: [primaryDimension, secondaryDimension, tertiaryDimension],
            goals: [
                WellnessGoal(
                    title: "Balance Triplex",
                    description: "Mantén actividad en 3 dimensiones simultáneas",
                    targetValue: 15,
                    currentValue: 0,
                    dimension: nil // Goal multi-dimensional
                )
            ],
            milestone: JourneyMilestone(
                title: "Ser Integral",
                description: "Has integrado múltiples aspectos de tu bienestar",
                celebrationMessage: "Ya no practicas wellness. ERES wellness.",
                unlockedFeatures: ["Modo libre", "Creador de micro-acciones", "Mentor mode"]
            )
        ))
        
        // Fase 4: Maestría (Semana 7+)
        phases.append(JourneyPhase(
            name: "Maestría Personal",
            description: "Crea tu propio sistema de bienestar sostenible",
            duration: 28,
            focusDimensions: WellnessDimension.allCases,
            goals: [
                WellnessGoal(
                    title: "Arquitecto del Bienestar",
                    description: "Diseña tu rutina de plenitud personalizada",
                    targetValue: 30,
                    currentValue: 0,
                    dimension: nil
                )
            ],
            milestone: JourneyMilestone(
                title: "Maestro Wellness",
                description: "Has creado un sistema de bienestar único y sostenible",
                celebrationMessage: "Eres un ejemplo viviente de transformación consciente.",
                unlockedFeatures: ["Compartir journey", "Mentoría a otros", "API personalizada"]
            )
        ))
        
        return phases
    }
}

// MARK: - Wellness Goal
struct WellnessGoal: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let targetValue: Int
    var currentValue: Int
    let dimension: WellnessDimension?
    let createdAt: Date
    
    init(title: String, description: String, targetValue: Int, currentValue: Int = 0, dimension: WellnessDimension? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.targetValue = targetValue
        self.currentValue = currentValue
        self.dimension = dimension
        self.createdAt = Date()
    }
    
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return Double(currentValue) / Double(targetValue)
    }
    
    var isCompleted: Bool {
        return currentValue >= targetValue
    }
}

// MARK: - Journey Milestone
struct JourneyMilestone: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let celebrationMessage: String
    let unlockedFeatures: [String]
    let earnedAt: Date?
    
    init(title: String, description: String, celebrationMessage: String, unlockedFeatures: [String] = [], earnedAt: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.celebrationMessage = celebrationMessage
        self.unlockedFeatures = unlockedFeatures
        self.earnedAt = earnedAt
    }
    
    var isEarned: Bool {
        return earnedAt != nil
    }
}
