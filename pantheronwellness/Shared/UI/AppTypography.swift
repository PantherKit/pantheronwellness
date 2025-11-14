import SwiftUI
import UIKit

public enum ManropeWeight: String {
    case extraLight = "Manrope-ExtraLight"
    case light = "Manrope-Light"
    case regular = "Manrope-Regular"
    case medium = "Manrope-Medium"
    case semibold = "Manrope-SemiBold"
    case bold = "Manrope-Bold"
    case extrabold = "Manrope-ExtraBold"
    
    /// Sistema de peso equivalente para fallback
    var systemWeight: Font.Weight {
        switch self {
        case .extraLight: return .ultraLight
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .extrabold: return .black
        }
    }
}

public extension Font {
    /// Carga Manrope con verificación y fallback automático a San Francisco
    static func manrope(_ size: CGFloat, weight: ManropeWeight) -> Font {
        // Verificar si la fuente está disponible
        if UIFont(name: weight.rawValue, size: size) != nil {
            return Font.custom(weight.rawValue, size: size)
        } else {
            // Fallback a sistema con peso equivalente
            #if DEBUG
            print("⚠️ Manrope '\(weight.rawValue)' no encontrada. Usando San Francisco.")
            #endif
            return .system(size: size, weight: weight.systemWeight, design: .default)
        }
    }
    
    /// Versión forzada para debugging - siempre usa custom sin fallback
    static func manropeStrict(_ size: CGFloat, weight: ManropeWeight) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
}

public struct AppTypography {
    public let display: Font          // Títulos principales grandes
    public let displayLight: Font     // Títulos principales ligeros
    public let headline: Font         // Headers de sección
    public let title1: Font           // Títulos grandes
    public let title2: Font           // Títulos medianos
    public let title3: Font           // Títulos pequeños
    public let body1: Font            // Texto principal
    public let body2: Font            // Texto secundario
    public let caption: Font          // Hints y labels
    public let overline: Font         // Stats y categorías
    public let button: Font           // Botones principales
    public let buttonSecondary: Font  // Botones secundarios

    public static let base: AppTypography = .init(
        display: .manrope(48, weight: .bold),           // Títulos hero bold
        displayLight: .manrope(48, weight: .light),     // Títulos hero light
        headline: .manrope(28, weight: .semibold),      // Headers importantes
        title1: .manrope(24, weight: .semibold),        // Títulos grandes
        title2: .manrope(20, weight: .medium),          // Títulos medianos
        title3: .manrope(18, weight: .medium),          // Títulos pequeños
        body1: .manrope(17, weight: .regular),          // Texto principal
        body2: .manrope(15, weight: .regular),          // Texto secundario
        caption: .manrope(13, weight: .regular),        // Captions
        overline: .manrope(12, weight: .semibold),      // Labels
        button: .manrope(16, weight: .semibold),        // Botones primarios
        buttonSecondary: .manrope(16, weight: .medium)  // Botones secundarios
    )
    
    /// Verifica si Manrope está correctamente instalada
    public static func verifyManropeInstallation() -> Bool {
        let testWeight = ManropeWeight.regular
        return UIFont(name: testWeight.rawValue, size: 12) != nil
    }
    
    /// Imprime el estado de todas las fuentes Manrope
    public static func debugFontStatus() {
        print("========================================")
        print("🔤 Estado de Fuentes Manrope")
        print("========================================")
        
        for weight in [ManropeWeight.extraLight, .light, .regular, .medium, .semibold, .bold, .extrabold] {
            let isAvailable = UIFont(name: weight.rawValue, size: 12) != nil
            let icon = isAvailable ? "✅" : "❌"
            print("\(icon) \(weight.rawValue)")
        }
        
        print("========================================")
    }
}
