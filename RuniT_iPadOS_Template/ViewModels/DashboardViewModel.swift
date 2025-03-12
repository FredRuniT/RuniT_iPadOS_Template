import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    @Published var netWorth: Double = 0
    @Published var monthlyIncome: Double = 0
    @Published var monthlyExpenses: Double = 0
    @Published var monthlyCashFlow: Double = 0
    @Published var upcomingBills: [Bill] = []
    @Published var recentTransactions: [Transaction] = []
    @Published var spendingByCategory: [TransactionCategory: Double] = [:]
    
    private var financeManager: FinanceManager
    private var cancellables = Set<AnyCancellable>()
    
    init(financeManager: FinanceManager) {
        self.financeManager = financeManager
        setupSubscriptions()
        calculateDashboardMetrics()
    }
    
    private func setupSubscriptions() {
        // Subscribe to changes in accounts
        financeManager.$accounts
            .sink { [weak self] _ in
                self?.calculateNetWorth()
            }
            .store(in: &cancellables)
        
        // Subscribe to changes in transactions
        financeManager.$transactions
            .sink { [weak self] _ in
                self?.calculateMonthlyFinances()
                self?.calculateSpendingByCategory()
                self?.updateRecentTransactions()
            }
            .store(in: &cancellables)
        
        // Subscribe to changes in bills
        financeManager.$bills
            .sink { [weak self] _ in
                self?.updateUpcomingBills()
            }
            .store(in: &cancellables)
    }
    
    private func calculateDashboardMetrics() {
        calculateNetWorth()
        calculateMonthlyFinances()
        calculateSpendingByCategory()
        updateRecentTransactions()
        updateUpcomingBills()
    }
    
    private func calculateNetWorth() {
        netWorth = financeManager.accounts.reduce(0) { $0 + $1.balance }
    }
    
    private func calculateMonthlyFinances() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        
        // Filter transactions for the current month
        let currentMonthTransactions = financeManager.transactions.filter {
            calendar.isDate($0.date, inSameDayAs: startOfMonth) || $0.date > startOfMonth
        }
        
        // Calculate income (positive amounts)
        monthlyIncome = currentMonthTransactions
            .filter { $0.amount > 0 }
            .reduce(0) { $0 + $1.amount }
        
        // Calculate expenses (negative amounts, but we store the absolute value)
        monthlyExpenses = abs(currentMonthTransactions
            .filter { $0.amount < 0 }
            .reduce(0) { $0 + $1.amount })
        
        // Calculate cash flow
        monthlyCashFlow = monthlyIncome - monthlyExpenses
    }
    
    private func calculateSpendingByCategory() {
        let calendar = Calendar.current
        let now = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        
        // Filter transactions for the current month and only expenses
        let currentMonthExpenses = financeManager.transactions.filter {
            ($0.date >= startOfMonth) && ($0.amount < 0)
        }
        
        // Group by category and sum amounts
        var categoryTotals: [TransactionCategory: Double] = [:]
        
        for transaction in currentMonthExpenses {
            let absAmount = abs(transaction.amount)
            categoryTotals[transaction.category, default: 0] += absAmount
        }
        
        spendingByCategory = categoryTotals
    }
    
    private func updateRecentTransactions() {
        // Get the 5 most recent transactions
        recentTransactions = Array(financeManager.transactions
            .sorted(by: { $0.date > $1.date })
            .prefix(5))
    }
    
    private func updateUpcomingBills() {
        let calendar = Calendar.current
        let now = Date()
        let thirtyDaysLater = calendar.date(byAdding: .day, value: 30, to: now)!
        
        // Get unpaid bills due in the next 30 days
        upcomingBills = financeManager.bills
            .filter { !$0.isPaid && $0.dueDate >= now && $0.dueDate <= thirtyDaysLater }
            .sorted(by: { $0.dueDate < $1.dueDate })
    }
    
    // MARK: - Helper Methods
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
    
    func daysUntil(date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: date)
        return components.day ?? 0
    }
} 