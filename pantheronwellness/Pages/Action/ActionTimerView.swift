import SwiftUI
import Combine

struct ActionTimerView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    let dimension: WellnessDimension
    
    @State private var timeRemaining: Int = 120 // 2 minutos = 120 segundos
    @State private var isTimerRunning = false
    @State private var checklistItems: [ChecklistItem] = []
    @State private var showContent = false
    @Environment(\.appTheme) var theme
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background
            dimension.primaryColor.opacity(0.05)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 12) {
                    // Dimension Badge
                    HStack(spacing: 8) {
                        Image(systemName: dimension.iconName)
                        Text(dimension.displayName)
                            .fontWeight(.semibold)
                    }
                    .font(theme.typography.body1)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(dimension.primaryColor.opacity(0.15))
                    )
                    .foregroundColor(dimension.primaryColor)
                    
                    // Action Title
                    Text(dimension.microAction)
                        .font(theme.typography.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.colors.onBackground)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : -20)
                .animation(.easeOut(duration: 0.6), value: showContent)
                
                Spacer()
                
                // Timer Circle
                ZStack {
                    // Background Circle
                    Circle()
                        .stroke(dimension.primaryColor.opacity(0.2), lineWidth: 12)
                        .frame(width: 200, height: 200)
                    
                    // Progress Circle
                    Circle()
                        .trim(from: 0, to: progressValue)
                        .stroke(
                            dimension.primaryColor,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progressValue)
                    
                    // Time Display
                    VStack(spacing: 4) {
                        Text(timeString)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(theme.colors.onBackground)
                        
                        Text(isTimerRunning ? "En progreso" : "Listo")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    }
                }
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: showContent)
                
                // Checklist
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pasos:")
                        .font(theme.typography.body1)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.colors.onBackground)
                    
                    VStack(spacing: 8) {
                        ForEach(checklistItems) { item in
                            ChecklistRow(item: item) {
                                toggleChecklistItem(item)
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
                )
                .padding(.horizontal, 20)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    if !isTimerRunning && timeRemaining > 0 {
                        Button(action: startTimer) {
                            Text("Comenzar")
                                .font(theme.typography.button)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(dimension.primaryColor)
                                )
                        }
                    } else if isTimerRunning {
                        Button(action: pauseTimer) {
                            Text("Pausar")
                                .font(theme.typography.button)
                                .fontWeight(.semibold)
                                .foregroundColor(dimension.primaryColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(dimension.primaryColor.opacity(0.1))
                                )
                        }
                    }
                    
                    if allChecklistItemsCompleted && timeRemaining == 0 {
                        Button(action: completeAction) {
                            Text("Completar")
                                .font(theme.typography.button)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.green)
                                        .shadow(color: Color.green.opacity(0.3), radius: 8, y: 4)
                                )
                        }
                    }
                    
                    Button(action: { coordinator.navigateToHome() }) {
                        Text("Cancelar")
                            .font(theme.typography.body2)
                            .foregroundColor(theme.colors.onBackground.opacity(0.6))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning && timeRemaining > 0 {
                timeRemaining -= 1
                
                if timeRemaining == 0 {
                    isTimerRunning = false
                    playCompletionSound()
                }
            }
        }
        .onAppear {
            setupChecklist()
            showContent = true
        }
    }
    
    // MARK: - Computed Properties
    private var progressValue: CGFloat {
        CGFloat(1.0 - (Double(timeRemaining) / 120.0))
    }
    
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private var allChecklistItemsCompleted: Bool {
        checklistItems.allSatisfy { $0.isCompleted }
    }
    
    // MARK: - Actions
    private func startTimer() {
        isTimerRunning = true
    }
    
    private func pauseTimer() {
        isTimerRunning = false
    }
    
    private func toggleChecklistItem(_ item: ChecklistItem) {
        if let index = checklistItems.firstIndex(where: { $0.id == item.id }) {
            checklistItems[index].isCompleted.toggle()
        }
    }
    
    private func setupChecklist() {
        checklistItems = dimension.checklistSteps.enumerated().map { index, step in
            ChecklistItem(id: UUID(), title: step, isCompleted: false)
        }
    }
    
    private func completeAction() {
        coordinator.completeAction(for: dimension)
    }
    
    private func playCompletionSound() {
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)
    }
}

// MARK: - Checklist Item Model
struct ChecklistItem: Identifiable {
    let id: UUID
    let title: String
    var isCompleted: Bool
}

// MARK: - Checklist Row
struct ChecklistRow: View {
    let item: ChecklistItem
    let onTap: () -> Void
    @Environment(\.appTheme) var theme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(item.isCompleted ? .green : theme.colors.onSurface.opacity(0.3))
                
                Text(item.title)
                    .font(theme.typography.body2)
                    .foregroundColor(theme.colors.onSurface)
                    .strikethrough(item.isCompleted)
                
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Dimension Checklist Extension
extension WellnessDimension {
    var checklistSteps: [String] {
        switch self {
        case .physical:
            return ["Encuentra un espacio cómodo", "Estira brazos y piernas suavemente", "Respira profundo"]
        case .emotional:
            return ["Toma un momento para ti", "Identifica tu emoción", "Escribe en una palabra"]
        case .mental:
            return ["Siéntate cómodamente", "Respira 4-4-4 (inhala-sostén-exhala)", "Repite 5 veces"]
        case .social:
            return ["Piensa en alguien importante", "Escribe un mensaje genuino", "Envíalo"]
        case .spiritual:
            return ["Cierra los ojos", "Piensa en algo que agradeces", "Escribe por qué"]
        case .professional:
            return ["Reflexiona sobre tu día", "Identifica 1 aprendizaje", "Anótalo"]
        case .environmental:
            return ["Mira tu espacio", "Elige un área pequeña", "Ordena por 2 minutos"]
        }
    }
}

#Preview {
    ActionTimerView(dimension: .mental)
        .environmentObject(AppCoordinator())
}

