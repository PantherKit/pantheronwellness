import Foundation
import Combine

// MARK: - Data Access Layer
@MainActor
class UserDataService: ObservableObject {
    static let shared = UserDataService()
    
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // Keys
    private enum StorageKeys {
        static let userProfile = "user_profile_v2"
        static let wellnessAssessment = "wellness_assessment_v2" 
        static let wellnessJourney = "wellness_journey_v2"
        static let dailyCheckIn = "daily_checkin_v2"
        static let appSettings = "app_settings_v2"
    }
    
    private init() {
        // Configurar encoder/decoder para fechas
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - User Profile Management
    
    func saveUserProfile(_ profile: UserProfile) throws {
        let data = try encoder.encode(profile)
        userDefaults.set(data, forKey: StorageKeys.userProfile)
    }
    
    func loadUserProfile() -> UserProfile? {
        guard let data = userDefaults.data(forKey: StorageKeys.userProfile) else {
            return nil
        }
        
        do {
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            print("Error loading user profile: \(error)")
            return nil
        }
    }
    
    func deleteUserProfile() {
        userDefaults.removeObject(forKey: StorageKeys.userProfile)
    }
    
    // MARK: - Assessment Management
    
    func saveAssessment(_ assessment: WellnessAssessment) throws {
        let data = try encoder.encode(assessment)
        userDefaults.set(data, forKey: StorageKeys.wellnessAssessment)
    }
    
    func loadAssessment() -> WellnessAssessment? {
        guard let data = userDefaults.data(forKey: StorageKeys.wellnessAssessment) else {
            return nil
        }
        
        do {
            return try decoder.decode(WellnessAssessment.self, from: data)
        } catch {
            print("Error loading assessment: \(error)")
            return nil
        }
    }
    
    func deleteAssessment() {
        userDefaults.removeObject(forKey: StorageKeys.wellnessAssessment)
    }
    
    // MARK: - Journey Management
    
    func saveJourney(_ journey: WellnessJourney) throws {
        let data = try encoder.encode(journey)
        userDefaults.set(data, forKey: StorageKeys.wellnessJourney)
    }
    
    func loadJourney() -> WellnessJourney? {
        guard let data = userDefaults.data(forKey: StorageKeys.wellnessJourney) else {
            return nil
        }
        
        do {
            return try decoder.decode(WellnessJourney.self, from: data)
        } catch {
            print("Error loading journey: \(error)")
            return nil
        }
    }
    
    func deleteJourney() {
        userDefaults.removeObject(forKey: StorageKeys.wellnessJourney)
    }
    
    // MARK: - Daily Check-In Management
    
    func saveDailyCheckIn(_ checkIn: DailyCheckIn) throws {
        let data = try encoder.encode(checkIn)
        userDefaults.set(data, forKey: StorageKeys.dailyCheckIn)
    }
    
    func loadTodaysCheckIn() -> DailyCheckIn? {
        guard let data = userDefaults.data(forKey: StorageKeys.dailyCheckIn) else {
            return nil
        }
        
        do {
            let checkIn = try decoder.decode(DailyCheckIn.self, from: data)
            
            // Verificar que sea del día actual
            let calendar = Calendar.current
            if calendar.isDateInToday(checkIn.date) {
                return checkIn
            } else {
                // Eliminar check-in antiguo
                deleteDailyCheckIn()
                return nil
            }
        } catch {
            print("Error loading daily check-in: \(error)")
            return nil
        }
    }
    
    func deleteDailyCheckIn() {
        userDefaults.removeObject(forKey: StorageKeys.dailyCheckIn)
    }
    
    // MARK: - Analytics and Insights
    
    func getUserStats() -> UserStats {
        guard let profile = loadUserProfile() else {
            return UserStats()
        }
        
        let totalEvidences = profile.totalEvidences
        let activeDays = profile.activeDaysCount
        let dominantDimension = profile.dominantIdentity
        let daysSinceStart = Calendar.current.dateComponents([.day], from: profile.startDate, to: Date()).day ?? 0
        
        let averageEvidencesPerDay = daysSinceStart > 0 ? Double(totalEvidences) / Double(daysSinceStart) : 0
        
        return UserStats(
            totalEvidences: totalEvidences,
            activeDays: activeDays,
            averageEvidencesPerDay: averageEvidencesPerDay,
            daysSinceStart: daysSinceStart,
            dominantDimension: dominantDimension,
            longestStreak: getLongestStreak(from: profile),
            completionRate: getCompletionRate(from: profile)
        )
    }
    
    private func getLongestStreak(from profile: UserProfile) -> Int {
        return profile.identities.values.map(\.currentStreak).max() ?? 0
    }
    
    private func getCompletionRate(from profile: UserProfile) -> Double {
        let daysSinceStart = Calendar.current.dateComponents([.day], from: profile.startDate, to: Date()).day ?? 0
        guard daysSinceStart > 0 else { return 0 }
        
        return Double(profile.activeDaysCount) / Double(daysSinceStart)
    }
    
    // MARK: - Data Export/Import (para futuro backup/sync)
    
    func exportUserData() throws -> Data {
        let userData = ExportableUserData(
            profile: loadUserProfile(),
            assessment: loadAssessment(),
            journey: loadJourney(),
            exportDate: Date()
        )
        
        return try encoder.encode(userData)
    }
    
    func importUserData(from data: Data) throws {
        let userData = try decoder.decode(ExportableUserData.self, from: data)
        
        if let profile = userData.profile {
            try saveUserProfile(profile)
        }
        
        if let assessment = userData.assessment {
            try saveAssessment(assessment)
        }
        
        if let journey = userData.journey {
            try saveJourney(journey)
        }
    }
    
    // MARK: - Reset All Data
    
    func resetAllData() {
        deleteUserProfile()
        deleteAssessment()
        deleteJourney()
        deleteDailyCheckIn()
    }
}

// MARK: - Supporting Types

struct UserStats {
    let totalEvidences: Int
    let activeDays: Int
    let averageEvidencesPerDay: Double
    let daysSinceStart: Int
    let dominantDimension: WellnessDimension?
    let longestStreak: Int
    let completionRate: Double
    
    init(totalEvidences: Int = 0,
         activeDays: Int = 0,
         averageEvidencesPerDay: Double = 0,
         daysSinceStart: Int = 0,
         dominantDimension: WellnessDimension? = nil,
         longestStreak: Int = 0,
         completionRate: Double = 0) {
        self.totalEvidences = totalEvidences
        self.activeDays = activeDays
        self.averageEvidencesPerDay = averageEvidencesPerDay
        self.daysSinceStart = daysSinceStart
        self.dominantDimension = dominantDimension
        self.longestStreak = longestStreak
        self.completionRate = completionRate
    }
}

struct ExportableUserData: Codable {
    let profile: UserProfile?
    let assessment: WellnessAssessment?
    let journey: WellnessJourney?
    let exportDate: Date
}

// MARK: - Repository Protocol (para testing y futuras extensiones)

protocol UserDataRepository {
    func saveUserProfile(_ profile: UserProfile) throws
    func loadUserProfile() -> UserProfile?
    func deleteUserProfile()
    
    func saveAssessment(_ assessment: WellnessAssessment) throws
    func loadAssessment() -> WellnessAssessment?
    
    func saveJourney(_ journey: WellnessJourney) throws
    func loadJourney() -> WellnessJourney?
    
    func getUserStats() -> UserStats
}

extension UserDataService: UserDataRepository {
    // Ya implementado arriba
}
