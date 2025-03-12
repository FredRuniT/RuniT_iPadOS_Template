import Foundation

enum SidebarItem: Hashable {
    // Overview
    case dashboard
    case insights
    
    // Money
    case accounts
    case transactions
    case bills
    case income
    
    // Planning
    case budget
    case goals
    case wishlist
    
    // Debt
    case loans
    case mortgages
    case studentLoans
    
    // Family
    case familyMembers
    
    // AI Assistant
    case aiChat
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .insights: return "Insights"
        case .accounts: return "Accounts"
        case .transactions: return "Transactions"
        case .bills: return "Bills"
        case .income: return "Income"
        case .budget: return "Budget"
        case .goals: return "Financial Goals"
        case .wishlist: return "Wishlist"
        case .loans: return "Loans"
        case .mortgages: return "Mortgages"
        case .studentLoans: return "Student Loans"
        case .familyMembers: return "Family Members"
        case .aiChat: return "Financial Assistant"
        }
    }
} 