import SwiftUI

struct AssessmentQuestionPage: View {
    @ObservedObject var coordinator: AppCoordinator
    let questionIndex: Int
    
    @State private var currentValue: Double = 3.0
    @State private var hasAnswered = false
    @State private var showContent = false
    
    private var question: AssessmentQuestion {
        AssessmentQuestion.allQuestions[questionIndex]
    }
    
    private var isLastQuestion: Bool {
        questionIndex == AssessmentQuestion.allQuestions.count - 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background with dimension color
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        question.dimension.primaryColor.opacity(0.05)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with progress
                    VStack(spacing: 20) {
                        // Progress Bar
                        VStack(spacing: 8) {
                            HStack {
                                Text("Pregunta \(questionIndex + 1) de \(AssessmentQuestion.allQuestions.count)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(Int((Double(questionIndex + 1) / Double(AssessmentQuestion.allQuestions.count)) * 100))%")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(question.dimension.primaryColor)
                            }
                            
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 6)
                                    
                                    RoundedRectangle(cornerRadius: 4)
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
                                        .frame(
                                            width: geo.size.width * (Double(questionIndex + 1) / Double(AssessmentQuestion.allQuestions.count)),
                                            height: 6
                                        )
                                        .animation(.easeInOut(duration: 0.5), value: questionIndex)
                                }
                            }
                            .frame(height: 6)
                        }
                        
                        // Dimension Badge
                        HStack(spacing: 8) {
                            Image(systemName: question.dimension.iconName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(question.dimension.primaryColor)
                            
                            Text(question.dimension.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(question.dimension.primaryColor)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(question.dimension.primaryColor.opacity(0.1))
                        )
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showContent)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                    
                    // Main Content - Assessment Slider
                    AssessmentSlider(
                        value: $currentValue,
                        question: question
                    )
                    .padding(.horizontal, 16)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 30)
                    .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                    .onChange(of: currentValue) { _, newValue in
                        hasAnswered = true
                    }
                    
                    // Action Button
                    VStack(spacing: 12) {
                        Button(action: {
                            coordinator.answerAssessmentQuestion(
                                dimension: question.dimension,
                                score: Int(currentValue)
                            )
                        }) {
                            HStack(spacing: 12) {
                                Text(isLastQuestion ? "Completar Assessment" : "Siguiente")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: isLastQuestion ? "checkmark" : "arrow.right")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(buttonBackground)
                            .cornerRadius(16)
                            .shadow(
                                color: hasAnswered ? question.dimension.primaryColor.opacity(0.3) : .clear,
                                radius: hasAnswered ? 8 : 0,
                                x: 0,
                                y: hasAnswered ? 4 : 0
                            )
                        }
                        .disabled(!hasAnswered)
                        .scaleEffect(showContent ? 1.0 : 0.9)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6), value: showContent)
                        .animation(.easeInOut(duration: 0.3), value: hasAnswered)
                        
                        // Helper Text
                        if !hasAnswered {
                            Text("Desliza el control para responder")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .opacity(showContent ? 1 : 0)
                                .animation(.easeOut(duration: 0.4).delay(0.8), value: showContent)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            showContent = true
            
            // Set existing answer if available
            if let existingResponse = coordinator.assessmentResponses[question.dimension] {
                currentValue = Double(existingResponse.score)
                hasAnswered = true
            }
        }
        .gesture(
            // Swipe to go back (only if not first question)
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.x > 100 && questionIndex > 0 {
                        // Go back to previous question
                        coordinator.currentQuestionIndex = questionIndex - 1
                        coordinator.currentView = .assessmentQuestion(questionIndex - 1)
                    }
                }
        )
    }
    
    // MARK: - Computed Properties
    private var buttonBackground: some View {
        Group {
            if hasAnswered {
                LinearGradient(
                    gradient: Gradient(colors: [
                        question.dimension.primaryColor,
                        question.dimension.primaryColor.opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            } else {
                Color.gray.opacity(0.3)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AssessmentQuestionPage(coordinator: AppCoordinator(), questionIndex: 0)
}
