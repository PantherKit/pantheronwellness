import Foundation
import Combine

// MARK: - Personalization Service
@MainActor
class PersonalizationService: ObservableObject {
    @Published var isPersonalizing: Bool = false
    @Published var currentJourney: WellnessJourney?
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Public Methods
    
    func generatePersonalizedJourney(from assessment: WellnessAssessment) async -> WellnessJourney {
        isPersonalizing = true
        
        // Simular procesamiento de IA (para demo)
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        
        let journey = WellnessJourney(assessment: assessment)
        currentJourney = journey
        saveJourney(journey)
        
        isPersonalizing = false
        return journey
    }
    
    func adaptMicroAction(for dimension: WellnessDimension, user: UserProfile) -> AdaptiveMicroAction {
        let identity = user.identities[dimension] ?? Identity(dimension: dimension)
        let level = calculateActionLevel(for: identity, user: user)
        let contextualFactors = getContextualFactors()
        
        return createAdaptedAction(
            dimension: dimension,
            level: level,
            context: contextualFactors,
            personalityType: currentJourney?.personalityType ?? .creator
        )
    }
    
    func calculateOptimalProgression(user: UserProfile) -> ProgressionPlan {
        guard let journey = currentJourney else {
            return ProgressionPlan.default()
        }
        
        let currentPhase = journey.currentPhase
        let userEvidences = user.totalEvidences
        let daysSinceStart = Calendar.current.dateComponents([.day], from: journey.startDate, to: Date()).day ?? 0
        
        return ProgressionPlan(
            currentPhase: currentPhase?.name ?? "Inicio",
            recommendedDimensions: getRecommendedDimensions(user: user, journey: journey),
            nextMilestone: journey.getNextMilestone(),
            estimatedTimeToNextPhase: calculateTimeToNextPhase(user: user, journey: journey),
            adaptationSuggestions: getAdaptationSuggestions(user: user, journey: journey)
        )
    }
    
    func getContextualNudge(time: Date, user: UserProfile) -> MotivationalNudge? {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let weekday = calendar.component(.weekday, from: time)
        
        // Lógica contextual basada en tiempo y patrones del usuario
        if hour < 10 {
            return createMorningNudge(user: user)
        } else if hour > 18 {
            return createEveningNudge(user: user)
        } else if weekday == 1 || weekday == 7 { // Fin de semana
            return createWeekendNudge(user: user)
        }
        
        return nil
    }
    
    // MARK: - Private Methods
    
    private func calculateActionLevel(for identity: Identity, user: UserProfile) -> ActionLevel {
        let evidenceCount = identity.evidenceCount
        let consistency = calculateConsistency(for: identity)
        let timeOfDay = getTimeOfDayFactor()
        
        // Lógica adaptativa inteligente
        switch identity.level {
        case .beginner:
            return consistency > 0.7 ? .mini : .micro
        case .building:
            return consistency > 0.8 ? .standard : .mini
        case .established:
            return consistency > 0.9 ? .extended : .standard
        }
    }
    
    private func calculateConsistency(for identity: Identity) -> Double {
        // Calcular consistencia basada en racha y frecuencia
        let streakFactor = min(Double(identity.currentStreak) / 7.0, 1.0)
        let frequencyFactor = identity.evidenceCount > 0 ? 0.8 : 0.3
        
        return (streakFactor + frequencyFactor) / 2.0
    }
    
