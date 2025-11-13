import SwiftUI

struct IdentityCircle: View {
    let progress: [WellnessDimension: IdentityProgress]
    let selectedDimension: WellnessDimension?
    @State private var animateProgress = false
    @Environment(\.appTheme) var theme
    
    private let radius: CGFloat = 120
    private let strokeWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(theme.colors.outline.opacity(0.2), lineWidth: strokeWidth)
                .frame(width: radius * 2, height: radius * 2)
            
            // Progress segments
            ForEach(Array(WellnessDimension.allCases.enumerated()), id: \.element) { index, dimension in
                let dimensionProgress = progress[dimension]
                let completions = dimensionProgress?.totalCompletions ?? 0
                let maxCompletions = 10 // Max for visual purposes
                let progressValue = min(Double(completions) / Double(maxCompletions), 1.0)
                
                ProgressSegment(
                    dimension: dimension,
                    progress: animateProgress ? progressValue : 0,
                    isSelected: selectedDimension == dimension,
                    index: index,
                    totalSegments: WellnessDimension.allCases.count,
                    radius: radius,
                    strokeWidth: strokeWidth
                )
            }
            
            // Center content
            VStack(spacing: 8) {
                if let selected = selectedDimension,
                   let selectedProgress = progress[selected] {
                    
                    Image(systemName: selected.iconName)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(selected.primaryColor)
                    
                    Text("\(selectedProgress.currentStreak)")
                        .font(theme.typography.title1)
                        .foregroundColor(selected.primaryColor)
                    
                    Text("días seguidos")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                        .multilineTextAlignment(.center)
                    
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(theme.colors.primary)
                    
                    Text("Tu identidad\nen evolución")
                        .font(theme.typography.body2)
                        .foregroundColor(theme.colors.onBackground.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).delay(0.3)) {
                animateProgress = true
            }
        }
    }
}

struct ProgressSegment: View {
    let dimension: WellnessDimension
    let progress: Double
    let isSelected: Bool
    let index: Int
    let totalSegments: Int
    let radius: CGFloat
    let strokeWidth: CGFloat
    
    private var segmentAngle: Double {
        360.0 / Double(totalSegments)
    }
    
    private var startAngle: Double {
        Double(index) * segmentAngle - 90 // Start from top
    }
    
    private var endAngle: Double {
        startAngle + (segmentAngle * progress)
    }
    
    var body: some View {
        ZStack {
            // Background segment
            Path { path in
                path.addArc(
                    center: CGPoint(x: radius, y: radius),
                    radius: radius - strokeWidth / 2,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(startAngle + segmentAngle),
                    clockwise: false
                )
            }
            .stroke(dimension.primaryColor.opacity(0.1), lineWidth: strokeWidth)
            
            // Progress segment
            Path { path in
                path.addArc(
                    center: CGPoint(x: radius, y: radius),
                    radius: radius - strokeWidth / 2,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false
                )
            }
            .stroke(
                dimension.primaryColor.opacity(isSelected ? 1.0 : 0.8),
                style: StrokeStyle(
                    lineWidth: isSelected ? strokeWidth + 2 : strokeWidth,
                    lineCap: .round
                )
            )
            .shadow(
                color: dimension.primaryColor.opacity(0.3),
                radius: isSelected ? 6 : 3,
                x: 0,
                y: 0
            )
            
            // Dimension icon
            let iconAngle = startAngle + segmentAngle / 2
            let iconRadius = radius + 20
            let iconX = radius + cos(iconAngle * .pi / 180) * iconRadius
            let iconY = radius + sin(iconAngle * .pi / 180) * iconRadius
            
            Image(systemName: dimension.iconName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(dimension.primaryColor)
                .position(x: iconX, y: iconY)
                .scaleEffect(isSelected ? 1.2 : 1.0)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
        }
        .frame(width: radius * 2, height: radius * 2)
    }
}
