import Foundation

// Model for monthly bills displayed in the dashboard
struct MonthlyBill: Identifiable, Equatable, Codable {
    var id: UUID = UUID()
    var name: String
    var monthlyAmount: Double
    var pastDue: Double
    var dueDate: Date
    var status: BillStatus
    var category: String
    var daysPastDue: Int
    
    enum BillStatus: String, Equatable, Codable {
        case paid = "Paid"
        case unpaid = "Unpaid" 
        case scheduled = "Scheduled"
        case late = "Late"
    }
    
    // Coding keys to map database field names to Swift property names
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case monthlyAmount = "monthly_amount"
        case pastDue = "past_due" 
        case dueDate = "due_date"
        case status
        case category
        case daysPastDue = "days_past_due"
    }
    
    init(id: UUID = UUID(), name: String, monthlyAmount: Double, pastDue: Double, dueDate: Date, status: BillStatus, category: String, daysPastDue: Int) {
        self.id = id
        self.name = name
        self.monthlyAmount = monthlyAmount
        self.pastDue = pastDue
        self.dueDate = dueDate
        self.status = status
        self.category = category
        self.daysPastDue = daysPastDue
    }
    
    // Custom decoder initializer to handle date and other conversions
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.monthlyAmount = try container.decode(Double.self, forKey: .monthlyAmount)
        self.pastDue = try container.decode(Double.self, forKey: .pastDue)
        
        // Date handling - assuming ISO8601 format from the database
        let dateString = try container.decode(String.self, forKey: .dueDate)
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            self.dueDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dueDate, in: container, debugDescription: "Date format is invalid")
        }
        
        self.status = try container.decode(BillStatus.self, forKey: .status)
        self.category = try container.decode(String.self, forKey: .category)
        self.daysPastDue = try container.decode(Int.self, forKey: .daysPastDue)
    }
    
    // Custom encoder to handle date encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(monthlyAmount, forKey: .monthlyAmount)
        try container.encode(pastDue, forKey: .pastDue)
        
        // Date encoding - using ISO8601 format
        let dateFormatter = ISO8601DateFormatter()
        try container.encode(dateFormatter.string(from: dueDate), forKey: .dueDate)
        
        try container.encode(status, forKey: .status)
        try container.encode(category, forKey: .category)
        try container.encode(daysPastDue, forKey: .daysPastDue)
    }
    
    static func == (lhs: MonthlyBill, rhs: MonthlyBill) -> Bool {
        return lhs.id == rhs.id
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