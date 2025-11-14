import Foundation

// MARK: - Adaptive Micro Action
struct AdaptiveMicroAction: Codable, Identifiable {
    let id: UUID
    let dimension: WellnessDimension
    let level: ActionLevel
    let title: String
    let description: String
    let estimatedDuration: TimeInterval
    let instructions: [String]
    let contextualVariations: [TimeOfDay: String]
    let personalityAdaptation: String
    let createdAt: Date
    
    init(
        dimension: WellnessDimension,
        level: ActionLevel,
        title: String,
        description: String,
        estimatedDuration: TimeInterval,
        instructions: [String],
        contextualVariations: [TimeOfDay: String] = [:],
        personalityAdaptation: String = ""
    ) {
        self.id = UUID()
        self.dimension = dimension
        self.level = level
        self.title = title
        self.description = description
        self.estimatedDuration = estimatedDuration
        self.instructions = instructions
        self.contextualVariations = contextualVariations
        self.personalityAdaptation = personalityAdaptation
        self.createdAt = Date()
    }
    
    func getContextualDescription(for timeOfDay: TimeOfDay) -> String {
        return contextualVariations[timeOfDay] ?? description
    }
    
    var formattedDuration: String {
        let minutes = Int(estimatedDuration / 60)
        let seconds = Int(estimatedDuration.truncatingRemainder(dividingBy: 60))
        
        if minutes > 0 {
            return seconds > 0 ? "\(minutes)m \(seconds)s" : "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}

// MARK: - Action Level
enum ActionLevel: String, CaseIterable, Codable {
    case micro = "micro"         // 30-60 sec
    case mini = "mini"           // 1-2 min  
    case standard = "standard"   // 2-3 min
    case extended = "extended"   // 3-5 min
    
    var displayName: String {
        switch self {
        case .micro: return "Micro"
        case .mini: return "Mini"
        case .standard: return "Estándar"
        case .extended: return "Extendida"
        }
    }
    
    var estimatedDuration: TimeInterval {
        switch self {
        case .micro: return 45      // 45 segundos
        case .mini: return 90       // 1.5 minutos
        case .standard: return 150  // 2.5 minutos
        case .extended: return 270  // 4.5 minutos
        }
    }
    
    var emoji: String {
        switch self {
        case .micro: return "⚡"
        case .mini: return "🔥"
        case .standard: return "💪"
        case .extended: return "🚀"
        }
    }
}

// MARK: - Wellness Dimension Extensions for Adaptive Actions
extension WellnessDimension {
    func microAction(for level: ActionLevel) -> String {
        switch self {
        case .physical:
            return getPhysicalAction(for: level)
        case .emotional:
            return getEmotionalAction(for: level)
        case .mental:
            return getMentalAction(for: level)
        case .social:
            return getSocialAction(for: level)
        case .spiritual:
            return getSpiritualAction(for: level)
        case .professional:
            return getProfessionalAction(for: level)
        case .environmental:
            return getEnvironmentalAction(for: level)
        }
    }
    
    private func getPhysicalAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Estira los brazos hacia arriba por 30 segundos"
        case .mini:
            return "Haz 5 respiraciones profundas mientras caminas en tu lugar"
        case .standard:
            return "Realiza una secuencia de 3 estiramientos por 2 minutos"
        case .extended:
            return "Completa una rutina de movimiento consciente de 4 minutos"
        }
    }
    
    private func getEmotionalAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Nombra una emoción que sientes ahora mismo"
        case .mini:
            return "Escribe en una frase cómo te sientes y por qué"
        case .standard:
            return "Reflexiona sobre una emoción reciente y su mensaje"
        case .extended:
            return "Explora una emoción compleja a través de escritura libre"
        }
    }
    
    private func getMentalAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Haz 3 respiraciones 4-4-4 (inhalar-retener-exhalar)"
        case .mini:
            return "Practica respiración consciente por 90 segundos"
        case .standard:
            return "Medita con atención a la respiración por 2-3 minutos"
        case .extended:
            return "Sesión de mindfulness completa con body scan"
        }
    }
    
    private func getSocialAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Envía un emoji de cariño a alguien importante"
        case .mini:
            return "Escribe un mensaje genuino de agradecimiento"
        case .standard:
            return "Llama a alguien para conectar auténticamente"
        case .extended:
            return "Planifica una actividad significativa con un ser querido"
        }
    }
    
    private func getSpiritualAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Piensa en algo por lo que te sientes agradecido"
        case .mini:
            return "Anota una cosa que te da sentido de propósito"
        case .standard:
            return "Reflexiona sobre tu conexión con algo más grande"
        case .extended:
            return "Practica contemplación sobre tus valores más profundos"
        }
    }
    
    private func getProfessionalAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Identifica una cosa nueva que aprendiste hoy"
        case .mini:
            return "Anota un insight o lección del día"
        case .standard:
            return "Planifica un pequeño paso hacia un objetivo profesional"
        case .extended:
            return "Reflexiona sobre tu crecimiento y próximos desafíos"
        }
    }
    
    private func getEnvironmentalAction(for level: ActionLevel) -> String {
        switch level {
        case .micro:
            return "Ordena un espacio del tamaño de tu mano"
        case .mini:
            return "Organiza tu escritorio o área de trabajo"
        case .standard:
            return "Crea orden en un espacio de tu hogar"
        case .extended:
            return "Diseña un ambiente que nutra tu bienestar"
        }
    }
}

