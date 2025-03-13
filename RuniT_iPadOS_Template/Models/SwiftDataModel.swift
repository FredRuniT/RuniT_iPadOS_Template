import Foundation
import SwiftData

// MARK: - Core Models

/// The primary user model
@Model
final class User {
    // Core properties
    @Attribute(.unique) var id: UUID
    var email: String
    var firstName: String?
    var lastName: String?
    var displayName: String?
    var avatarUrl: String?
    
    // Financial preferences
    var defaultBudgetStartDay: Int
    var monthlyBudgetTarget: Decimal?
    var savingsTargetPercentage: Decimal?
    var debtPaymentTargetPercentage: Decimal?
    
    // Preferences
    var notificationPreferences: NotificationPreferences
    var uiPreferences: UIPreferences
    
    // Household relationship
    @Relationship var household: Household?
    var isHouseholdAdmin: Bool
    var householdRole: HouseholdRole?
    
    // Core relationships
    @Relationship(.cascade, inverse: \Account.user)
    var accounts: [Account]
    
    @Relationship(.cascade, inverse: \PlaidConnection.user)
    var plaidConnections: [PlaidConnection]
    
    @Relationship(.cascade, inverse: \Transaction.owner)
    var transactions: [Transaction]
    
    @Relationship(.cascade, inverse: \Bill.owner)
    var bills: [Bill]
    
    @Relationship(.cascade, inverse: \Income.user)
    var incomes: [Income]
    
    @Relationship(.cascade, inverse: \Loan.user)
    var loans: [Loan]
    
    @Relationship(.cascade, inverse: \FinancialGoal.user)
    var financialGoals: [FinancialGoal]
    
    @Relationship(.cascade, inverse: \WishlistItem.user)
    var wishlistItems: [WishlistItem]
    
    @Relationship(.cascade, inverse: \Category.user)
    var categories: [Category]
    
    @Relationship(.cascade, inverse: \Chat.user)
    var chats: [Chat]
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    var lastLoginAt: Date?
    var lastBudgetUpdate: Date?
    
