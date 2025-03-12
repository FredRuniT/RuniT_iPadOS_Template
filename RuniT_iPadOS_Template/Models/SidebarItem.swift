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
} 