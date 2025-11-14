import SwiftUI

struct IdentityCard: View {
    let dimension: WellnessDimension
    let identity: Identity?
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void
    let isRecommended: Bool
    let recommendationPriority: Int?
    
    @State private var isPressed = false
    @State private var isHovered = false
    @Environment(\.appTheme) var theme
    
    init(dimension: WellnessDimension, 
         identity: Identity?, 
         isSelected: Bool, 
         namespace: Namespace.ID, 
         onTap: @escaping () -> Void,
         isRecommended: Bool = false,
         recommendationPriority: Int? = nil) {
        self.dimension = dimension
        self.identity = identity
        self.isSelected = isSelected
        self.namespace = namespace
        self.onTap = onTap
        self.isRecommended = isRecommended
        self.recommendationPriority = recommendationPriority
    }
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }) {
            VStack(spacing: 12) {
                // Icon with recommendation badge
                ZStack(alignment: .topTrailing) {
                    Image(systemName: dimension.iconName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(iconColor)
                        .matchedGeometryEffect(
                            id: "icon-\(dimension.rawValue)", 
                            in: namespace,
                            properties: .frame,
                            isSource: true
                        )
                    
                    // Recommendation Badge
                    if isRecommended, let priority = recommendationPriority {
                        RecommendationBadge(priority: priority)
                            .offset(x: 8, y: -8)
                    }
                }
                
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
                    
                    Text(identityDescription)
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
            .overlay(alignment: .bottom) {
                if let identity {
                    VStack(spacing: 6) {
                        HStack(spacing: 8) {
                            Text("\(identity.level.emoji) \(identity.level.displayName)")
                                .font(theme.typography.overline)
                                .foregroundColor(theme.colors.onSurface.opacity(0.7))
                            Spacer()
                            Text("\(identity.evidenceCount) evidencias")
                                .font(theme.typography.overline)
                                .foregroundColor(theme.colors.onSurface.opacity(0.7))
                        }
                        SwiftUI.ProgressView(value: identity.progressToNextLevel)
                            .progressViewStyle(LinearProgressViewStyle(tint: dimension.primaryColor))
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private var identityDescription: String {
        if let identity = identity, identity.evidenceCount > 0 {
            return "Has actuado como alguien \(dimension.displayName.lowercased()) \(identity.evidenceCount) veces"
        }
        return dimension.identityStatement
    }
    
    private var cardBackground: Color {
        if isSelected {
            return dimension.primaryColor.opacity(0.15)
        } else if isRecommended {
            return dimension.primaryColor.opacity(0.05)
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
        } else if isRecommended {
            return dimension.primaryColor.opacity(0.4)
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

// MARK: - Recommendation Badge
struct RecommendationBadge: View {
    let priority: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(badgeColor)
                .frame(width: 20, height: 20)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Text("\(priority)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
        }
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
    
    private var badgeColor: Color {
        switch priority {
        case 1: return .red
        case 2: return .orange
        case 3: return .blue
        default: return .gray
        }
    }
}
