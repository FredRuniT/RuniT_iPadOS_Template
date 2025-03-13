import Foundation
import SwiftUI
import Combine
import SwiftData

class FinanceManager: ObservableObject {
    // Published properties for the UI
    @Published var monthlyBills: [MonthlyBill] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // Private properties
    private var cancellables = Set<AnyCancellable>()
    private let databaseService = DatabaseService.shared
    
    init() {
        loadSampleData()
    }
    
    // MARK: - SwiftData Methods
    
    // Load accounts from SwiftData for a user
    func loadAccounts(modelContext: ModelContext, for userId: UUID) -> [Account] {
        let predicate = #Predicate<Account> { account in
            account.user.id == userId
        }
        
        let descriptor = FetchDescriptor<Account>(predicate: predicate)
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error loading accounts from SwiftData: \(error)")
            return []
        }
    }
    
    // Load transactions from SwiftData for a user
    func loadTransactions(modelContext: ModelContext, for userId: UUID) -> [Transaction] {
        let predicate = #Predicate<Transaction> { transaction in
            transaction.owner.id == userId
        }
        
        let descriptor = FetchDescriptor<Transaction>(predicate: predicate)
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error loading transactions from SwiftData: \(error)")
            return []
        }
    }
    
    // Load bills from SwiftData for a user
    func loadBills(modelContext: ModelContext, for userId: UUID) -> [Bill] {
        let predicate = #Predicate<Bill> { bill in
            bill.owner.id == userId
        }
        
        let descriptor = FetchDescriptor<Bill>(predicate: predicate)
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error loading bills from SwiftData: \(error)")
            return []
        }
    }
    
    // Create a new account in SwiftData
    func createAccount(modelContext: ModelContext, 
                      name: String, 
                      type: AccountType, 
                      balance: Decimal,
                      for user: User) -> Account {
        let account = Account(
            accountId: UUID().uuidString,
            name: name,
            type: type,
            user: user
        )
        
        account.currentBalance = balance
        account.availableBalance = balance
        
        modelContext.insert(account)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving account: \(error)")
        }
        
        return account
    }
    
    // Create a new transaction in SwiftData
    func createTransaction(modelContext: ModelContext,
                          amount: Decimal,
                          description: String,
                          date: Date,
                          account: Account,
                          owner: User,
                          category: Category? = nil) -> Transaction {
        let transaction = Transaction(
            amount: amount,
            date: date,
            account: account,
            owner: owner
        )
        
        transaction.name = description
        transaction.description = description
        transaction.category = category
        
        modelContext.insert(transaction)
        
        // Update account balance
        account.currentBalance = (account.currentBalance ?? 0) + amount
        account.updatedAt = Date()
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving transaction: \(error)")
        }
        
        return transaction
    }
    
    // Create a new bill in SwiftData
    func createBill(modelContext: ModelContext,
                   name: String,
                   amount: Decimal,
                   dueDate: Date,
                   category: Category,
                   owner: User,
                   isRecurring: Bool = true) -> Bill {
        
        let bill = Bill(
            name: name,
            amount: amount,
            dueDate: dueDate,
            category: category,
            owner: owner
        )
        
        bill.recurring = isRecurring
        bill.monthlyAmount = amount // Simplification for now
        
        modelContext.insert(bill)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving bill: \(error)")
        }
        
        return bill
    }
    
    // MARK: - Helper Methods
    
    // Convert SwiftData Bill to MonthlyBill for UI
    func convertToMonthlyBill(_ bill: Bill) -> MonthlyBill {
        return MonthlyBill(
            id: bill.id,
            name: bill.name,
            monthlyAmount: NSDecimalNumber(decimal: bill.monthlyAmount).doubleValue,
            pastDue: NSDecimalNumber(decimal: bill.pastDueAmount).doubleValue,
            dueDate: bill.dueDate,
            status: bill.status == .paid ? .paid : 
                   bill.status == .overdue ? .late :
                   bill.status == .pending ? .scheduled : .unpaid,
            category: bill.category?.name ?? "Uncategorized",
            daysPastDue: Calendar.current.dateComponents([.day], from: bill.dueDate, to: Date()).day ?? 0
        )
    }
    
    // MARK: - Database Connection
    
    /// Connect to the database using MCP server
    /// - Parameters:
    ///   - username: MCP server username
    ///   - password: MCP server password
    ///   - completion: Callback with result of connection
    func connectToDatabase(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        databaseService.authenticate(username: username, password: password) { success, errorMessage in
            completion(success, errorMessage)
        }
    }
    
    /// Execute a query on the database
    /// - Parameters:
    ///   - query: SQL query to execute
    ///   - parameters: Query parameters
    ///   - completion: Callback with query results or error
    func executeQuery<T: Decodable>(
        query: String,
        parameters: [Any] = [],
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        databaseService.executeQuery(query: query, parameters: parameters, completion: completion)
    }
    
    // MARK: - Sample Data
    
    private func loadSampleData() {
        // Sample monthly bills (for UI preview when database is not connected)
        let now = Date()
        let calendar = Calendar.current
        
        let monthlyBill1 = MonthlyBill(
            name: "Rent",
            monthlyAmount: 1200.00,
            pastDue: 0.0,
            dueDate: calendar.date(byAdding: .day, value: 5, to: now)!,
            status: .unpaid,
            category: "Housing",
            daysPastDue: 0
        )
        
        let monthlyBill2 = MonthlyBill(
            name: "Electricity",
            monthlyAmount: 85.00,
            pastDue: 0.0,
            dueDate: calendar.date(byAdding: .day, value: 12, to: now)!,
            status: .unpaid,
            category: "Utilities",
            daysPastDue: 0
        )
        
        let monthlyBill3 = MonthlyBill(
            name: "Internet",
            monthlyAmount: 65.00,
            pastDue: 85.00,
            dueDate: calendar.date(byAdding: .day, value: -5, to: now)!,
            status: .late,
            category: "Utilities",
            daysPastDue: 5
        )
        
        monthlyBills = [monthlyBill1, monthlyBill2, monthlyBill3]
    }
    
    // MARK: - Create Sample SwiftData
    
    func createSampleSwiftDataForDemo(modelContext: ModelContext) {
        // Create a user
        let user = User(
            email: "demo@example.com",
            firstName: "Demo",
            lastName: "User",
            displayName: "Demo User"
        )
        modelContext.insert(user)
        
        // Create categories
        let housingCategory = Category(
            name: "Housing",
            categoryType: .expense,
            user: user
        )
        housingCategory.isEssential = true
        
        let utilitiesCategory = Category(
            name: "Utilities",
            categoryType: .expense,
            user: user
        )
        utilitiesCategory.isEssential = true
        
        let foodCategory = Category(
            name: "Food",
            categoryType: .expense,
            user: user
        )
        foodCategory.isEssential = true
        
        let transportationCategory = Category(
            name: "Transportation",
            categoryType: .expense,
            user: user
        )
        
        let entertainmentCategory = Category(
            name: "Entertainment",
            categoryType: .expense,
            user: user
        )
        
        modelContext.insert(housingCategory)
        modelContext.insert(utilitiesCategory)
        modelContext.insert(foodCategory)
        modelContext.insert(transportationCategory)
        modelContext.insert(entertainmentCategory)
        
        // Create accounts
        let checkingAccount = Account(
            accountId: "checking123",
            name: "Primary Checking",
            type: .checking,
            user: user
        )
        checkingAccount.currentBalance = 2543.67
        checkingAccount.availableBalance = 2543.67
        
        let savingsAccount = Account(
            accountId: "savings456",
            name: "Emergency Fund",
            type: .savings,
            user: user
        )
        savingsAccount.currentBalance = 15000
        savingsAccount.availableBalance = 15000
        
        let creditCard = Account(
            accountId: "cc789",
            name: "Rewards Credit Card",
            type: .credit,
            user: user
        )
        creditCard.currentBalance = -450.32
        creditCard.availableBalance = -450.32
        
        modelContext.insert(checkingAccount)
        modelContext.insert(savingsAccount)
        modelContext.insert(creditCard)
        
        // Create bills
        let now = Date()
        let calendar = Calendar.current
        
        let rentBill = Bill(
            name: "Rent",
            amount: 1200,
            dueDate: calendar.date(byAdding: .day, value: 5, to: now)!,
            category: housingCategory,
            owner: user
        )
        rentBill.recurring = true
        rentBill.monthlyAmount = 1200
        
        let electricityBill = Bill(
            name: "Electricity",
            amount: 85,
            dueDate: calendar.date(byAdding: .day, value: 12, to: now)!,
            category: utilitiesCategory,
            owner: user
        )
        electricityBill.recurring = true
        electricityBill.monthlyAmount = 85
        
        let internetBill = Bill(
            name: "Internet",
            amount: 65,
            dueDate: calendar.date(byAdding: .day, value: -5, to: now)!,
            category: utilitiesCategory,
            owner: user
        )
        internetBill.recurring = true
        internetBill.monthlyAmount = 65
        internetBill.pastDueAmount = 85
        internetBill.status = .overdue
        
        modelContext.insert(rentBill)
        modelContext.insert(electricityBill)
        modelContext.insert(internetBill)
        
        // Create transactions
        let groceryTransaction = Transaction(
            amount: -85.42,
            date: calendar.date(byAdding: .day, value: -2, to: now)!,
            account: checkingAccount,
            owner: user
        )
        groceryTransaction.name = "Grocery Shopping"
        groceryTransaction.category = foodCategory
        
        let gasTransaction = Transaction(
            amount: -45.00,
            date: calendar.date(byAdding: .day, value: -3, to: now)!,
            account: checkingAccount,
            owner: user
        )
        gasTransaction.name = "Gas Station"
        gasTransaction.category = transportationCategory
        
        let restaurantTransaction = Transaction(
            amount: -65.30,
            date: calendar.date(byAdding: .day, value: -5, to: now)!,
            account: creditCard,
            owner: user
        )
        restaurantTransaction.name = "Restaurant"
        restaurantTransaction.category = foodCategory
        
        modelContext.insert(groceryTransaction)
        modelContext.insert(gasTransaction)
        modelContext.insert(restaurantTransaction)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving sample data: \(error)")
        }
    }
} 