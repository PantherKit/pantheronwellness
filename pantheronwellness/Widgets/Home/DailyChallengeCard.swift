import SwiftUI

struct DailyChallengeCard: View {
    let challenge: DailyChallenge
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: challenge.type.icon)
                        .font(.title3)
                        .foregroundColor(.purple)
                    
                    Text("Desafío del día")
                        .font(theme.typography.body1)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.colors.onSurface)
                }
                
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                }
            }
            
            // Challenge Description
            Text(challenge.type.title)
                .font(theme.typography.body2)
                .foregroundColor(theme.colors.onSurface.opacity(0.7))
            
            // Reward
            HStack(spacing: 6) {
                Image(systemName: "bolt.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                
                Text("+\(challenge.xpReward) XP bonus")
                    .font(theme.typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.yellow.opacity(0.15))
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.08),
                            Color.purple.opacity(0.03)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    VStack {
        DailyChallengeCard(
            challenge: DailyChallenge(type: .completeBefore8PM, xpReward: 20)
        )
        .padding()
        
        DailyChallengeCard(
            challenge: DailyChallenge(type: .completeTwoDimensions, xpReward: 30)
        )
        .padding()
    }
}

