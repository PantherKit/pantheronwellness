import SwiftUI

public struct AppTheme {
    public let colors: AppColors
    public let typography: AppTypography

    public init(colors: AppColors = .light, typography: AppTypography = .base) {
        self.colors = colors
        self.typography = typography
    }

    public static let `default` = AppTheme()
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .default
}

public extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

public extension View {
    func appTheme(_ theme: AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
