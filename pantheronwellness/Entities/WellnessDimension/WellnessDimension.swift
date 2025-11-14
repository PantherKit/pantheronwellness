import SwiftUI

enum WellnessDimension: String, CaseIterable, Identifiable, Codable {
    case physical = "physical"
    case emotional = "emotional"
    case mental = "mental"
    case social = "social"
    case spiritual = "spiritual"
    case professional = "professional"
    case environmental = "environmental"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .physical: return "Física"
        case .emotional: return "Emocional"
        case .mental: return "Mental"
        case .social: return "Social"
        case .spiritual: return "Espiritual"
        case .professional: return "Profesional"
        case .environmental: return "Ambiental"
        }
    }
    
    var identityStatement: String {
        switch self {
        case .physical: return "Soy alguien que cuida mi cuerpo"
        case .emotional: return "Soy alguien que escucha mis emociones"
        case .mental: return "Soy alguien que construye mi calma"
        case .social: return "Soy alguien que conecta con otros"
        case .spiritual: return "Soy alguien que honra mi interior"
        case .professional: return "Soy alguien que crece cada día"
        case .environmental: return "Soy alguien que cuida su entorno"
        }
    }
    
    var iconName: String {
        switch self {
        case .physical: return "figure.walk"
        case .emotional: return "heart.fill"
        case .mental: return "brain.head.profile"
        case .social: return "person.2.fill"
        case .spiritual: return "sparkles"
        case .professional: return "briefcase.fill"
        case .environmental: return "leaf.fill"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .physical: return Color(hex: 0x1A5A53)      // Verde bosque
        case .emotional: return Color(hex: 0xE6C88B)     // Amarillo cálido
        case .mental: return Color(hex: 0xB6E2D3)        // Menta suave
        case .social: return Color(hex: 0xFF8B7B)        // Coral suave
        case .spiritual: return Color(hex: 0xB8A4E5)     // Lavanda
        case .professional: return Color(hex: 0x4A7C8C)  // Azul profundo
        case .environmental: return Color(hex: 0xA8C686) // Verde lima
        }
    }
    
    var aspirationalCopy: String {
        switch self {
        case .physical: return "Más energía y vitalidad"
        case .emotional: return "Reconocer tus emociones"
        case .mental: return "Calma y claridad mental"
        case .social: return "Conexiones significativas"
        case .spiritual: return "Propósito y gratitud"
        case .professional: return "Crecimiento continuo"
        case .environmental: return "Espacios armoniosos"
        }
    }
    
    var microAction: String {
        switch self {
        case .physical: return "Haz 2 minutos de estiramiento suave"
        case .emotional: return "Escribe una emoción que sentiste hoy"
        case .mental: return "Haz una respiración 4-4-4 durante 90 segundos"
        case .social: return "Envía un mensaje significativo a alguien"
        case .spiritual: return "Anota una cosa que agradeces"
        case .professional: return "Escribe 1 aprendizaje del día"
        case .environmental: return "Ordena un espacio del tamaño de tu mano"
        }
    }
}
