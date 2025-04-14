import Foundation

struct DailyTask: Codable {
    enum TaskType: String, Codable, CaseIterable {
        case accommodateGuests = "Accommodate 5 guests"
        case completeServices = "Complete 10 service requests"
        case makeShopPurchase = "Make a purchase in the shop"
        case keepClients = "Keep 10 clients without losing any"
        case collectCoins = "Collect 500 coins today"
        
        var requirement: Int {
            switch self {
            case .accommodateGuests: return 5
            case .completeServices: return 10
            case .makeShopPurchase: return 1
            case .keepClients: return 10
            case .collectCoins: return 500
            }
        }
    }
    
    let type: TaskType
    let creationDate: Date
    var progress: Int = 0
    var isCompleted: Bool = false
    var isRewardClaimed: Bool = false
    
    var expirationDate: Date {
        // 24 hours from creation
        return Calendar.current.date(byAdding: .hour, value: 24, to: creationDate) ?? Date()
    }
    
    var timeRemaining: TimeInterval {
        return expirationDate.timeIntervalSince(Date())
    }
    
    var isExpired: Bool {
        return timeRemaining <= 0
    }
}