    private func getTimeOfDayFactor() -> Double {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6...9: return 1.0    // Mañana - energía alta
        case 10...14: return 0.8  // Media mañana - energía media
        case 15...18: return 0.6  // Tarde - energía descendente
        case 19...22: return 0.4  // Noche - energía baja
        default: return 0.2       // Madrugada - energía mínima
        }
    }
    
    private func getContextualFactors() -> ContextualFactors {
        let calendar = Calendar.current
        let now = Date()
        
        return ContextualFactors(
            timeOfDay: getTimeOfDay(from: now),
            dayOfWeek: calendar.component(.weekday, from: now),
            energyLevel: getTimeOfDayFactor(),
            isWeekend: isWeekend(date: now)
        )
    }
    
    private func getTimeOfDay(from date: Date) -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 5...11: return .morning
        case 12...17: return .afternoon
        case 18...22: return .evening
        default: return .night
        }
    }
    
    private func createAdaptedAction(
        dimension: WellnessDimension,
        level: ActionLevel,
        context: ContextualFactors,
        personalityType: WellnessPersonalityType
    ) -> AdaptiveMicroAction {
        
        let baseAction = dimension.microAction
        let adaptedInstructions = adaptInstructions(
            base: baseAction,
            level: level,
            context: context,
            personalityType: personalityType
        )
        
        return AdaptiveMicroAction(
            dimension: dimension,
            level: level,
            title: generateAdaptedTitle(dimension: dimension, level: level, context: context),
            description: adaptedInstructions,
            estimatedDuration: level.estimatedDuration,
            instructions: generateStepByStepInstructions(dimension: dimension, level: level),
            contextualVariations: generateContextualVariations(dimension: dimension),
            personalityAdaptation: generatePersonalityAdaptation(dimension: dimension, personalityType: personalityType)
        )
    }
    
    private func adaptInstructions(
        base: String,
        level: ActionLevel,
        context: ContextualFactors,
        personalityType: WellnessPersonalityType
    ) -> String {
        
        var adapted = base
        
        // Adaptar por nivel
        switch level {
        case .micro:
            adapted = adapted.replacingOccurrences(of: "2 minutos", with: "30 segundos")
        case .mini:
            adapted = adapted.replacingOccurrences(of: "2 minutos", with: "1 minuto")
        case .standard:
            break // Mantener original
        case .extended:
            adapted = adapted.replacingOccurrences(of: "2 minutos", with: "3-4 minutos")
        }
        
        // Adaptar por contexto temporal
        if context.timeOfDay == .evening {
            adapted += " Perfecto para relajarte antes de dormir."
        } else if context.timeOfDay == .morning {
            adapted += " Ideal para energizarte para el día."
        }
        
        // Adaptar por personalidad
        switch personalityType {
        case .achiever:
            adapted += " ¡Vas por buen camino hacia tu meta!"
        case .nurturer:
            adapted += " Cuídate con amor y compasión."
        case .seeker:
            adapted += " Conecta con tu propósito interior."
        case .creator:
            adapted += " Experimenta y haz tuya esta práctica."
        }
        
        return adapted
    }
    
    // MARK: - Nudges and Recommendations
    
    private func createMorningNudge(user: UserProfile) -> MotivationalNudge? {
        let dominantDimension = user.dominantIdentity ?? .physical
        let greeting = user.name.isEmpty ? "Buenos días" : "Buenos días, \(user.name)"
        
        return MotivationalNudge(
            message: "\(greeting). ¿Listo para ser alguien que \(dominantDimension.identityStatement.lowercased())?",
            actionSuggestion: "Una micro-acción de \(dominantDimension.displayName.lowercased()) te tomará solo 1 minuto.",
            urgency: .low,
            type: .encouragement
        )
    }
    
    private func createEveningNudge(user: UserProfile) -> MotivationalNudge? {
        // Verificar si ya completó algo hoy
        let hasCompletedToday = checkIfCompletedToday(user: user)
        
        if hasCompletedToday {
            let message = user.name.isEmpty 
                ? "Excelente trabajo hoy. Tu identidad se está fortaleciendo."
                : "Excelente trabajo hoy, \(user.name). Tu identidad se está fortaleciendo."
            
            return MotivationalNudge(
                message: message,
                actionSuggestion: "Toma un momento para reconocer tu progreso.",
                urgency: .none,
                type: .celebration
            )
        } else {
            return MotivationalNudge(
                message: "Aún tienes tiempo para una micro-acción antes de dormir.",
                actionSuggestion: "Algo suave como gratitud o respiración consciente.",
                urgency: .medium,
                type: .gentle_reminder
            )
        }
    }
    
    private func createWeekendNudge(user: UserProfile) -> MotivationalNudge? {
        return MotivationalNudge(
            message: "Los fines de semana son perfectos para explorar nuevas dimensiones.",
            actionSuggestion: "¿Qué tal algo en \(getUnexploredDimension(user: user)?.displayName.lowercased() ?? "una nueva área")?",
            urgency: .low,
            type: .exploration
        )
    }
    
    // MARK: - Helper Methods
    
    private func getRecommendedDimensions(user: UserProfile, journey: WellnessJourney) -> [WellnessDimension] {
        guard let currentPhase = journey.currentPhase else {
            return journey.userAssessment.recommendedDimensions
        }
        
        return currentPhase.focusDimensions
    }
    
    private func calculateTimeToNextPhase(user: UserProfile, journey: WellnessJourney) -> TimeInterval {
        guard let currentPhase = journey.currentPhase else { return 0 }
        
        let userProgress = user.totalEvidences
        let required = currentPhase.requiredEvidences
        let remaining = max(0, required - userProgress)
        
        // Estimar basado en consistencia actual
        let averageDailyProgress = calculateAverageDailyProgress(user: user)
        return Double(remaining) / max(averageDailyProgress, 0.5) * 86400 // Convertir a segundos
    }
    
    private func calculateAverageDailyProgress(user: UserProfile) -> Double {
        let daysSinceStart = Calendar.current.dateComponents([.day], from: user.startDate, to: Date()).day ?? 1
        return Double(user.totalEvidences) / Double(max(daysSinceStart, 1))
    }
    
    private func getAdaptationSuggestions(user: UserProfile, journey: WellnessJourney) -> [String] {
        var suggestions: [String] = []
        
        // Analizar patrones y sugerir adaptaciones
        if calculateAverageDailyProgress(user: user) < 0.5 {
            suggestions.append("Considera micro-acciones más simples para mantener consistencia")
        }
        
        if user.activeDaysCount < 3 {
            suggestions.append("Intenta establecer un horario fijo para tus micro-acciones")
        }
        
        return suggestions
    }
    
    private func checkIfCompletedToday(user: UserProfile) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        
        for identity in user.identities.values {
            if let lastEvidence = identity.lastEvidenceDate {
                let lastEvidenceDay = Calendar.current.startOfDay(for: lastEvidence)
                if lastEvidenceDay == today {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func getUnexploredDimension(user: UserProfile) -> WellnessDimension? {
        let leastUsedDimension = user.identities.min { $0.value.evidenceCount < $1.value.evidenceCount }
        return leastUsedDimension?.key
    }
    
    // MARK: - Persistence
    
    private func saveJourney(_ journey: WellnessJourney) {
        do {
            let data = try JSONEncoder().encode(journey)
            userDefaults.set(data, forKey: "wellness_journey")
        } catch {
            print("Error saving journey: \(error)")
        }
    }
    
    func loadJourney() -> WellnessJourney? {
        guard let data = userDefaults.data(forKey: "wellness_journey") else { return nil }
        
        do {
            return try JSONDecoder().decode(WellnessJourney.self, from: data)
        } catch {
            print("Error loading journey: \(error)")
            return nil
        }
    }
    
    // MARK: - Weekend Helper
    private func isWeekend(date: Date) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        return weekday == 1 || weekday == 7 // Sunday = 1, Saturday = 7
    }
}

// MARK: - Supporting Types

struct ContextualFactors {
    let timeOfDay: TimeOfDay
    let dayOfWeek: Int
    let energyLevel: Double
    let isWeekend: Bool
}

enum TimeOfDay: String, CaseIterable, Codable {
    case morning = "morning"
    case afternoon = "afternoon" 
    case evening = "evening"
    case night = "night"
}

struct MotivationalNudge: Identifiable {
    let id = UUID()
    let message: String
    let actionSuggestion: String
    let urgency: NudgeUrgency
    let type: NudgeType
}

enum NudgeUrgency {
    case none, low, medium, high
}

enum NudgeType {
    case encouragement, gentle_reminder, celebration, exploration
}

struct ProgressionPlan {
    let currentPhase: String
    let recommendedDimensions: [WellnessDimension]
    let nextMilestone: JourneyMilestone?
    let estimatedTimeToNextPhase: TimeInterval
    let adaptationSuggestions: [String]
    
    static func `default`() -> ProgressionPlan {
        return ProgressionPlan(
            currentPhase: "Preparación",
            recommendedDimensions: [.physical, .emotional],
            nextMilestone: nil,
            estimatedTimeToNextPhase: 604800, // 1 semana
            adaptationSuggestions: ["Completa tu assessment para obtener recomendaciones personalizadas"]
        )
    }
}