    // Core init
    init(id: UUID = UUID(), 
         email: String, 
         firstName: String? = nil, 
         lastName: String? = nil, 
         displayName: String? = nil,
         avatarUrl: String? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName
        self.avatarUrl = avatarUrl
        
        // Default settings
        self.defaultBudgetStartDay = 1
        self.isHouseholdAdmin = false
        
        // Initialize preferences
        self.notificationPreferences = NotificationPreferences()
        self.uiPreferences = UIPreferences()
        
        // Timestamps
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Household Models

/// Household for multi-user management
@Model
final class Household {
    @Attribute(.unique) var id: UUID
    var name: String
    var showCombinedView: Bool
    var budgetDistributionMode: BudgetDistributionMode
    
    // Household members
    @Relationship(.cascade, inverse: \User.household)
    var members: [User]
    
    // Household permissions
    @Relationship(.cascade)
    var permissions: [HouseholdPermission]
    
    // Household analytics
    @Relationship(.cascade, inverse: \HouseholdAnalytics.household)
    var analytics: [HouseholdAnalytics]
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.showCombinedView = true
        self.budgetDistributionMode = .proportional
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// Permissions for household members
@Model
final class HouseholdPermission {
    @Attribute(.unique) var id: UUID
    
    @Relationship var household: Household
    @Relationship var user: User
    
    var canViewAllTransactions: Bool
    var canManageBills: Bool
    var canManageSubscriptions: Bool
    var canAddMembers: Bool
    var canRemoveMembers: Bool
    var canSeeFinancialOverview: Bool
    var canModifyBudgets: Bool
    
    init(id: UUID = UUID(), household: Household, user: User) {
        self.id = id
        self.household = household
        self.user = user
        
        // Default permissions
        self.canViewAllTransactions = true
        self.canManageBills = false
        self.canManageSubscriptions = false
        self.canAddMembers = false
        self.canRemoveMembers = false
        self.canSeeFinancialOverview = true
        self.canModifyBudgets = false
    }
}

/// Analytics for household financial data
@Model
final class HouseholdAnalytics {
    @Attribute(.unique) var id: UUID
    var periodStart: Date
    var periodEnd: Date
    
    @Relationship var household: Household
    
    // Aggregated data
    var totalSpending: Decimal
    var spendingByMember: [MemberSpending]
    var spendingByCategory: [CategorySpending]
    var budgetCompliance: Double
    
    // References
    var highestSpenderId: UUID?
    var fastestGrowingCategoryId: UUID?
    
    // Metadata
    var createdAt: Date
    
    init(id: UUID = UUID(), 
         household: Household,
         periodStart: Date,
         periodEnd: Date) {
        self.id = id
        self.household = household
        self.periodStart = periodStart
        self.periodEnd = periodEnd
        self.totalSpending = 0
        self.spendingByMember = []
        self.spendingByCategory = []
        self.budgetCompliance = 0
        self.createdAt = Date()
    }
}

// MARK: - Financial Account Models

/// Financial account from banking institutions
@Model
final class Account {
    @Attribute(.unique) var id: UUID
    var accountId: String
    var name: String
    var officialName: String?
    var type: AccountType
    var subtype: String?
    var mask: String?
    
    // Financial data
    var currentBalance: Decimal?
    var availableBalance: Decimal?
    var creditLimit: Decimal?
    
    var isoCurrencyCode: String
    var status: AccountStatus
    var isManual: Bool
    
    // Relationships
    @Relationship var user: User
    @Relationship var plaidConnection: PlaidConnection?
    
    @Relationship(.cascade, inverse: \Transaction.account)
    var transactions: [Transaction]
    
    // Sync metadata
    @Attribute(.indexed) var lastSync: Date?
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         accountId: String,
         name: String,
         type: AccountType,
         user: User) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.type = type
        self.user = user
        self.isoCurrencyCode = "USD"
        self.status = .active
        self.isManual = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// Plaid connection for linking to financial institutions
@Model
final class PlaidConnection {
    @Attribute(.unique) var id: UUID
    var itemId: String
    
    var accessToken: String
    
    var institutionId: String?
    var institutionName: String?
    var institutionLogo: String?
    var institutionPrimaryColor: String?
    var status: PlaidConnectionStatus
    var isManual: Bool
    
    // Relationships
    @Relationship var user: User
    
    @Relationship(inverse: \Account.plaidConnection)
    var accounts: [Account]
    
    // Sync metadata
    var lastSync: Date?
    var lastSyncAttempt: Date?
    var syncCursor: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         itemId: String,
         accessToken: String,
         user: User) {
        self.id = id
        self.itemId = itemId
        self.accessToken = accessToken
        self.user = user
        self.status = .active
        self.isManual = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Transaction Models

/// Financial transaction
@Model
final class Transaction {
    @Attribute(.unique) var id: UUID
    var plaidTransactionId: String?
    
    var amount: Decimal
    
    @Attribute(.indexed) var date: Date
    var authorizedDate: Date?
    var merchantName: String?
    var name: String?
    var description: String?
    var paymentChannel: String?
    var pending: Bool
    var transactionType: String?
    var originalDescription: String?
    var website: String?
    var merchantLogoUrl: String?
    var customName: String?
    
    // Recurring transaction data
    var isRecurring: Bool
    var recurringType: String?
    var recurringFrequency: String?
    var predictedNextDate: Date?
    var firstRecurringDate: Date?
    var lastRecurringDate: Date?
    var recurringStatus: String?
    var flow: TransactionFlow?
    
    // Category information
    var categoryPath: String?
    var isIncome: Bool
    
    // Relationships
    @Relationship var account: Account
    @Relationship var category: Category?
    @Relationship var owner: User
    
    // For household tracking
    var splitDetails: TransactionSplit?
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         amount: Decimal,
         date: Date,
         account: Account,
         owner: User) {
        self.id = id
        self.amount = amount
        self.date = date
        self.account = account
        self.owner = owner
        self.pending = false
        self.isRecurring = false
        self.isIncome = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Category Models

/// Transaction and bill category
@Model
final class Category {
    @Attribute(.unique) var id: UUID
    var name: String
    var description: String?
    var categoryType: CategoryType
    var isEssential: Bool
    var isDebt: Bool
    var icon: String?
    var color: String?
    
    // Hierarchical relationship
    @Relationship var parent: Category?
    
    @Relationship(inverse: \Category.parent)
    var subcategories: [Category]
    
    // User relationship
    @Relationship var user: User?
    
    // System category (default)
    var isSystem: Bool
    
    // Related items
    @Relationship(inverse: \Transaction.category)
    var transactions: [Transaction]
    
    @Relationship(inverse: \Bill.category)
    var bills: [Bill]
    
    init(id: UUID = UUID(),
         name: String,
         categoryType: CategoryType,
         user: User? = nil) {
        self.id = id
        self.name = name
        self.categoryType = categoryType
        self.user = user
        self.isEssential = false
        self.isDebt = false
        self.isSystem = false
    }
}

/// Budget mapping for categories
@Model
final class BudgetCategoryMapping {
    @Attribute(.unique) var id: UUID
    
    @Relationship var user: User
    @Relationship var category: Category
    
    var budgetAmount: Decimal
    var period: BudgetPeriod
    var startDate: Date
    var endDate: Date?
    
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         user: User,
         category: Category,
         budgetAmount: Decimal,
         period: BudgetPeriod) {
        self.id = id
        self.user = user
        self.category = category
        self.budgetAmount = budgetAmount
        self.period = period
        self.startDate = Date()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Bill Models

/// Bills and recurring expenses
@Model
final class Bill {
    @Attribute(.unique) var id: UUID
    var name: String
    
    var amount: Decimal
    @Attribute(.indexed) var dueDate: Date
    
    var isDebt: Bool
    var isEssential: Bool
    var recurring: Bool
    var autoDraft: Bool
    var paymentMethod: String?
    var status: BillStatus
    var notes: String?
    var attachmentUrl: String?
    var isOneTime: Bool
    
    // Monthly calculation
    var monthlyAmount: Decimal
    var pastDueAmount: Decimal
    
    // Category
    @Relationship var category: Category
    
    // Owner
    @Relationship var owner: User
    
    // For household bills
    var isSharedWithHousehold: Bool
    var splitDetails: BillSplit?
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         name: String,
         amount: Decimal,
         dueDate: Date,
         category: Category,
         owner: User) {
        self.id = id
        self.name = name
        self.amount = amount
        self.dueDate = dueDate
        self.category = category
        self.owner = owner
        
        self.isDebt = false
        self.isEssential = false
        self.recurring = false
        self.autoDraft = false
        self.status = .upcoming
        self.isOneTime = false
        self.monthlyAmount = amount
        self.pastDueAmount = 0
        
        self.isSharedWithHousehold = false
        
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Income Models

/// Income sources
@Model
final class Income {
    @Attribute(.unique) var id: UUID
    var name: String
    
    var amount: Decimal
    var frequency: IncomeFrequency
    var paymentDate: Date
    var isActive: Bool
    
    // Tax and deduction information
    var taxRate: Decimal?
    var deductions: [Deduction]
    var monthlyNetAmount: Decimal?
    
    // Classification
    var category: IncomeCategory
    
    // Relationships
    @Relationship var user: User
    @Relationship var account: Account?
    
    var notes: String?
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         name: String,
         amount: Decimal,
         frequency: IncomeFrequency,
         paymentDate: Date,
         category: IncomeCategory,
         user: User) {
        self.id = id
        self.name = name
        self.amount = amount
        self.frequency = frequency
        self.paymentDate = paymentDate
        self.category = category
        self.user = user
        
        self.isActive = true
        self.deductions = []
        
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Loan Models

/// Unified loan model for all loan types
@Model
final class Loan {
    @Attribute(.unique) var id: UUID
    var accountId: String
    var accountNumber: String?
    var loanType: LoanType
    var loanName: String?
    
    // Financial information
    var currentBalance: Decimal?
    var originalAmount: Decimal?
    
    var interestRate: Decimal?
    var lastPaymentAmount: Decimal?
    var lastPaymentDate: Date?
    var nextPaymentDueDate: Date?
    var minimumPaymentAmount: Decimal?
    var originationDate: Date?
    var maturityDate: Date?
    var loanTerm: Int?
    
    // Type-specific details
    var mortgageDetails: MortgageDetails?
    var studentLoanDetails: StudentLoanDetails?
    var otherLoanDetails: OtherLoanDetails?
    
    // Relationships
    @Relationship var user: User
    @Relationship var plaidConnection: PlaidConnection?
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         accountId: String,
         loanType: LoanType,
         user: User) {
        self.id = id
        self.accountId = accountId
        self.loanType = loanType
        self.user = user
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Goal Models

/// Financial goals
@Model
final class FinancialGoal {
    @Attribute(.unique) var id: UUID
    var goalName: String
    var goalAmount: Decimal
    var currentAmount: Decimal
    var targetDate: Date?
    var goalType: GoalType
    var priority: Int
    var isActive: Bool
    
    // Relationships
    @Relationship var user: User
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         goalName: String,
         goalAmount: Decimal,
         goalType: GoalType,
         user: User) {
        self.id = id
        self.goalName = goalName
        self.goalAmount = goalAmount
        self.currentAmount = 0
        self.goalType = goalType
        self.user = user
        self.priority = 0
        self.isActive = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// Wishlist items
@Model
final class WishlistItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var url: String?
    var price: Decimal?
    var imageUrl: String?
    var notes: String?
    var priority: Int
    
    // Relationships
    @Relationship var user: User
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         title: String,
         user: User) {
        self.id = id
        self.title = title
        self.user = user
        self.priority = 0
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Chat and AI Models

/// Chat history
@Model
final class Chat {
    @Attribute(.unique) var id: UUID
    var title: String?
    var messages: [ChatMessage]
    
    // Relationships
    @Relationship var user: User
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         title: String? = nil,
         user: User) {
        self.id = id
        self.title = title
        self.user = user
        self.messages = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// AI response record
@Model
final class AIResponse {
    @Attribute(.unique) var id: UUID
    var model: String
    var request: [String: Any]
    var response: String
    
    // Metadata
    var createdAt: Date
    
    init(id: UUID = UUID(),
         model: String,
         request: [String: Any],
         response: String) {
        self.id = id
        self.model = model
        self.request = request
        self.response = response
        self.createdAt = Date()
    }
}

// MARK: - Settings Models

/// User settings
@Model
final class UserSettings {
    @Attribute(.unique) var id: UUID
    
    @Relationship var user: User
    
    var category: String
    var settingKey: String
    var settingValue: [String: Any]
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         user: User,
         category: String,
         settingKey: String,
         settingValue: [String: Any]) {
        self.id = id
        self.user = user
        self.category = category
        self.settingKey = settingKey
        self.settingValue = settingValue
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

/// User notifications
@Model
final class UserNotification {
    @Attribute(.unique) var id: UUID
    
    @Relationship var user: User
    
    var notificationType: String
    var enabled: Bool
    var frequency: NotificationFrequency?
    var timeOfDay: Date?
    var lastSentAt: Date?
    
    // Metadata
    var createdAt: Date
    var updatedAt: Date
    
    init(id: UUID = UUID(),
         user: User,
         notificationType: String) {
        self.id = id
        self.user = user
        self.notificationType = notificationType
        self.enabled = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Supporting Types

// User and Household Types
enum HouseholdRole: String, Codable {
    case primary
    case spouse
    case partner
    case child
    case parent
    case roommate
    case other
}

enum BudgetDistributionMode: String, Codable {
    case equal
    case proportional
    case custom
}

struct MemberSpending: Codable {
    var userId: UUID
    var amount: Decimal
    var percentage: Double
}

struct CategorySpending: Codable {
    var categoryId: UUID
    var amount: Decimal
    var percentage: Double
}

// Transaction Types
enum AccountType: String, Codable {
    case checking
    case savings
    case credit
    case investment
    case loan
    case other
}

enum AccountStatus: String, Codable {
    case active
    case inactive
    case closed
}

enum PlaidConnectionStatus: String, Codable {
    case active
    case pending
    case error
    case disconnected
}

enum TransactionFlow: String, Codable {
    case inflow
    case outflow
}

struct TransactionSplit: Codable {
    var splits: [Split]
    
    struct Split: Codable {
        var userId: UUID
        var percentage: Double
        var amount: Decimal
    }
}

// Bill Types
enum BillStatus: String, Codable {
    case paid
    case upcoming
    case overdue
    case pending
}

struct BillSplit: Codable {
    var splits: [Split]
    
    struct Split: Codable {
        var userId: UUID
        var percentage: Double
        var amount: Decimal
        var isPrimary: Bool
    }
}

// Income Types
enum IncomeFrequency: String, Codable {
    case weekly
    case biweekly
    case monthly
    case semiMonthly
    case quarterly
    case annually
    case irregular
}

enum IncomeCategory: String, Codable {
    case salary
    case freelance
    case investment
    case gift
    case other
}

struct Deduction: Codable {
    var name: String
    var amount: Decimal
    var isPreTax: Bool
}

// Loan Types
enum LoanType: String, Codable {
    case mortgage
    case student
    case personal
    case auto
    case other
}

struct MortgageDetails: Codable {
    var escrowBalance: Decimal?
    var hasPmi: Bool?
    var hasPrepaymentPenalty: Bool?
    var propertyAddress: PropertyAddress?
    var ytdInterestPaid: Decimal?
    var ytdPrincipalPaid: Decimal?
}

struct PropertyAddress: Codable {
    var street: String?
    var city: String?
    var state: String?
    var zipCode: String?
}

struct StudentLoanDetails: Codable {
    var disbursementDates: [Date]?
    var expectedPayoffDate: Date?
    var guarantor: String?
    var outstandingInterestAmount: Decimal?
    var repaymentPlan: RepaymentPlan?
    var servicerAddress: ServicerAddress?
}

struct RepaymentPlan: Codable {
    var type: String?
    var description: String?
}

struct ServicerAddress: Codable {
    var street: String?
    var city: String?
    var state: String?
    var zipCode: String?
}

struct OtherLoanDetails: Codable {
    var isOverdue: Bool?
    var lastStatementBalance: Decimal?
    var loanStatus: String?
    var outstandingInterestAmount: Decimal?
    var paymentReferenceNumber: String?
}

// Goal Types
enum GoalType: String, Codable {
    case savings
    case debtReduction
    case retirement
    case emergency
    case major_purchase
    case other
}

// Category Types
enum CategoryType: String, Codable {
    case income
    case expense
    case transfer
    case investment
}

enum BudgetPeriod: String, Codable {
    case weekly
    case monthly
    case quarterly
    case annually
}

// Chat Models
struct ChatMessage: Codable {
    var id: UUID
    var role: String // "user" or "assistant"
    var content: String
    var timestamp: Date
}

// Preferences
struct NotificationPreferences: Codable {
    var email: Bool = true
    var push: Bool = true
    var sms: Bool = false
}

struct UIPreferences: Codable {
    var theme: String = "light"
    var language: String = "en"
    var viewMode: ViewMode = .personal
}

enum ViewMode: String, Codable {
    case personal
    case household
}

enum NotificationFrequency: String, Codable {
    case daily
    case weekly
    case monthly
}

// MARK: - Schema Configuration

extension VersionedSchema.Version {
    static let v1 = Self(1, 0, 0)
}

// Schema setup function
func configureSchema() -> ModelConfiguration {
    let schema = Schema([
        User.self,
        Household.self,
        HouseholdPermission.self,
        HouseholdAnalytics.self,
        Account.self,
        PlaidConnection.self,
        Transaction.self,
        Category.self,
        BudgetCategoryMapping.self,
        Bill.self,
        Income.self,
        Loan.self,
        FinancialGoal.self,
        WishlistItem.self,
        Chat.self,
        AIResponse.self,
        UserSettings.self,
        UserNotification.self
    ], version: VersionedSchema.Version.v1)
    
    return ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
}