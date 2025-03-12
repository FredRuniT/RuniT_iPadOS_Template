import Foundation

// Model for monthly bills displayed in the dashboard
struct MonthlyBill: Identifiable {
    var id: UUID = UUID()
    var name: String
    var monthlyAmount: Double
    var pastDue: Double
    var dueDate: Date
    var status: BillStatus
    var category: String
    var daysPastDue: Int
    
    enum BillStatus: String {
        case paid = "Paid"
        case pending = "Pending"
        case late = "Late"
    }
}

// Model for budget breakdown categories
struct BudgetCategory: Identifiable {
    var id: UUID = UUID()
    var name: String
    var amount: Double
    var percentage: Double
    var icon: String
    
    // Helper to get the system icon name based on category
    static func iconName(for category: String) -> String {
        switch category.lowercased() {
        case "housing":
            return "house.fill"
        case "drinks & dining":
            return "cup.and.saucer.fill"
        case "auto & transport":
            return "car.fill"
        case "childcare & education":
            return "book.fill"
        case "utilities":
            return "bolt.fill"
        case "entertainment":
            return "tv.fill"
        case "healthcare":
            return "heart.fill"
        case "shopping":
            return "bag.fill"
        case "savings":
            return "banknote.fill"
        case "other":
            return "ellipsis.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
}

// Model for budget insights
struct BudgetInsight: Identifiable {
    var id: UUID = UUID()
    var income: Double
    var expenses: Double
    var savings: Double
    
    var needsPercentage: Double
    var needsTarget: Double
    
    var wantsPercentage: Double
    var wantsTarget: Double
    
    var goalsPercentage: Double
}

// Model for financial freedom journey milestones
struct FinancialMilestone: Identifiable {
    var id: UUID = UUID()
    var title: String
    var timeframe: String
    var description: String
    var isComplete: Bool
}

// Model for payment schedule calendar
struct PaymentDate: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var bills: [MonthlyBill]
} 