import SwiftUI

public enum ManropeWeight: String {
    case extraLight = "Manrope-ExtraLight"
    case light = "Manrope-Light"
    case regular = "Manrope-Regular"
    case medium = "Manrope-Medium"
    case semibold = "Manrope-SemiBold"
    case bold = "Manrope-Bold"
    case extrabold = "Manrope-ExtraBold"
}

public extension Font {
    static func manrope(_ size: CGFloat, weight: ManropeWeight) -> Font {
        // Try custom font first, fallback to system font with equivalent weight
        let customFont = Font.custom(weight.rawValue, size: size)
        return customFont
    }
    
    // Helper method for system font fallback with equivalent weights
    static func manropeSystemFallback(_ size: CGFloat, weight: ManropeWeight) -> Font {
        let systemWeight: Font.Weight = {
            switch weight {
            case .extraLight: return .ultraLight
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .extrabold: return .black
            }
        }()
        return .system(size: size, weight: systemWeight, design: .default)
    }
}

public struct AppTypography {
    public let display: Font
    public let headline: Font
    public let title1: Font
    public let title2: Font
    public let title3: Font
    public let body1: Font
    public let body2: Font
    public let caption: Font
    public let overline: Font
    public let button: Font

    public static let base: AppTypography = .init(
        display: .manrope(40, weight: .regular),
        headline: .manrope(28, weight: .medium),
        title1: .manrope(22, weight: .medium),
        title2: .manrope(20, weight: .regular),
        title3: .manrope(18, weight: .regular),
        body1: .manrope(17, weight: .regular),
        body2: .manrope(15, weight: .regular),
        caption: .manrope(13, weight: .regular),
        overline: .manrope(12, weight: .medium),
        button: .manrope(16, weight: .semibold)
    )
}
