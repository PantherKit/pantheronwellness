import SwiftUI

struct AdaptiveInstructionsView: View {
    let adaptiveAction: AdaptiveMicroAction
    @Binding var currentStep: Int
    let dimension: WellnessDimension
    
    var body: some View {
        VStack(spacing: 20) {
            // Current Step Highlight
            VStack(spacing: 12) {
                HStack {
                    Text("Paso \(currentStep + 1)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(dimension.primaryColor)
                        )
                    
                    Spacer()
                    
                    Text("\(currentStep + 1) de \(adaptiveAction.instructions.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(adaptiveAction.instructions[currentStep])
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(dimension.primaryColor.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(dimension.primaryColor.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .id(currentStep) // For smooth transitions
            }
            
            // Step Progress Indicators
            HStack(spacing: 8) {
                ForEach(0..<adaptiveAction.instructions.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentStep ? dimension.primaryColor : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentStep ? 1.3 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentStep)
                }
            }
            
            // All Steps Preview (collapsed)
            if adaptiveAction.instructions.count > 1 {
                DisclosureGroup("Ver todos los pasos") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(adaptiveAction.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(index <= currentStep ? dimension.primaryColor : Color.gray.opacity(0.3))
                                        .frame(width: 20, height: 20)
                                    
                                    if index < currentStep {
                                        Image(systemName: "checkmark")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    } else {
                                        Text("\(index + 1)")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(index == currentStep ? .white : .gray)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Paso \(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(index <= currentStep ? dimension.primaryColor : .secondary)
                                    
                                    Text(instruction)
                                        .font(.subheadline)
                                        .foregroundColor(index == currentStep ? .primary : .secondary)
                                        .opacity(index <= currentStep ? 1.0 : 0.7)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding(.top, 8)
                }
                .accentColor(dimension.primaryColor)
                .font(.subheadline)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(dimension.primaryColor.opacity(0.1), lineWidth: 1)
                )
        )
        .animation(.easeInOut(duration: 0.3), value: currentStep)
    }
}

// MARK: - Breathing Guide Widget (para acciones de mindfulness)
struct BreathingGuideWidget: View {
    let dimension: WellnessDimension
    @State private var isInhaling = true
    @State private var scale: CGFloat = 1.0
    @State private var breathCount = 0
    
    let breathingPattern: (inhale: Int, hold: Int, exhale: Int)
    
    init(dimension: WellnessDimension, pattern: (Int, Int, Int) = (4, 4, 4)) {
        self.dimension = dimension
        self.breathingPattern = pattern
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Breathing Circle
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                dimension.primaryColor.opacity(0.3),
                                dimension.primaryColor.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: Double(breathingPattern.inhale)), value: scale)
                
                VStack(spacing: 8) {
                    Text(isInhaling ? "Inhala" : "Exhala")
                        .font(.headline)
                        .foregroundColor(dimension.primaryColor)
                    
                    Text("\(breathCount)")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(dimension.primaryColor)
                }
            }
            
            // Instructions
            VStack(spacing: 8) {
                Text("Sigue el ritmo del círculo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Patrón: \(breathingPattern.inhale)-\(breathingPattern.hold)-\(breathingPattern.exhale)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            startBreathingGuide()
        }
    }
    
    private func startBreathingGuide() {
        // Breathing cycle animation
        Timer.scheduledTimer(withTimeInterval: Double(breathingPattern.inhale + breathingPattern.exhale), repeats: true) { _ in
            withAnimation(.easeInOut(duration: Double(breathingPattern.inhale))) {
                scale = isInhaling ? 1.3 : 1.0
                isInhaling.toggle()
            }
            
            breathCount += 1
        }
    }
}

// MARK: - Contextual Motivation Widget
struct ContextualMotivationWidget: View {
    let adaptiveAction: AdaptiveMicroAction
    let dimension: WellnessDimension
    let currentStep: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
                
                Text("Motivación Contextual")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(getContextualMessage())
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func getContextualMessage() -> String {
        let progress = Double(currentStep + 1) / Double(adaptiveAction.instructions.count)
        
        switch progress {
        case 0...0.33:
            return "Cada pequeño paso cuenta. Estás construyendo tu nueva identidad."
        case 0.34...0.66:
            return "¡Vas muy bien! Tu cerebro está creando nuevos patrones."
        case 0.67...0.99:
            return "Casi terminamos. Siente cómo esta práctica se vuelve parte de ti."
        default:
            return "¡Perfecto! Has completado una micro-evidencia más de tu identidad."
        }
    }
}

// MARK: - Preview
#Preview {
    let mockAction = AdaptiveMicroAction(
        dimension: .physical,
        level: .standard,
        title: "Estiramiento Consciente",
        description: "Una secuencia de movimientos suaves",
        estimatedDuration: 150,
        instructions: [
            "Ponte de pie con los pies separados al ancho de hombros",
            "Levanta los brazos lentamente hacia arriba",
            "Mantén por 30 segundos respirando profundo",
            "Baja los brazos lentamente"
        ]
    )
    
    AdaptiveInstructionsView(
        adaptiveAction: mockAction,
        currentStep: .constant(1),
        dimension: .physical
    )
    .padding()
}
