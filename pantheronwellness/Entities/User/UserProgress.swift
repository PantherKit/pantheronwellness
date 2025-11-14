import Foundation

// MARK: - XP Rewards
enum XPReward: Int {
    case dailyActionComplete = 10
    case streakBonus5Days = 20
    case streakBonus7Days = 50
    case streakBonus14Days = 100
    case dailyChallengeComplete = 30
    case perfectWeek = 150
    case secondDimensionSameDay = 15
}

// MARK: - User Level
enum UserLevel: String, Codable {
    case beginner = "beginner"
    case building = "building"
    case committed = "committed"
    case master = "master"
    
    var displayName: String {
        switch self {
        case .beginner: return "Principiante"
        case .building: return "En Construcción"
        case .committed: return "Comprometido"
        case .master: return "Maestro"
        }
    }
    
    var emoji: String {
        switch self {
        case .beginner: return "🌱"
        case .building: return "🔨"
        case .committed: return "💪"
        case .master: return "⭐"
        }
    }
    
    var xpRequired: Int {
        switch self {
        case .beginner: return 0
        case .building: return 100
        case .committed: return 500
        case .master: return 1500
        }
    }
    
    static func level(for xp: Int) -> UserLevel {
        if xp >= 1500 { return .master }
        if xp >= 500 { return .committed }
        if xp >= 100 { return .building }
        return .beginner
    }
    
    func progressToNext(currentXP: Int) -> Double {
        switch self {
        case .beginner:
            return Double(currentXP) / 100.0
        case .building:
            return Double(currentXP - 100) / 400.0
        case .committed:
            return Double(currentXP - 500) / 1000.0
        case .master:
            return 1.0
        }
    }
}

// MARK: - Daily Progress
struct DailyProgress: Codable, Identifiable {
    let id: UUID
    let date: Date
    let dimensionCompleted: WellnessDimension
    let xpEarned: Int
    let streakAtCompletion: Int
    let isSecondActionOfDay: Bool
    
    init(date: Date = Date(), 
         dimensionCompleted: WellnessDimension, 
         xpEarned: Int, 
         streakAtCompletion: Int,
         isSecondActionOfDay: Bool = false) {
        self.id = UUID()
        self.date = date
        self.dimensionCompleted = dimensionCompleted
        self.xpEarned = xpEarned
        self.streakAtCompletion = streakAtCompletion
        self.isSecondActionOfDay = isSecondActionOfDay
    }
}

// MARK: - Daily Challenge
struct DailyChallenge: Codable, Identifiable {
    let id: UUID
    let date: Date
    let type: ChallengeType
    let xpReward: Int
    var isCompleted: Bool
    
    enum ChallengeType: String, Codable {
        case completeBefore8PM = "complete_before_8pm"
        case completeTwoDimensions = "complete_two_dimensions"
        case maintainStreak = "maintain_streak"
        
        var title: String {
            switch self {
            case .completeBefore8PM: return "Completa antes de las 8pm"
            case .completeTwoDimensions: return "Completa 2 dimensiones hoy"
            case .maintainStreak: return "Mantén tu racha"
            }
        }
        
        var icon: String {
            switch self {
            case .completeBefore8PM: return "clock.fill"
            case .completeTwoDimensions: return "star.fill"
            case .maintainStreak: return "flame.fill"
            }
        }
    }
    
    init(date: Date = Date(), type: ChallengeType, xpReward: Int = 20) {
        self.id = UUID()
        self.date = date
        self.type = type
        self.xpReward = xpReward
        self.isCompleted = false
    }
    
    static func generateDailyChallenge() -> DailyChallenge {
        let types: [ChallengeType] = [.completeBefore8PM, .completeTwoDimensions, .maintainStreak]
        let randomType = types.randomElement() ?? .maintainStreak
        return DailyChallenge(type: randomType, xpReward: 20)
    }
}

