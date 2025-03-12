import SwiftUI

struct DetailView: View {
    let sidebarSelection: SidebarItem?
    let detailID: UUID?
    @EnvironmentObject private var financeManager: FinanceManager
    
    var body: some View {
        Group {
            if let detailID = detailID {
                switch sidebarSelection {
                case .accounts:
                    AccountDetailView(accountID: detailID)
                
                case .transactions:
                    TransactionDetailView(transactionID: detailID)
                
                case .bills:
                    BillDetailView(billID: detailID)
                
                // Other detail views
                case .goals:
                    GoalDetailView(goalID: detailID)
                    
                case .wishlist:
                    WishlistItemDetailView(itemID: detailID)
                    
                case .loans:
                    LoanDetailView(loanID: detailID)
                    
                case .mortgages:
                    MortgageDetailView(mortgageID: detailID)
                    
                case .studentLoans:
                    StudentLoanDetailView(loanID: detailID)
                    
                case .familyMembers:
                    FamilyMemberDetailView(memberID: detailID)
                    
                default:
                    EmptyView()
                }
            } else {
                // Dashboard or section overview when no specific item is selected
                switch sidebarSelection {
                case .dashboard:
                    DashboardDetailView(financeManager: financeManager)
                
                case .insights:
                    InsightsView()
                
                case .budget:
                    BudgetOverviewView()
                
                case .income:
                    IncomeOverviewView()
                    
                case .aiChat:
                    AIChatView()
                    
                default:
                    PlaceholderView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// Placeholder views for the detail content
struct AccountDetailView: View {
    let accountID: UUID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Account Details")
                .font(.largeTitle)
                .bold()
            
            Text("Account ID: \(accountID.uuidString)")
                .font(.caption)
            
            Group {
                Text("Account Name: Checking Account")
                Text("Balance: $2,543.67")
                Text("Account Number: XXXX-XXXX-1234")
                Text("Bank: Example Bank")
            }
            .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Account Details")
    }
}

struct TransactionDetailView: View {
    let transactionID: UUID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Transaction Details")
                .font(.largeTitle)
                .bold()
            
            Text("Transaction ID: \(transactionID.uuidString)")
                .font(.caption)
            
            Group {
                Text("Merchant: Grocery Store")
                Text("Amount: $85.42")
                Text("Date: March 10, 2025")
                Text("Category: Food & Dining")
                Text("Payment Method: Credit Card")
            }
            .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Transaction Details")
    }
}

struct BillDetailView: View {
    let billID: UUID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Bill Details")
                .font(.largeTitle)
                .bold()
            
            Text("Bill ID: \(billID.uuidString)")
                .font(.caption)
            
            Group {
                Text("Payee: Rent")
                Text("Amount: $1,200.00")
                Text("Due Date: April 1, 2025")
                Text("Status: Upcoming")
                Text("Payment Method: Bank Transfer")
            }
            .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Bill Details")
    }
}

struct InsightsView: View {
    var body: some View {
        Text("Insights Overview")
            .font(.largeTitle)
            .navigationTitle("Insights")
    }
}

struct BudgetOverviewView: View {
    var body: some View {
        Text("Budget Overview")
            .font(.largeTitle)
            .navigationTitle("Budget")
    }
}

struct IncomeOverviewView: View {
    var body: some View {
        Text("Income Overview")
            .font(.largeTitle)
            .navigationTitle("Income")
    }
}

struct AIChatView: View {
    var body: some View {
        Text("AI Financial Assistant")
            .font(.largeTitle)
            .navigationTitle("Financial Assistant")
    }
}

struct PlaceholderView: View {
    var body: some View {
        VStack {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 72))
                .foregroundColor(.secondary)
            
            Text("Select an item to view details")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

// Additional placeholder views for other detail types
struct GoalDetailView: View {
    let goalID: UUID
    
    var body: some View {
        Text("Goal Details: \(goalID.uuidString)")
            .navigationTitle("Goal Details")
    }
}

struct WishlistItemDetailView: View {
    let itemID: UUID
    
    var body: some View {
        Text("Wishlist Item Details: \(itemID.uuidString)")
            .navigationTitle("Wishlist Item")
    }
}

struct LoanDetailView: View {
    let loanID: UUID
    
    var body: some View {
        Text("Loan Details: \(loanID.uuidString)")
            .navigationTitle("Loan Details")
    }
}

struct MortgageDetailView: View {
    let mortgageID: UUID
    
    var body: some View {
        Text("Mortgage Details: \(mortgageID.uuidString)")
            .navigationTitle("Mortgage Details")
    }
}

struct StudentLoanDetailView: View {
    let loanID: UUID
    
    var body: some View {
        Text("Student Loan Details: \(loanID.uuidString)")
            .navigationTitle("Student Loan Details")
    }
}

struct FamilyMemberDetailView: View {
    let memberID: UUID
    
    var body: some View {
        Text("Family Member Details: \(memberID.uuidString)")
            .navigationTitle("Family Member")
    }
} 