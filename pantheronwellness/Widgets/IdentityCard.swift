import SwiftUI

enum IdentityCardStyle {
    case compact    // Para onboarding - solo icono, nombre y descripción
    case full      // Para home/progress - con evidencias y progreso
}

struct IdentityCard: View {
    let dimension: WellnessDimension
    let identity: Identity?
    let isSelected: Bool
    let namespace: Namespace.ID
    let onTap: () -> Void
    let isRecommended: Bool
    let recommendationPriority: Int?
    let style: IdentityCardStyle
    let overrideColor: Color?
    
    @State private var isPressed = false
    @State private var isHovered = false
    @Environment(\.appTheme) var theme
    
    init(dimension: WellnessDimension, 
         identity: Identity?, 
         isSelected: Bool, 
         namespace: Namespace.ID, 
         onTap: @escaping () -> Void,
         isRecommended: Bool = false,
         recommendationPriority: Int? = nil,
         style: IdentityCardStyle = .full,
         overrideColor: Color? = nil) {
        self.dimension = dimension
        self.identity = identity
        self.isSelected = isSelected
        self.namespace = namespace
        self.onTap = onTap
        self.isRecommended = isRecommended
        self.recommendationPriority = recommendationPriority
        self.style = style
        self.overrideColor = overrideColor
    }
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }) {
            if style == .compact {
                compactCardContent
            } else {
                fullCardContent
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
    
    // MARK: - Compact Card (Onboarding)
    private var compactCardContent: some View {
        VStack(spacing: 12) {
            // Icon
            Image(systemName: dimension.iconName)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(iconColor)
                .frame(height: 40)
            
            // Title
            Text(dimension.displayName)
                .font(theme.typography.body1)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.onSurface)
            
            // Aspirational copy
            Text(dimension.aspirationalCopy)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onSurface.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .shadow(
                    color: shadowColor,
                    radius: isPressed ? 4 : (isSelected ? 12 : 8),
                    x: 0,
                    y: isPressed ? 2 : (isSelected ? 6 : 4)
                )
        )
        .overlay(alignment: .topTrailing) {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(effectiveColor)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 20, height: 20)
                    )
                    .offset(x: -8, y: 8)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .scaleEffect(
            isPressed ? 0.97 : (isSelected ? 1.03 : 1.0)
        )
        .animation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.25), value: isPressed)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
    
    // MARK: - Full Card (Home/Progress)
    private var fullCardContent: some View {
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
    
    private var identityDescription: String {
        if let identity = identity, identity.evidenceCount > 0 {
            return "Has actuado como alguien \(dimension.displayName.lowercased()) \(identity.evidenceCount) veces"
        }
        return dimension.identityStatement
    }
    
    private var effectiveColor: Color {
        return overrideColor ?? dimension.primaryColor
    }
    
    private var cardBackground: Color {
        if style == .compact {
            // Minimalista para onboarding
            if isSelected {
                return effectiveColor.opacity(0.08)
            } else {
                return Color.white
            }
        } else {
            // Original para full card
            if isSelected {
                return effectiveColor.opacity(0.15)
            } else if isRecommended {
                return effectiveColor.opacity(0.05)
            } else if isPressed {
                return theme.colors.surface.opacity(0.8)
            } else {
                return theme.colors.surface
            }
        }
    }
    
    private var iconColor: Color {
        if style == .compact {
            return isSelected ? effectiveColor : Color.secondary
        } else {
            return isSelected ? effectiveColor : theme.colors.onSurface.opacity(0.8)
        }
    }
    
    private var borderColor: Color {
        if style == .compact {
            // Minimalista: solo borde cuando está seleccionado
            return isSelected ? effectiveColor : Color.clear
        } else {
            // Original para full card
            if isSelected {
                return effectiveColor
            } else if isRecommended {
                return effectiveColor.opacity(0.4)
            } else if isHovered {
                return theme.colors.outline.opacity(0.5)
            } else {
                return theme.colors.outline.opacity(0.2)
            }
        }
    }
    
    private var borderWidth: CGFloat {
        if style == .compact {
            return isSelected ? 2 : 0
        } else {
            return isSelected ? 2 : 1
        }
    }
    
    private var shadowColor: Color {
        if style == .compact {
            return isSelected ? effectiveColor.opacity(0.2) : Color.black.opacity(0.04)
        } else {
            if isSelected {
                return effectiveColor.opacity(0.3)
            } else {
                return Color.black.opacity(0.1)
            }
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
