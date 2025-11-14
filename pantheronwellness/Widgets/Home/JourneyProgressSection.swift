import SwiftUI

struct JourneyProgressSection: View {
    let focusedDimensions: [WellnessDimension]
    let identities: [WellnessDimension: Identity]
    @Environment(\.appTheme) var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Tu Journey")
                .font(theme.typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.onBackground)
            
            // Progress Cards
            VStack(spacing: 12) {
                ForEach(focusedDimensions, id: \.self) { dimension in
                    DimensionProgressCard(
                        dimension: dimension,
                        identity: identities[dimension]
                    )
                }
            }
        }
    }
}

// MARK: - Dimension Progress Card
struct DimensionProgressCard: View {
    let dimension: WellnessDimension
    let identity: Identity?
    @Environment(\.appTheme) var theme
    
    private var progress: Double {
        guard let identity = identity else { return 0 }
        return Double(identity.evidenceCount) / 21.0 // 21 días para completar
    }
    
    private var progressPercentage: Int {
        Int(progress * 100)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: dimension.iconName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(dimension.primaryColor)
                    
                    Text(dimension.displayName)
                        .font(theme.typography.body1)
                        .fontWeight(.medium)
                        .foregroundColor(theme.colors.onSurface)
                }
                
                Spacer()
                
                Text("\(progressPercentage)%")
                    .font(theme.typography.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onSurface.opacity(0.6))
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    dimension.primaryColor.opacity(0.8),
                                    dimension.primaryColor
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 8)
            
            // Evidence Count
            if let identity = identity {
                HStack(spacing: 4) {
                    Text("\(identity.evidenceCount)")
                        .font(theme.typography.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(dimension.primaryColor)
                    Text("de 21 días completados")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onSurface.opacity(0.5))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
        )
    }
}

#Preview {
    VStack {
        let identities: [WellnessDimension: Identity] = [
            .mental: Identity(dimension: .mental),
            .physical: Identity(dimension: .physical)
        ]
        
        JourneyProgressSection(
            focusedDimensions: [.mental, .physical, .emotional],
            identities: identities
        )
        .padding()
    }
}

