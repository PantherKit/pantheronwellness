import SwiftUI

struct AssessmentSlider: View {
    @Binding var value: Double
    let question: AssessmentQuestion
    @State private var isActive = false
    
    private let minValue: Double = 1.0
    private let maxValue: Double = 5.0
    
    var body: some View {
        VStack(spacing: 24) {
            // Question Header
            VStack(spacing: 12) {
                Text(question.questionText)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                if let subtitle = question.subtitle {
                    Text(subtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            Spacer()
            
            // Slider Section
            VStack(spacing: 32) {
                // Value Display
                VStack(spacing: 8) {
                    Text("\(Int(value))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(question.dimension.primaryColor)
                        .scaleEffect(isActive ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
                    
                    Text(getValueLabel(for: value))
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                }
                
                // Custom Slider
                VStack(spacing: 16) {
                    ZStack(alignment: .leading) {
                        // Track
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        question.dimension.primaryColor.opacity(0.7),
                                        question.dimension.primaryColor
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: getProgressWidth(), height: 12)
                            .animation(.easeInOut(duration: 0.2), value: value)
                        
                        // Thumb
                        Circle()
                            .fill(Color.white)
                            .stroke(question.dimension.primaryColor, lineWidth: 3)
                            .frame(width: 28, height: 28)
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            .offset(x: getThumbOffset())
                            .scaleEffect(isActive ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
                    }
                    .frame(height: 28)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let newValue = calculateValue(from: gesture.location.x)
                                value = max(minValue, min(maxValue, newValue))
                                
                                // Haptic feedback
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                
                                isActive = true
                            }
                            .onEnded { _ in
                                // Snap to nearest integer
                                value = round(value)
                                isActive = false
                                
                                // Stronger haptic for final value
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            }
                    )
                    
                    // Scale Labels
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("1")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(value <= 1.5 ? question.dimension.primaryColor : .gray)
                            Text(question.lowLabel)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("5")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(value >= 4.5 ? question.dimension.primaryColor : .gray)
                            Text(question.highLabel)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Progress Indicators
            HStack(spacing: 8) {
                ForEach(0..<AssessmentQuestion.allQuestions.count, id: \.self) { index in
                    Circle()
                        .fill(index <= question.order ? question.dimension.primaryColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == question.order ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: question.order)
                }
            }
        }
        .padding(.vertical, 32)
        .onAppear {
            // Set initial value if not set
            if value == 0 {
                value = 3.0 // Default to middle value
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getProgressWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 80 // Account for padding
        let progress = (value - minValue) / (maxValue - minValue)
        return screenWidth * progress
    }
    
    private func getThumbOffset() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 80 // Account for padding
        let progress = (value - minValue) / (maxValue - minValue)
        return screenWidth * progress - 14 // Account for thumb size
    }
    
    private func calculateValue(from position: CGFloat) -> Double {
        let screenWidth = UIScreen.main.bounds.width - 80
        let progress = max(0, min(1, position / screenWidth))
        return minValue + (maxValue - minValue) * progress
    }
    
    private func getValueLabel(for value: Double) -> String {
        let intValue = Int(value)
        switch intValue {
        case 1: return "Muy bajo"
        case 2: return "Bajo" 
        case 3: return "Regular"
        case 4: return "Bueno"
        case 5: return "Excelente"
        default: return "Regular"
        }
    }
}

// MARK: - Preview
#Preview {
    struct AssessmentSliderPreview: View {
        @State private var sliderValue: Double = 3.0
        
        var body: some View {
            AssessmentSlider(
                value: $sliderValue,
                question: AssessmentQuestion.allQuestions[0]
            )
            .background(Color(.systemBackground))
        }
    }
    
    return AssessmentSliderPreview()
}
