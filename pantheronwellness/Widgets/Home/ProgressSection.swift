import SwiftUI

struct ProgressSection: View {
    let activities: [ActivitySummary]
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Tu progreso esta semana")
                .font(.manrope(18, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
            
            // Progress Cards
            VStack(spacing: 12) {
                ForEach(activities) { activity in
                    ProgressCard(activity: activity)
                }
            }
        }
    }
}

struct ProgressCard: View {
    let activity: ActivitySummary
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(activity.dimension.primaryColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                
                Image(systemName: activity.illustration)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(activity.dimension.primaryColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.activityName)
                    .font(.manrope(16, weight: .semibold))
                    .foregroundColor(theme.colors.onBackground)
                
                Text("\(activity.days) días activos")
                    .font(.manrope(13, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
            }
            
            Spacer()
            
            // Progress indicator
            ZStack {
                Circle()
                    .stroke(activity.dimension.primaryColor.opacity(0.2), lineWidth: 3)
                    .frame(width: 40, height: 40)
                
                Circle()
                    .trim(from: 0, to: min(CGFloat(activity.days) / 7.0, 1.0))
                    .stroke(activity.dimension.primaryColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-90))
                
                Text("\(activity.days)")
                    .font(.manrope(12, weight: .bold))
                    .foregroundColor(activity.dimension.primaryColor)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: 8,
                    y: 2
                )
        )
    }
}

#Preview {
    ProgressSection(
        activities: [
            ActivitySummary(dimension: .physical, days: 5, illustration: "figure.walk"),
            ActivitySummary(dimension: .mental, days: 3, illustration: "brain.head.profile")
        ]
    )
    .padding()
}
