import Foundation
import SwiftUI
import Combine

// Basic model classes for financial data
struct Account: Identifiable {
    var id: UUID = UUID()
    var name: String
    var type: AccountType
    var balance: Double
    var institution: String
    var accountNumber: String
    var isActive: Bool = true
}

enum AccountType: String, CaseIterable {
    case checking = "Checking"
    case savings = "Savings"
    case creditCard = "Credit Card"
    case investment = "Investment"
    case loan = "Loan"
    case mortgage = "Mortgage"
}

struct Transaction: Identifiable {
    var id: UUID = UUID()
    var date: Date
    var amount: Double
    var description: String
    var category: TransactionCategory
    var accountID: UUID
    var isRecurring: Bool = false
}

enum TransactionCategory: String, CaseIterable {
    case housing = "Housing"
    case transportation = "Transportation"
    case food = "Food"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case personal = "Personal"
    case education = "Education"
    case travel = "Travel"
    case income = "Income"
    case other = "Other"
}

struct Bill: Identifiable {
    var id: UUID = UUID()
    var name: String
    var amount: Double
    var dueDate: Date
    var isPaid: Bool = false
    var isRecurring: Bool = true
    var recurringFrequency: RecurringFrequency = .monthly
}

enum RecurringFrequency: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
}

class FinanceManager: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var transactions: [Transaction] = []
    @Published var bills: [Bill] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadSampleData()
    }
    
    // MARK: - Account Methods
    
    func addAccount(_ account: Account) {
        accounts.append(account)
        // In a real app, you would save to persistent storage here
    }
    
    func updateAccount(_ account: Account) {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
        }
    }
    
    func deleteAccount(id: UUID) {
        accounts.removeAll { $0.id == id }
    }
    
    func getAccount(id: UUID) -> Account? {
        return accounts.first { $0.id == id }
    }
    
    // MARK: - Transaction Methods
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        // Update account balance
        if let index = accounts.firstIndex(where: { $0.id == transaction.accountID }) {
            accounts[index].balance += transaction.amount
        }
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            // Revert the old transaction's effect on the account balance
            if let accountIndex = accounts.firstIndex(where: { $0.id == transactions[index].accountID }) {
                accounts[accountIndex].balance -= transactions[index].amount
            }
            
            // Apply the new transaction's effect
            if let accountIndex = accounts.firstIndex(where: { $0.id == transaction.accountID }) {
                accounts[accountIndex].balance += transaction.amount
            }
            
            transactions[index] = transaction
        }
    }
    
    func deleteTransaction(id: UUID) {
        if let transaction = transactions.first(where: { $0.id == id }),
           let accountIndex = accounts.firstIndex(where: { $0.id == transaction.accountID }) {
            accounts[accountIndex].balance -= transaction.amount
        }
        
        transactions.removeAll { $0.id == id }
    }
    
    func getTransaction(id: UUID) -> Transaction? {
        return transactions.first { $0.id == id }
    }
    
    // MARK: - Bill Methods
    
    func addBill(_ bill: Bill) {
        bills.append(bill)
    }
    
    func updateBill(_ bill: Bill) {
        if let index = bills.firstIndex(where: { $0.id == bill.id }) {
            bills[index] = bill
        }
    }
    
    func deleteBill(id: UUID) {
        bills.removeAll { $0.id == id }
    }
    
    func getBill(id: UUID) -> Bill? {
        return bills.first { $0.id == id }
    }
    
    func markBillAsPaid(id: UUID) {
        if let index = bills.firstIndex(where: { $0.id == id }) {
            bills[index].isPaid = true
        }
    }
    
    // MARK: - Sample Data
    
    private func loadSampleData() {
        // Sample accounts
        let checkingAccount = Account(
            name: "Primary Checking",
            type: .checking,
            balance: 2543.67,
            institution: "Example Bank",
            accountNumber: "XXXX-XXXX-1234"
        )
        
        let savingsAccount = Account(
            name: "Emergency Fund",
            type: .savings,
            balance: 15000.00,
            institution: "Example Bank",
            accountNumber: "XXXX-XXXX-5678"
        )
        
        let creditCard = Account(
            name: "Rewards Credit Card",
            type: .creditCard,
            balance: -450.32,
            institution: "Credit Bank",
            accountNumber: "XXXX-XXXX-9012"
        )
        
        accounts = [checkingAccount, savingsAccount, creditCard]
        
        // Sample transactions
        let now = Date()
        let calendar = Calendar.current
        
        let transaction1 = Transaction(
            date: calendar.date(byAdding: .day, value: -2, to: now)!,
            amount: -85.42,
            description: "Grocery Shopping",
            category: .food,
            accountID: checkingAccount.id
        )
        
        let transaction2 = Transaction(
            date: calendar.date(byAdding: .day, value: -3, to: now)!,
            amount: -45.00,
            description: "Gas Station",
            category: .transportation,
            accountID: checkingAccount.id
        )
        
        let transaction3 = Transaction(
            date: calendar.date(byAdding: .day, value: -5, to: now)!,
            amount: -65.30,
            description: "Restaurant",
            category: .food,
            accountID: creditCard.id
        )
        
        transactions = [transaction1, transaction2, transaction3]
        
        // Sample bills
        let bill1 = Bill(
            name: "Rent",
            amount: 1200.00,
            dueDate: calendar.date(byAdding: .day, value: 5, to: now)!
        )
        
        let bill2 = Bill(
            name: "Electricity",
            amount: 85.00,
            dueDate: calendar.date(byAdding: .day, value: 12, to: now)!
        )
        
        let bill3 = Bill(
            name: "Internet",
            amount: 65.00,
            dueDate: calendar.date(byAdding: .day, value: 15, to: now)!
        )
        
        bills = [bill1, bill2, bill3]
    }
} 