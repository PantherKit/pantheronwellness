import SwiftUI

struct IdentityCard: View {
    let dimension: WellnessDimension
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }) {
            VStack(spacing: 12) {
                // Icon with matched geometry effect
                Image(systemName: dimension.iconName)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(iconColor)
                    .matchedGeometryEffect(
                        id: "icon-\(dimension.rawValue)", 
                        in: namespace,
                        properties: .frame,
                        isSource: true
                    )
                
                VStack(spacing: 4) {
                    Text(dimension.displayName)
                        .font(theme.typography.title3)
                        .foregroundColor(theme.colors.onSurface)
                        .matchedGeometryEffect(
                            id: "title-\(dimension.rawValue)", 
                            in: namespace,
                            properties: .frame,
                            isSource: true
                        )
                    
                    Text(dimension.identityStatement)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onSurface.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(cardBackground)
                    .matchedGeometryEffect(
                        id: "background-\(dimension.rawValue)", 
                        in: namespace,
                        properties: .frame,
                        isSource: true
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .shadow(
                        color: shadowColor,
                        radius: isPressed ? 2 : (isSelected ? 12 : 6),
                        x: 0,
                        y: isPressed ? 1 : (isSelected ? 6 : 3)
                    )
            )
            .scaleEffect(
                isPressed ? 0.95 : (isSelected ? 1.02 : (isHovered ? 1.01 : 1.0))
            )
            .animation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.25), value: isPressed)
            .animation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35), value: isSelected)
            .animation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.2), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private var cardBackground: Color {
        if isSelected {
            return dimension.primaryColor.opacity(0.1)
        } else if isPressed {
            return theme.colors.surface.opacity(0.8)
        } else {
            return theme.colors.surface
        }
    }
    
    private var iconColor: Color {
        isSelected ? dimension.primaryColor : theme.colors.onSurface.opacity(0.8)
    }
    
    private var borderColor: Color {
        if isSelected {
            return dimension.primaryColor
        } else if isHovered {
            return theme.colors.outline.opacity(0.5)
        } else {
            return theme.colors.outline.opacity(0.2)
        }
    }
    
    private var borderWidth: CGFloat {
        isSelected ? 2 : 1
    }
    
    private var shadowColor: Color {
        if isSelected {
            return dimension.primaryColor.opacity(0.3)
        } else {
            return Color.black.opacity(0.1)
        }
    }
}
