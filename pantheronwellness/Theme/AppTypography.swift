import SwiftUI

public enum PoppinsWeight: String {
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semibold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}

public extension Font {
    static func poppins(_ size: CGFloat, weight: PoppinsWeight) -> Font {
        let font = Font.custom(weight.rawValue, size: size)
        return font
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
        display: .poppins(40, weight: .bold),
        headline: .poppins(28, weight: .semibold),
        title1: .poppins(22, weight: .semibold),
        title2: .poppins(20, weight: .medium),
        title3: .poppins(18, weight: .medium),
        body1: .poppins(17, weight: .regular),
        body2: .poppins(15, weight: .regular),
        caption: .poppins(13, weight: .regular),
        overline: .poppins(12, weight: .medium),
        button: .poppins(16, weight: .semibold)
    )
}
