import Foundation

// MARK: - Sleep Quality
enum SleepQuality: String, Codable, CaseIterable {
    case poor = "poor"
    case okay = "okay"
    case good = "good"
    
    var emoji: String {
        switch self {
        case .poor: return "😴"
        case .okay: return "😐"
        case .good: return "😊"
        }
    }
    
    var displayName: String {
        switch self {
        case .poor: return "Mal"
        case .okay: return "Regular"
        case .good: return "Bien"
        }
    }
    
    var actionDifficultyMultiplier: Double {
        switch self {
        case .poor: return 0.5  // Acciones más fáciles
        case .okay: return 0.75
        case .good: return 1.0  // Acciones normales
        }
    }
}

// MARK: - Identity Level
enum IdentityLevel: String, Codable {
    case beginner = "beginner"
    case building = "building"
    case established = "established"
    
    var displayName: String {
        switch self {
        case .beginner: return "Principiante"
        case .building: return "En Construcción"
        case .established: return "Establecida"
        }
    }
    
    var emoji: String {
        switch self {
        case .beginner: return "🌱"
        case .building: return "🔨"
        case .established: return "⭐"
        }
    }
    
    static func level(for evidenceCount: Int) -> IdentityLevel {
        switch evidenceCount {
        case 0...6:
            return .beginner
        case 7...20:
            return .building
        default:
            return .established
        }
    }
}

// MARK: - Daily Check-In
struct DailyCheckIn: Codable, Identifiable {
    let id: UUID
    let date: Date
    let selectedDimension: WellnessDimension
    let sleepQuality: SleepQuality
    let isCompleted: Bool
    let completedAt: Date?
    
    init(dimension: WellnessDimension, sleepQuality: SleepQuality, completed: Bool = false) {
        self.id = UUID()
        self.date = Date()
        self.selectedDimension = dimension
        self.sleepQuality = sleepQuality
        self.isCompleted = completed
        self.completedAt = completed ? Date() : nil
    }
}

// MARK: - Identity (Evidencias acumuladas)
struct Identity: Codable {
    let dimension: WellnessDimension
    var evidenceCount: Int
    var currentStreak: Int
    var lastEvidenceDate: Date?
    var level: IdentityLevel
    
    init(dimension: WellnessDimension) {
        self.dimension = dimension
        self.evidenceCount = 0
        self.currentStreak = 0
        self.lastEvidenceDate = nil
        self.level = .beginner
    }
    
    mutating func addEvidence() {
        evidenceCount += 1
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastEvidence = lastEvidenceDate.map { Calendar.current.startOfDay(for: $0) }
        
        if let lastEvidence = lastEvidence {
            let daysDifference = Calendar.current.dateComponents([.day], from: lastEvidence, to: today).day ?? 0
            
            if daysDifference == 1 {
                currentStreak += 1
            } else if daysDifference > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        lastEvidenceDate = Date()
        level = IdentityLevel.level(for: evidenceCount)
    }
    
    var progressToNextLevel: Double {
        switch level {
        case .beginner:
            return Double(evidenceCount) / 7.0
        case .building:
            return Double(evidenceCount - 7) / 14.0
        case .established:
            return 1.0
        }
    }
}

// MARK: - User Profile
struct UserProfile: Codable {
    var name: String
    let startDate: Date
    var identities: [WellnessDimension: Identity]
    var selectedWellnessFocus: [WellnessDimension]
    
    // Gamification
    var totalXP: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastActionDate: Date?
    var dailyProgressHistory: [DailyProgress]
    var todaysDimensionCompleted: [WellnessDimension]
    var currentDailyChallenge: DailyChallenge?
    
    init(name: String = "Usuario") {
        self.name = name
        self.startDate = Date()
        self.identities = [:]
        self.selectedWellnessFocus = []
        self.totalXP = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.lastActionDate = nil
        self.dailyProgressHistory = []
        self.todaysDimensionCompleted = []
        self.currentDailyChallenge = nil
        
        // Inicializar todas las identidades
        for dimension in WellnessDimension.allCases {
            self.identities[dimension] = Identity(dimension: dimension)
        }
    }
    
    var totalEvidences: Int {
        identities.values.reduce(0) { $0 + $1.evidenceCount }
    }
    
    var dominantIdentity: WellnessDimension? {
        identities.max(by: { $0.value.evidenceCount < $1.value.evidenceCount })?.key
    }
    
    var totalActiveDays: Int {
        // Contar días únicos en el historial
        let uniqueDates = Set(dailyProgressHistory.map { Calendar.current.startOfDay(for: $0.date) })
        return uniqueDates.count
    }
    
    var activeDaysCount: Int {
        let uniqueDates = Set(identities.values.compactMap { $0.lastEvidenceDate }.map {
            Calendar.current.startOfDay(for: $0)
        })
        return uniqueDates.count
    }
    
    var currentLevel: UserLevel {
        return UserLevel.level(for: totalXP)
    }
    
    var progressToNextLevel: Double {
        return currentLevel.progressToNext(currentXP: totalXP)
    }
    
    var hasCompletedTodayAction: Bool {
        guard let lastDate = lastActionDate else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }
    
    var weeklyGoalProgress: Double {
        let calendar = Calendar.current
        let today = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0
        }
        
        let weekProgress = dailyProgressHistory.filter { progress in
            progress.date >= weekStart && progress.date <= today
        }
        
        return Double(weekProgress.count) / 7.0
    }
}

enum AppView: Equatable {
    case welcome
    case onboarding
    case confirmation
    case mainTab
    case actionTimer(WellnessDimension)
    case feedbackCompletion(WellnessDimension, Int, Int) // dimension, xpEarned, newStreak
    case dimensionExplorer // ✨ NEW: Explorer para seleccionar otras dimensiones
    case assessmentWelcome
    case assessmentQuestion(Int)
    case identitySelection
    case dailyCheckIn
    case dailyAction(WellnessDimension)
    case feedback(WellnessDimension)
    case progress
    
    static func == (lhs: AppView, rhs: AppView) -> Bool {
        switch (lhs, rhs) {
        case (.welcome, .welcome),
             (.onboarding, .onboarding),
             (.confirmation, .confirmation),
             (.mainTab, .mainTab),
             (.dimensionExplorer, .dimensionExplorer),
             (.assessmentWelcome, .assessmentWelcome),
             (.identitySelection, .identitySelection),
             (.dailyCheckIn, .dailyCheckIn),
             (.progress, .progress):
            return true
        case (.assessmentQuestion(let lhsIndex), .assessmentQuestion(let rhsIndex)):
            return lhsIndex == rhsIndex
        case (.actionTimer(let lhsDim), .actionTimer(let rhsDim)):
            return lhsDim == rhsDim
        case (.feedbackCompletion(let lhsDim, let lhsXP, let lhsStreak), .feedbackCompletion(let rhsDim, let rhsXP, let rhsStreak)):
            return lhsDim == rhsDim && lhsXP == rhsXP && lhsStreak == rhsStreak
        case (.dailyAction(let lhsDim), .dailyAction(let rhsDim)):
            return lhsDim == rhsDim
        case (.feedback(let lhsDim), .feedback(let rhsDim)):
            return lhsDim == rhsDim
        default:
            return false
        }
    }
}
