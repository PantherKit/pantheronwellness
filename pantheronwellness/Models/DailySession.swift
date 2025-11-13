import Foundation

struct DailySession: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let selectedDimension: WellnessDimension
    let isCompleted: Bool
    let completedAt: Date?
    
    init(dimension: WellnessDimension, completed: Bool = false) {
        self.date = Date()
        self.selectedDimension = dimension
        self.isCompleted = completed
        self.completedAt = completed ? Date() : nil
    }
}

struct IdentityProgress: Codable {
    let dimension: WellnessDimension
    var totalCompletions: Int
    var currentStreak: Int
    var lastCompletedDate: Date?
    var weeklyCompletions: Int
    
    init(dimension: WellnessDimension) {
        self.dimension = dimension
        self.totalCompletions = 0
        self.currentStreak = 0
        self.lastCompletedDate = nil
        self.weeklyCompletions = 0
    }
    
    mutating func recordCompletion() {
        totalCompletions += 1
        weeklyCompletions += 1
        
        let today = Calendar.current.startOfDay(for: Date())
        let lastCompleted = lastCompletedDate.map { Calendar.current.startOfDay(for: $0) }
        
        if let lastCompleted = lastCompleted {
            let daysDifference = Calendar.current.dateComponents([.day], from: lastCompleted, to: today).day ?? 0
            
            if daysDifference == 1 {
                currentStreak += 1
            } else if daysDifference > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        
        lastCompletedDate = Date()
    }
}

enum AppView: Equatable {
    case onboarding
    case identitySelection
    case dailyAction(WellnessDimension)
    case feedback(WellnessDimension)
    case progress
    
    static func == (lhs: AppView, rhs: AppView) -> Bool {
        switch (lhs, rhs) {
        case (.onboarding, .onboarding),
             (.identitySelection, .identitySelection),
             (.progress, .progress):
            return true
        case (.dailyAction(let lhsDim), .dailyAction(let rhsDim)):
            return lhsDim == rhsDim
        case (.feedback(let lhsDim), .feedback(let rhsDim)):
            return lhsDim == rhsDim
        default:
            return false
        }
    }
}
