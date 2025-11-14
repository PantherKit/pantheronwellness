import SwiftUI

struct AnimatedButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    
    @State private var isPressed = false
    @Environment(\.appTheme) var theme
    
    enum ButtonStyle {
        case primary
        case secondary
        case ghost
    }
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            action()
        }) {
            Text(title)
                .font(theme.typography.button)
                .foregroundColor(textColor)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(backgroundColor)
                        .shadow(
                            color: shadowColor,
                            radius: isPressed ? 2 : 8,
                            x: 0,
                            y: isPressed ? 1 : 4
                        )
                )
                .scaleEffect(isPressed ? 0.97 : 1.0)
                .animation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isPressed ? theme.colors.primaryVariant : theme.colors.primary
        case .secondary:
            return isPressed ? theme.colors.secondary.opacity(0.8) : theme.colors.secondary
        case .ghost:
            return isPressed ? theme.colors.outline.opacity(0.3) : theme.colors.outline.opacity(0.1)
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return theme.colors.onPrimary
        case .secondary:
            return theme.colors.onSecondary
        case .ghost:
            return theme.colors.primary
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary:
            return theme.colors.primary.opacity(0.3)
        case .secondary:
            return theme.colors.secondary.opacity(0.3)
        case .ghost:
            return Color.clear
        }
    }
}
