import Foundation

// MARK: - Assessment Question
struct AssessmentQuestion: Codable, Identifiable {
    let id: UUID
    let dimension: WellnessDimension
    let questionText: String
    let subtitle: String?
    let lowLabel: String
    let highLabel: String
    let order: Int
    
    init(dimension: WellnessDimension, questionText: String, subtitle: String? = nil, lowLabel: String, highLabel: String, order: Int) {
        self.id = UUID()
        self.dimension = dimension
        self.questionText = questionText
        self.subtitle = subtitle
        self.lowLabel = lowLabel
        self.highLabel = highLabel
        self.order = order
    }
}

// MARK: - Assessment Questions Data
extension AssessmentQuestion {
    static let allQuestions: [AssessmentQuestion] = [
        AssessmentQuestion(
            dimension: .physical,
            questionText: "¿Cómo describirías tu nivel de energía durante el día?",
            subtitle: "Piensa en tu energía promedio esta semana",
            lowLabel: "Muy bajo",
            highLabel: "Muy alto",
            order: 0
        ),
        
        AssessmentQuestion(
            dimension: .emotional,
            questionText: "¿Qué tan conectado te sientes con tus emociones?",
            subtitle: "¿Reconoces y entiendes lo que sientes?",
            lowLabel: "Desconectado",
            highLabel: "Muy consciente",
            order: 1
        ),
        
        AssessmentQuestion(
            dimension: .mental,
            questionText: "¿Con qué frecuencia sientes tu mente acelerada o ansiosa?",
            subtitle: "Considera tu estado mental general",
            lowLabel: "Muy frecuente",
            highLabel: "Casi nunca",
            order: 2
        ),
        
        AssessmentQuestion(
            dimension: .social,
            questionText: "¿Qué tan satisfecho te sientes con tus relaciones actuales?",
            subtitle: "Incluye familia, amigos y compañeros",
            lowLabel: "Poco satisfecho",
            highLabel: "Muy satisfecho",
            order: 3
        ),
        
        AssessmentQuestion(
            dimension: .spiritual,
            questionText: "¿Qué tan conectado te sientes con algo más grande que tú?",
            subtitle: "Puede ser naturaleza, propósito, espiritualidad, etc.",
            lowLabel: "Desconectado",
            highLabel: "Muy conectado",
            order: 4
        ),
        
        AssessmentQuestion(
            dimension: .professional,
            questionText: "¿Qué tan satisfecho te sientes con tu crecimiento profesional?",
            subtitle: "Considera aprendizaje y desarrollo en el trabajo",
            lowLabel: "Poco satisfecho",
            highLabel: "Muy satisfecho",
            order: 5
        ),
        
        AssessmentQuestion(
            dimension: .environmental,
            questionText: "¿Qué tan ordenado y armonioso sientes tu entorno?",
            subtitle: "Piensa en tu casa, oficina y espacios cotidianos",
            lowLabel: "Caótico",
            highLabel: "Muy ordenado",
            order: 6
        )
    ]
    
    static func question(for dimension: WellnessDimension) -> AssessmentQuestion? {
        return allQuestions.first { $0.dimension == dimension }
    }
    
    static var sortedQuestions: [AssessmentQuestion] {
        return allQuestions.sorted { $0.order < $1.order }
    }
}
