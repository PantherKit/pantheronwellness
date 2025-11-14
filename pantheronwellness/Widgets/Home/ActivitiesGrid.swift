import SwiftUI

struct ActivitiesGrid: View {
    let activities: [ActivitySummary]
    let onActivityTap: (WellnessDimension) -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            HStack {
                Text("Estás haciendo increíble con estas actividades")
                    .font(.manrope(18, weight: .bold))
                    .foregroundColor(theme.colors.onBackground)
                Spacer()
            }
            
            // Grid 2x2
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(activities) { activity in
                    ActivityCard(
                        activity: activity,
                        onTap: {
                            onActivityTap(activity.dimension)
                        }
                    )
                }
            }
            
            // Motivational Link
            HStack {
                Text("Tu alegría es lo que realmente calienta nuestro corazón")
                    .font(.manrope(13, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.5))
                
                Spacer()
                
                Button(action: {
                    // Navigate to add new dimension
                }) {
                    Text("Añadir nueva")
                        .font(.manrope(13, weight: .semibold))
                        .foregroundColor(Color(hex: 0x1A5A53))
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: 0xE8F5FF).opacity(0.4),
                            Color(hex: 0xE8F5FF).opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }
}

#Preview {
    ActivitiesGrid(
        activities: [
            ActivitySummary(dimension: .physical, days: 12, illustration: "figure.walk"),
            ActivitySummary(dimension: .mental, days: 8, illustration: "brain.head.profile"),
            ActivitySummary(dimension: .emotional, days: 15, illustration: "heart.fill"),
            ActivitySummary(dimension: .social, days: 6, illustration: "person.2.fill")
        ],
        onActivityTap: { _ in }
    )
    .padding()
}
