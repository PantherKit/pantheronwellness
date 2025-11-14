import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView = .welcome
    @Published var selectedDimension: WellnessDimension?
    @Published var selectedSleepQuality: SleepQuality = .good
    @Published var todayCheckIn: DailyCheckIn?
    @Published var userProfile: UserProfile = UserProfile()
    
    // Onboarding focus selection
    @Published var selectedFocusDimensions: Set<WellnessDimension> = []
    let maxFocusDimensions = 3
    let minFocusDimensions = 2
    
    // Assessment properties
    @Published var currentAssessment: WellnessAssessment?
    @Published var assessmentResponses: [WellnessDimension: AssessmentResponse] = [:]
    @Published var currentQuestionIndex: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let profileKey = "user_profile"
    private let checkInKey = "today_checkin"
    private let assessmentKey = "wellness_assessment"
    
    private let personalizationService = PersonalizationService()
    
    init() {
        loadUserProfile()
        loadTodayCheckIn()
        // Siempre empezar en welcome para flujo simple
        currentView = .welcome
    }
    
    // MARK: - Navigation
    func navigateToOnboarding() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .onboarding
        }
    }
    
    func navigateToConfirmation() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .confirmation
        }
    }
    
    func navigateToHome() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .mainTab
        }
    }
    
    func navigateToMainTab() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .mainTab
        }
    }
    
    func navigateToActionTimer(dimension: WellnessDimension) {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .actionTimer(dimension)
        }
    }
    
    func navigateToFeedbackCompletion(dimension: WellnessDimension, xpEarned: Int, newStreak: Int) {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .feedbackCompletion(dimension, xpEarned, newStreak)
        }
    }
    
    // MARK: - Focus Dimensions Management
    func toggleFocusDimension(_ dimension: WellnessDimension) {
        if selectedFocusDimensions.contains(dimension) {
            selectedFocusDimensions.remove(dimension)
        } else {
            if selectedFocusDimensions.count < maxFocusDimensions {
                selectedFocusDimensions.insert(dimension)
            }
        }
    }
    
    func canSelectMoreDimensions() -> Bool {
        return selectedFocusDimensions.count < maxFocusDimensions
    }
    
    func hasMinimumDimensionsSelected() -> Bool {
        return selectedFocusDimensions.count >= minFocusDimensions
    }
    
    func completeFocusSelection() {
        userProfile.selectedWellnessFocus = Array(selectedFocusDimensions)
        
        // Generate first daily challenge
        userProfile.currentDailyChallenge = DailyChallenge.generateDailyChallenge()
        
        saveUserProfile()
        navigateToConfirmation()
    }
    
    // MARK: - Daily Dimension Selection
    func getSuggestedDimensionForToday() -> WellnessDimension? {
        // Si no tiene dimensiones seleccionadas, retornar nil
        guard !userProfile.selectedWellnessFocus.isEmpty else { return nil }
        
        // Filtrar las que ya completó hoy
        let availableDimensions = userProfile.selectedWellnessFocus.filter { dimension in
            !userProfile.todaysDimensionCompleted.contains(dimension)
        }
        
        // Si ya completó todas, retornar cualquiera para bonus
        guard !availableDimensions.isEmpty else {
            return userProfile.selectedWellnessFocus.first
        }
        
        // Sugerir la que tenga menos evidencias recientes
        let sortedByEvidence = availableDimensions.sorted { dim1, dim2 in
            let evidence1 = userProfile.identities[dim1]?.evidenceCount ?? 0
            let evidence2 = userProfile.identities[dim2]?.evidenceCount ?? 0
            return evidence1 < evidence2
        }
        
        return sortedByEvidence.first
    }
    
    // MARK: - Action Completion & XP System
    func completeAction(for dimension: WellnessDimension) {
        let isSecondAction = userProfile.hasCompletedTodayAction
        var xpEarned = XPReward.dailyActionComplete.rawValue
        
        // Update streak
        updateStreak()
        
        // Bonus XP for second action same day
        if isSecondAction {
            xpEarned += XPReward.secondDimensionSameDay.rawValue
        }
        
        // Streak bonuses
        if userProfile.currentStreak == 5 {
            xpEarned += XPReward.streakBonus5Days.rawValue
        } else if userProfile.currentStreak == 7 {
            xpEarned += XPReward.streakBonus7Days.rawValue
        } else if userProfile.currentStreak == 14 {
            xpEarned += XPReward.streakBonus14Days.rawValue
        }
        
        // Check daily challenge
        if let challenge = userProfile.currentDailyChallenge, !challenge.isCompleted {
            if checkDailyChallengeCompletion(challenge: challenge, dimension: dimension) {
                xpEarned += challenge.xpReward
                userProfile.currentDailyChallenge?.isCompleted = true
            }
        }
        
        // Update totals
        userProfile.totalXP += xpEarned
        userProfile.lastActionDate = Date()
        
        // Add to history
        let progress = DailyProgress(
            dimensionCompleted: dimension,
            xpEarned: xpEarned,
            streakAtCompletion: userProfile.currentStreak,
            isSecondActionOfDay: isSecondAction
        )
        userProfile.dailyProgressHistory.append(progress)
        
        // Mark as completed today
        if !userProfile.todaysDimensionCompleted.contains(dimension) {
            userProfile.todaysDimensionCompleted.append(dimension)
        }
        
        // Update identity evidence
        if userProfile.identities[dimension] == nil {
            userProfile.identities[dimension] = Identity(dimension: dimension)
        }
        userProfile.identities[dimension]?.addEvidence()
        
        saveUserProfile()
        
        // Navigate to feedback
        navigateToFeedbackCompletion(
            dimension: dimension,
            xpEarned: xpEarned,
            newStreak: userProfile.currentStreak
        )
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let lastDate = userProfile.lastActionDate else {
            userProfile.currentStreak = 1
            return
        }
        
        let lastActionDay = calendar.startOfDay(for: lastDate)
        let daysDifference = calendar.dateComponents([.day], from: lastActionDay, to: today).day ?? 0
        
        if daysDifference == 0 {
            // Ya completó hoy, no cambiar streak
            return
        } else if daysDifference == 1 {
            // Día consecutivo
            userProfile.currentStreak += 1
            if userProfile.currentStreak > userProfile.longestStreak {
                userProfile.longestStreak = userProfile.currentStreak
            }
        } else {
            // Rompió streak
            userProfile.currentStreak = 1
        }
    }
    
    private func checkDailyChallengeCompletion(challenge: DailyChallenge, dimension: WellnessDimension) -> Bool {
        switch challenge.type {
        case .completeBefore8PM:
            let hour = Calendar.current.component(.hour, from: Date())
            return hour < 20
        case .completeTwoDimensions:
            return userProfile.todaysDimensionCompleted.count >= 2
        case .maintainStreak:
            return userProfile.currentStreak > 0
        }
    }
    
    func resetDailyState() {
        // Check if needs to generate new challenge
        if let challenge = userProfile.currentDailyChallenge {
            if !Calendar.current.isDateInToday(challenge.date) {
                userProfile.currentDailyChallenge = DailyChallenge.generateDailyChallenge()
            }
        } else {
            userProfile.currentDailyChallenge = DailyChallenge.generateDailyChallenge()
        }
        
        // Reset today's completed dimensions if new day
        if !userProfile.hasCompletedTodayAction && !userProfile.todaysDimensionCompleted.isEmpty {
            userProfile.todaysDimensionCompleted = []
            saveUserProfile()
        }
    }
    
    func navigateToDailyCheckIn() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .dailyCheckIn
        }
    }
    
    func navigateToDailyAction(dimension: WellnessDimension) {
        selectedDimension = dimension
        createTodayCheckIn(for: dimension)
        
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .dailyAction(dimension)
        }
    }
    
    func navigateToFeedback(dimension: WellnessDimension) {
        completeAction(for: dimension)
        
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .feedback(dimension)
        }
    }
    
    func navigateToProgress() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.5)) {
            currentView = .progress
        }
    }
    
    func navigateBackToDailyCheckIn() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .dailyCheckIn
        }
    }
    
    // MARK: - Assessment Navigation (mantener para compatibilidad)
    func startAssessment() {
        assessmentResponses = [:]
        currentQuestionIndex = 0
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .assessmentWelcome
        }
    }
    
    func beginAssessmentQuestions() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .assessmentQuestion(0)
        }
    }
    
    func answerAssessmentQuestion(dimension: WellnessDimension, score: Int) {
        print("🔥 DEBUG AppCoordinator: answerAssessmentQuestion called")
        print("🔥 DEBUG: dimension: \(dimension), score: \(score)")
        print("🔥 DEBUG: currentQuestionIndex: \(currentQuestionIndex)")
        print("🔥 DEBUG: total questions: \(AssessmentQuestion.allQuestions.count)")
        
        assessmentResponses[dimension] = AssessmentResponse(dimension: dimension, score: score)
        
        if currentQuestionIndex < AssessmentQuestion.allQuestions.count - 1 {
            currentQuestionIndex += 1
            print("🔥 DEBUG: Moving to next question: \(currentQuestionIndex)")
            withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
                currentView = .assessmentQuestion(currentQuestionIndex)
            }
        } else {
            print("🔥 DEBUG: Completing assessment")
            completeAssessment()
        }
    }
    
    private func completeAssessment() {
        print("🔥 DEBUG: completeAssessment() started")
        
        let assessment = WellnessAssessment(responses: assessmentResponses)
        currentAssessment = assessment
        saveAssessment(assessment)
        
        print("🔥 DEBUG: Assessment saved, navigating to results")
        
        // Navigate immediately and generate journey in background
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .mainTab
        }
        
        // Generate journey in background (non-blocking)
        Task {
            await personalizationService.generatePersonalizedJourney(from: assessment)
            print("🔥 DEBUG: Personalized journey generated")
        }
        
        print("🔥 DEBUG: Navigation to assessmentResults triggered")
    }
    
    func navigateToIdentitySelection() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .identitySelection
        }
    }
    
    // MARK: - Daily Check-In Lifecycle
    func setSleepQuality(_ quality: SleepQuality) {
        selectedSleepQuality = quality
    }
    
    private func createTodayCheckIn(for dimension: WellnessDimension) {
        todayCheckIn = DailyCheckIn(
            dimension: dimension,
            sleepQuality: selectedSleepQuality,
            completed: false
        )
        saveTodayCheckIn()
    }
    
    private func completeTodayCheckIn(for dimension: WellnessDimension) {
        guard let currentCheckIn = todayCheckIn else { return }
        
        todayCheckIn = DailyCheckIn(
            dimension: dimension,
            sleepQuality: currentCheckIn.sleepQuality,
            completed: true
        )
        
        if userProfile.identities[dimension] == nil {
            userProfile.identities[dimension] = Identity(dimension: dimension)
        }
        userProfile.identities[dimension]?.addEvidence()
        
        saveUserProfile()
        saveTodayCheckIn()
    }
    
    func resetForNextDay() {
        todayCheckIn = nil
        selectedDimension = nil
        selectedSleepQuality = .good
        saveTodayCheckIn()
        navigateToDailyCheckIn()
    }
    
    // MARK: - Persistence
    private func loadUserProfile() {
        guard let data = userDefaults.data(forKey: profileKey),
              let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            userProfile = UserProfile()
            return
        }
        userProfile = decoded
    }
    
    private func saveUserProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            userDefaults.set(encoded, forKey: profileKey)
        }
    }
    
    private func loadTodayCheckIn() {
        guard let data = userDefaults.data(forKey: checkInKey),
              let checkIn = try? JSONDecoder().decode(DailyCheckIn.self, from: data) else { return }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(checkIn.date) {
            todayCheckIn = checkIn
            selectedDimension = checkIn.selectedDimension
            selectedSleepQuality = checkIn.sleepQuality
        } else {
            todayCheckIn = nil
        }
    }
    
    private func saveTodayCheckIn() {
        if let checkIn = todayCheckIn,
           let encoded = try? JSONEncoder().encode(checkIn) {
            userDefaults.set(encoded, forKey: checkInKey)
        } else {
            userDefaults.removeObject(forKey: checkInKey)
        }
    }
    
    private func checkIfShouldShowOnboarding() {
        // Cargar assessment si existe
        loadAssessment()
        
        // Si no hay assessment, ir al onboarding
        if currentAssessment == nil {
            currentView = .onboarding
            return
        }
        
        // Si hay assessment pero no evidencias, ir a check-in
        if userProfile.totalEvidences > 0 {
            currentView = .dailyCheckIn
        } else {
            currentView = .dailyCheckIn
        }
        
        // Si ya completó hoy, ir a progress
        if let checkIn = todayCheckIn, checkIn.isCompleted {
            currentView = .progress
        }
    }
    
    // MARK: - Assessment Persistence
    private func saveAssessment(_ assessment: WellnessAssessment) {
        if let encoded = try? JSONEncoder().encode(assessment) {
            userDefaults.set(encoded, forKey: assessmentKey)
        }
    }
    
    private func loadAssessment() {
        guard let data = userDefaults.data(forKey: assessmentKey),
              let assessment = try? JSONDecoder().decode(WellnessAssessment.self, from: data) else {
            return
        }
        currentAssessment = assessment
    }
    
    // MARK: - Computed Properties
    var hasCompletedToday: Bool {
        todayCheckIn?.isCompleted ?? false
    }
    
    var totalEvidences: Int {
        userProfile.totalEvidences
    }
    
    func currentStreak(for dimension: WellnessDimension) -> Int {
        userProfile.identities[dimension]?.currentStreak ?? 0
    }
    
    var dominantIdentity: (dimension: WellnessDimension, identity: Identity)? {
        guard let dominantDimension = userProfile.dominantIdentity,
              let identity = userProfile.identities[dominantDimension] else {
            return nil
        }
        return (dominantDimension, identity)
    }
    
    // MARK: - Adaptive Actions
    func getAdaptiveMicroAction(for dimension: WellnessDimension) -> AdaptiveMicroAction {
        return personalizationService.adaptMicroAction(for: dimension, user: userProfile)
    }
    
    var currentJourney: WellnessJourney? {
        return personalizationService.currentJourney
    }
}
