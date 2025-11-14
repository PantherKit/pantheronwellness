import SwiftUI

struct StatsRow: View {
    let streak: Int
    let weeklyGoal: Double
    let totalXP: Int
    let level: UserLevel
    @Environment(\.appTheme) var theme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Streak
                StatCard(
                    icon: "flame.fill",
                    iconColor: .orange,
                    value: "\(streak)",
                    label: streak == 1 ? "Día" : "Días"
                )
                
                // Weekly Goal
                StatCard(
                    icon: "target",
                    iconColor: theme.colors.primary,
                    value: "\(Int(weeklyGoal * 7))/7",
                    label: "Semana"
                )
                
                // Total XP
                StatCard(
                    icon: "bolt.fill",
                    iconColor: Color.yellow,
                    value: "\(totalXP)",
                    label: "XP Total"
                )
                
                // Level
                StatCard(
                    icon: "star.fill",
                    iconColor: Color.purple,
                    value: level.emoji,
                    label: level.displayName
                )
            }
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let iconColor: Color
    let value: String
    let label: String
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(height: 24)
            
            Text(value)
                .font(theme.typography.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.colors.onSurface)
            
            Text(label)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onSurface.opacity(0.6))
        }
        .frame(width: 100)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        )
    }
}

#Preview {
    VStack {
        StatsRow(
            streak: 8,
            weeklyGoal: 0.71,
            totalXP: 250,
            level: .building
        )
        .padding()
    }
}

