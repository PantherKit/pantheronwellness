import SwiftUI

struct HomeHeader: View {
    let userName: String
    let streak: Int
    let dayNumber: Int
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar + Name
            HStack(spacing: 12) {
                Circle()
                    .fill(theme.colors.primary.opacity(0.15))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(userName.prefix(1).uppercased())
                            .font(theme.typography.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.colors.primary)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hola, \(userName)")
                        .font(theme.typography.body1)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.colors.onBackground)
                    
                    Text("Día \(dayNumber) de tu journey")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onBackground.opacity(0.6))
                }
            }
            
            Spacer()
            
            // Streak Badge
            StreakBadge(streak: streak)
        }
    }
}

// MARK: - Streak Badge
struct StreakBadge: View {
    let streak: Int
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            Text("\(streak)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.colors.onBackground)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.12))
        )
    }
}

#Preview {
    VStack {
        HomeHeader(userName: "Luis", streak: 8, dayNumber: 12)
            .padding()
        
        HomeHeader(userName: "María", streak: 0, dayNumber: 1)
            .padding()
    }
}

