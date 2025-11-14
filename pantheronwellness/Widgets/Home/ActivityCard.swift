import SwiftUI

struct ActivityCard: View {
    let activity: ActivitySummary
    let onTap: () -> Void
    @Environment(\.appTheme) var theme
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }) {
            VStack(spacing: 16) {
                // Illustration/Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    activity.dimension.primaryColor.opacity(0.2),
                                    activity.dimension.primaryColor.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: activity.illustration)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(activity.dimension.primaryColor)
                }
                
                // Content
                VStack(spacing: 6) {
                    Text(activity.displayText)
                        .font(.manrope(20, weight: .bold))
                        .foregroundColor(theme.colors.onBackground)
                    
                    Text(activity.activityName)
                        .font(.manrope(13, weight: .regular))
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                }
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(
                        color: Color.black.opacity(0.04),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    ActivityCard(
        activity: ActivitySummary(
            dimension: .physical,
            days: 12,
            illustration: "figure.walk"
        ),
        onTap: {}
    )
    .padding()
    .frame(width: 180)
}
