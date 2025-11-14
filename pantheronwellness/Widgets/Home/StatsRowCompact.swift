import SwiftUI

struct StatsRowCompact: View {
    let streak: Int
    let totalXP: Int
    let weekProgress: Int
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            // Streak
            CompactStatCard(
                icon: "flame.fill",
                iconColor: .orange,
                value: "\(streak)",
                label: streak == 1 ? "día" : "días",
                backgroundColor: Color.orange.opacity(0.1)
            )
            
            // XP
            CompactStatCard(
                icon: "bolt.fill",
                iconColor: .yellow,
                value: "\(totalXP)",
                label: "XP",
                backgroundColor: Color.yellow.opacity(0.1)
            )
            
            // Week Progress
            CompactStatCard(
                icon: "chart.bar.fill",
                iconColor: Color(hex: 0x34C759),
                value: "\(weekProgress)/7",
                label: "semana",
                backgroundColor: Color(hex: 0x34C759).opacity(0.1)
            )
        }
    }
}

struct CompactStatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String
    let backgroundColor: Color
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.manrope(18, weight: .bold))
                .foregroundColor(theme.colors.onBackground)
            
            Text(label)
                .font(.manrope(12, weight: .medium))
                .foregroundColor(theme.colors.onBackground.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor)
        )
    }
}

#Preview {
    StatsRowCompact(
        streak: 8,
        totalXP: 120,
        weekProgress: 4
    )
    .padding()
}
