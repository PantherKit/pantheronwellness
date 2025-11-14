import SwiftUI

struct ActivitySummary: Identifiable {
    let id = UUID()
    let dimension: WellnessDimension
    let days: Int
    let illustration: String
    
    var displayText: String {
        return "\(days) días"
    }
    
    var activityName: String {
        return dimension.displayName
    }
}
