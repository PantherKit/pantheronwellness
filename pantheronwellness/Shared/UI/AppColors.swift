import SwiftUI

public struct AppColors {
    public let primary: Color
    public let onPrimary: Color
    public let primaryVariant: Color
    public let secondary: Color
    public let onSecondary: Color
    public let tertiary: Color
    public let background: Color
    public let onBackground: Color
    public let surface: Color
    public let onSurface: Color
    public let outline: Color
    public let success: Color
    public let warning: Color
    public let error: Color
    public let onSuccess: Color
    public let onWarning: Color
    public let onError: Color
    
    // Welcome Screen Gradient Colors
    public let gradientTop: Color
    public let gradientMiddle: Color
    public let gradientBottom: Color
    
    // Welcome Screen Text Colors - Premium
    public let welcomeTextPrimary: Color
    public let welcomeTextSecondary: Color
    public let welcomeTextMuted: Color
    public let welcomeCTABackground: Color
    public let welcomeCTAText: Color

    public static let light: AppColors = .init(
        primary: Color(hex: 0x1A5A53),
        onPrimary: Color(hex: 0xF4ECE3),
        primaryVariant: Color(hex: 0x0D3B36),
        secondary: Color(hex: 0xE6C88B),
        onSecondary: Color(hex: 0x0D3B36),
        tertiary: Color(hex: 0xB6E2D3),
        background: Color(hex: 0xF4ECE3),
        onBackground: Color(hex: 0x0D3B36),
        surface: Color.white,
        onSurface: Color(hex: 0x0D3B36),
        outline: Color(hex: 0xB6E2D3),
        success: Color(hex: 0x1A5A53),
        warning: Color(hex: 0xE6C88B),
        error: Color(hex: 0xD64545),
        onSuccess: Color(hex: 0xF4ECE3),
        onWarning: Color(hex: 0x0D3B36),
        onError: Color.white,
        
        // Welcome Gradient: Azul suave -> Blanco -> Rosa suave
        gradientTop: Color(hex: 0xE8F4F8),     // Azul muy suave
        gradientMiddle: Color(hex: 0xFFFEFE),  // Blanco casi puro  
        gradientBottom: Color(hex: 0xF8E8F4),  // Rosa/lavanda suave
        
        // Welcome Premium Colors
        welcomeTextPrimary: Color(hex: 0x567C8D),   // Azul grisáceo suave
        welcomeTextSecondary: Color(hex: 0x4FD1C7), // Teal elegante  
        welcomeTextMuted: Color(hex: 0x567C8D),     // Mismo azul grisáceo
        welcomeCTABackground: Color(hex: 0x319795), // Teal saturado
        welcomeCTAText: Color(hex: 0xF7FAFC)        // Blanco cálido
    )
}
