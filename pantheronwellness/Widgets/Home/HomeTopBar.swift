import SwiftUI

struct HomeTopBar: View {
    let userName: String
    let greeting: String
    let notificationCount: Int
    @Environment(\.appTheme) var theme
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: 0xB6E2D3),
                                Color(hex: 0x1A5A53)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                
                if userName.isEmpty {
                    Image(systemName: "person.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                } else {
                    Text(userName.prefix(1).uppercased())
                        .font(.manrope(20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Greeting
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.manrope(14, weight: .regular))
                    .foregroundColor(theme.colors.onBackground.opacity(0.6))
                
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: 0x1A5A53))
                    
                    Text("Día \(1) de tu journey")
                        .font(.manrope(12, weight: .medium))
                        .foregroundColor(Color(hex: 0x1A5A53))
                }
            }
            
            Spacer()
            
            // Notification Bell
            ZStack(alignment: .topTrailing) {
                Button(action: {
                    // Handle notification tap
                }) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(theme.colors.onBackground.opacity(0.7))
                        .frame(width: 44, height: 44)
                }
                
                if notificationCount > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Text("\(notificationCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .offset(x: 8, y: 4)
                }
            }
        }
    }
}

#Preview {
    HomeTopBar(
        userName: "Usuario",
        greeting: "¿Cómo amaneciste hoy?",
        notificationCount: 3
    )
    .padding()
}