// MARK: - Instruction Generators
extension PersonalizationService {
    func generateStepByStepInstructions(dimension: WellnessDimension, level: ActionLevel) -> [String] {
        switch dimension {
        case .physical:
            return generatePhysicalInstructions(for: level)
        case .emotional:
            return generateEmotionalInstructions(for: level)
        case .mental:
            return generateMentalInstructions(for: level)
        case .social:
            return generateSocialInstructions(for: level)
        case .spiritual:
            return generateSpiritualInstructions(for: level)
        case .professional:
            return generateProfessionalInstructions(for: level)
        case .environmental:
            return generateEnvironmentalInstructions(for: level)
        }
    }
    
    private func generatePhysicalInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Ponte de pie con los pies separados al ancho de hombros",
                "Levanta los brazos lentamente hacia arriba",
                "Mantén por 30 segundos respirando profundo",
                "Baja los brazos lentamente"
            ]
        case .mini:
            return [
                "Colócate en una posición cómoda de pie",
                "Inhala profundo mientras levantas los brazos",
                "Exhala mientras bajas y caminas en el lugar",
                "Repite 5 veces con respiración consciente",
                "Termina con una respiración profunda"
            ]
        case .standard:
            return [
                "Comienza con estiramiento de cuello (30 seg)",
                "Continúa con brazos y hombros (45 seg)",
                "Termina con torsión suave de columna (45 seg)",
                "Respira conscientemente durante cada movimiento",
                "Escucha las sensaciones de tu cuerpo"
            ]
        case .extended:
            return [
                "Inicia con conexión respiratoria (30 seg)",
                "Secuencia de estiramiento completo (2 min)",
                "Movimientos fluidos y conscientes (1 min)",
                "Fortalecimiento suave (1 min)",
                "Relajación final con respiración (30 seg)"
            ]
        }
    }
    
    private func generateEmotionalInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Pausa lo que estés haciendo",
                "Lleva atención a tu interior",
                "Nombra la emoción principal que sientes",
                "Acéptala sin juzgarla"
            ]
        case .mini:
            return [
                "Toma una respiración profunda",
                "Identifica cómo te sientes exactamente",
                "Escribe en una frase tu emoción",
                "Añade brevemente el posible por qué",
                "Agradece a tu emoción por su mensaje"
            ]
        case .standard:
            return [
                "Encuentra un espacio tranquilo",
                "Recuerda una emoción reciente intensa",
                "Explora: ¿qué la desencadenó?",
                "¿Qué necesidad o valor estaba involucrado?",
                "¿Qué mensaje tiene para ti?",
                "Escribe tus reflexiones"
            ]
        case .extended:
            return [
                "Prepara papel y lápiz",
                "Conecta con una emoción compleja actual",
                "Escribe libremente sobre ella por 2-3 minutos",
                "No censures, solo fluye",
                "Relee y busca patrones o insights",
                "Termina con autocompasión"
            ]
        }
    }
    
    private func generateMentalInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Siéntate cómodamente",
                "Inhala contando hasta 4",
                "Retén el aire contando hasta 4", 
                "Exhala contando hasta 4",
                "Repite 3 veces"
            ]
        case .mini:
            return [
                "Encuentra una posición cómoda",
                "Cierra los ojos suavemente",
                "Enfoca atención en tu respiración natural",
                "Cuando la mente divague, regresa gentilmente",
                "Continúa por 90 segundos",
                "Abre los ojos lentamente"
            ]
        case .standard:
            return [
                "Siéntate con espalda recta y cómoda",
                "Toma 3 respiraciones profundas para centrarte",
                "Enfoca atención solo en la respiración",
                "Observa inhalación y exhalación sin controlar",
                "Si surgen pensamientos, obsérvalos y regresa",
                "Continúa por 2-3 minutos",
                "Termina con gratitud por este momento"
            ]
        case .extended:
            return [
                "Prepárate en un espacio sin distracciones",
                "Comienza con respiración consciente (1 min)",
                "Escanea tu cuerpo desde la cabeza a los pies",
                "Nota sensaciones sin cambiar nada",
                "Si encuentras tensión, respira hacia esa área",
                "Continúa el escaneo completo",
                "Termina con respiración integrativa"
            ]
        }
    }
    
    // Continuar con los otros métodos de instrucciones...
    private func generateSocialInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Piensa en alguien que aprecias",
                "Abre su conversación",
                "Envía un emoji que exprese cariño",
                "Siente la conexión al enviar"
            ]
        default:
            return ["Instrucciones detalladas para nivel \(level.displayName)"]
        }
    }
    
    private func generateSpiritualInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Pausa por un momento",
                "Piensa en algo que te llene de gratitud",
                "Siente esa sensación en tu cuerpo",
                "Sonríe internamente"
            ]
        default:
            return ["Instrucciones detalladas para nivel \(level.displayName)"]
        }
    }
    
    private func generateProfessionalInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Piensa en las últimas horas",
                "Identifica algo nuevo que aprendiste",
                "Puede ser una habilidad, insight o perspectiva",
                "Reconoce tu crecimiento continuo"
            ]
        default:
            return ["Instrucciones detalladas para nivel \(level.displayName)"]
        }
    }
    
    private func generateEnvironmentalInstructions(for level: ActionLevel) -> [String] {
        switch level {
        case .micro:
            return [
                "Mira a tu alrededor",
                "Elige un espacio pequeño (tamaño de tu mano)",
                "Ordénalo completamente",
                "Observa cómo te sientes después"
            ]
        default:
            return ["Instrucciones detalladas para nivel \(level.displayName)"]
        }
    }
    
    func generateAdaptedTitle(dimension: WellnessDimension, level: ActionLevel, context: ContextualFactors) -> String {
        let baseTitle = dimension.displayName
        let levelEmoji = level.emoji
        let timeEmoji = getTimeEmoji(for: context.timeOfDay)
        
        return "\(levelEmoji) \(baseTitle) \(timeEmoji)"
    }
    
    private func getTimeEmoji(for timeOfDay: TimeOfDay) -> String {
        switch timeOfDay {
        case .morning: return "🌅"
        case .afternoon: return "☀️"
        case .evening: return "🌇"
        case .night: return "🌙"
        }
    }
    
    func generateContextualVariations(dimension: WellnessDimension) -> [TimeOfDay: String] {
        let variations: [TimeOfDay: String] = [
            .morning: "Perfecto para energizar tu mañana",
            .afternoon: "Ideal para un reset de media tarde",
            .evening: "Excelente para descomprimir del día",
            .night: "Suave y relajante para antes de dormir"
        ]
        
        return variations
    }
    
    func generatePersonalityAdaptation(dimension: WellnessDimension, personalityType: WellnessPersonalityType) -> String {
        switch personalityType {
        case .achiever:
            return "Esta acción te acerca a tu mejor versión. ¡Cada repetición cuenta!"
        case .nurturer:
            return "Al cuidarte, también cuidas tu capacidad de cuidar a otros."
        case .seeker:
            return "Cada práctica es un paso más hacia tu verdadero ser."
        case .creator:
            return "Siéntete libre de adaptar esta práctica a tu estilo único."
        }
    }
}
