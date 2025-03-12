import SwiftUI

struct MainDashboardView: View {
    @EnvironmentObject private var financeManager: FinanceManager
    @Environment(\.themeManager) private var themeManager
    
    // Sample data for preview
    private let accounts = [
        DashboardAccount(id: UUID(), name: "Checking", institution: "Bank of America", balance: 2543.67, type: "Checking"),
        DashboardAccount(id: UUID(), name: "Savings", institution: "Bank of America", balance: 15750.42, type: "Savings"),
        DashboardAccount(id: UUID(), name: "Credit Card", institution: "Chase", balance: -1250.30, type: "Credit")
    ]
    
    private let budgets = [
        DashboardBudget(id: UUID(), category: "Dining", spent: 350, total: 500),
        DashboardBudget(id: UUID(), category: "Entertainment", spent: 120, total: 200),
        DashboardBudget(id: UUID(), category: "Shopping", spent: 450, total: 400)
    ]
    
    private let transactions = [
        DashboardTransaction(id: UUID(), merchantName: "Starbucks", date: Date(), amount: -4.95, category: "Food"),
        DashboardTransaction(id: UUID(), merchantName: "Amazon", date: Date().addingTimeInterval(-86400), amount: -29.99, category: "Shopping"),
        DashboardTransaction(id: UUID(), merchantName: "Netflix", date: Date().addingTimeInterval(-172800), amount: -14.99, category: "Entertainment")
    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 240, maximum: 300), spacing: Spacing.md)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
               
                
                // Net Worth Summary
                ThemedCard {
                    VStack(alignment: .leading, spacing: Spacing.sm) {
                        Text("Net Worth")
                            .headlineStyle()
                        
                        Text("$17,043.79")
                            .currencyLargeStyle()
                            .foregroundColor(.appPrimaryBlue)
                        
                        Text("↑ $1,250.42 (7.9%) this month")
                            .captionStyle()
                            .foregroundColor(.appSuccessGreen)
                    }
                }
                .cardHoverEffect()
                .padding(.horizontal, Spacing.md)
                
                // Accounts Section
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "Accounts", buttonTitle: "View All") {
                        print("View all accounts")
                    }
                    
                    LazyVGrid(columns: columns, spacing: Spacing.md) {
                        ForEach(accounts) { account in
                            AccountCard(
                                name: account.name,
                                institution: account.institution,
                                balance: account.balance,
                                type: account.type
                            )
                            .cardHoverEffect()
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                }
                
                // Budgets Section
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "Budgets", buttonTitle: "View All") {
                        print("View all budgets")
                    }
                    
                    VStack(spacing: Spacing.sm) {
                        ForEach(budgets) { budget in
                            BudgetProgressCard(
                                spent: budget.spent,
                                total: budget.total,
                                category: budget.category
                            )
                            .cardHoverEffect()
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                }
                
                // Recent Transactions
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    SectionHeader(title: "Recent Transactions", buttonTitle: "View All") {
                        print("View all transactions")
                    }
                    
                    VStack(spacing: Spacing.xs) {
                        ForEach(transactions) { transaction in
                            TransactionCard(
                                merchantName: transaction.merchantName,
                                date: transaction.date,
                                amount: transaction.amount,
                                category: transaction.category
                            )
                            .cardHoverEffect()
                        }
                    }
                    .padding(.horizontal, Spacing.md)
                }
            }
            .padding(.vertical, Spacing.lg)
        }
        .background(Color(.systemBackground))
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { /* Refresh data */ }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.appPrimaryBlue)
                }
            }
        }
    }
}

// Sample models for preview
struct DashboardAccount: Identifiable {
    let id: UUID
    let name: String
    let institution: String
    let balance: Double
    let type: String
}

struct DashboardBudget: Identifiable {
    let id: UUID
    let category: String
    let spent: Double
    let total: Double
}

struct DashboardTransaction: Identifiable {
    let id: UUID
    let merchantName: String
    let date: Date
    let amount: Double
    let category: String
}

#Preview {
    MainDashboardView()
        .environmentObject(FinanceManager())
        .environment(\.themeManager, ThemeManager())
} 
