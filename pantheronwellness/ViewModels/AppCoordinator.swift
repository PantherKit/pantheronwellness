import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView = .onboarding
    @Published var selectedDimension: WellnessDimension?
    @Published var todaySession: DailySession?
    @Published var identityProgress: [WellnessDimension: IdentityProgress] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let progressKey = "identity_progress"
    private let sessionKey = "today_session"
    
    init() {
        loadProgress()
        loadTodaySession()
        checkIfShouldShowOnboarding()
    }
    
    // MARK: - Navigation
    func navigateToIdentitySelection() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .identitySelection
        }
    }
    
    func navigateToDailyAction(dimension: WellnessDimension) {
        selectedDimension = dimension
        createTodaySession(for: dimension)
        
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
    
    func navigateBackToSelection() {
        withAnimation(.timingCurve(0.4, 0.0, 0.2, 1, duration: 0.35)) {
            currentView = .identitySelection
        }
    }
    
    // MARK: - Session Management
    private func createTodaySession(for dimension: WellnessDimension) {
        todaySession = DailySession(dimension: dimension)
        saveTodaySession()
    }
    
    private func completeAction(for dimension: WellnessDimension) {
        guard var session = todaySession else { return }
        
        // Update session
        todaySession = DailySession(dimension: dimension, completed: true)
        
        // Update progress
        if identityProgress[dimension] == nil {
            identityProgress[dimension] = IdentityProgress(dimension: dimension)
        }
        identityProgress[dimension]?.recordCompletion()
        
        saveProgress()
        saveTodaySession()
    }
    
    // MARK: - Persistence
    private func loadProgress() {
        if let data = userDefaults.data(forKey: progressKey),
           let decoded = try? JSONDecoder().decode([String: IdentityProgress].self, from: data) {
            
            // Convert string keys back to enum
            for (key, progress) in decoded {
                if let dimension = WellnessDimension(rawValue: key) {
                    identityProgress[dimension] = progress
                }
            }
        }
    }
    
    private func saveProgress() {
        // Convert enum keys to strings for encoding
        let stringKeyed = Dictionary(uniqueKeysWithValues: 
            identityProgress.map { (key, value) in (key.rawValue, value) }
        )
        
        if let encoded = try? JSONEncoder().encode(stringKeyed) {
            userDefaults.set(encoded, forKey: progressKey)
        }
    }
    
    private func loadTodaySession() {
        if let data = userDefaults.data(forKey: sessionKey),
           let session = try? JSONDecoder().decode(DailySession.self, from: data) {
            
            // Check if session is from today
            let calendar = Calendar.current
            if calendar.isDateInToday(session.date) {
                todaySession = session
            }
        }
    }
    
    private func saveTodaySession() {
        if let session = todaySession,
           let encoded = try? JSONEncoder().encode(session) {
            userDefaults.set(encoded, forKey: sessionKey)
        }
    }
    
    private func checkIfShouldShowOnboarding() {
        // If user has completed any action before, skip onboarding
        if !identityProgress.isEmpty {
            currentView = .identitySelection
        }
        
        // If user has a session today and it's completed, go to progress
        if let session = todaySession, session.isCompleted {
            currentView = .progress
        }
    }
    
    // MARK: - Computed Properties
    var hasCompletedToday: Bool {
        todaySession?.isCompleted ?? false
    }
    
    var totalCompletions: Int {
        identityProgress.values.reduce(0) { $0 + $1.totalCompletions }
    }
    
    var currentStreaks: [WellnessDimension: Int] {
        Dictionary(uniqueKeysWithValues: 
            identityProgress.map { ($0.key, $0.value.currentStreak) }
        )
    }
}
