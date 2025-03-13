import Foundation
import SwiftData

/// Configuration constants for database access
struct DatabaseConfig {
    /// Legacy database table names (for external database connections)
    struct Tables {
        static let monthlyBills = "monthly_bills"
        static let users = "users"
        static let accounts = "accounts"
        static let transactions = "transactions"
    }
    
    /// Monthly bill column names (for external database connections)
    struct MonthlyBillColumns {
        static let id = "id"
        static let name = "name"
        static let monthlyAmount = "monthly_amount"
        static let pastDue = "past_due"
        static let dueDate = "due_date"
        static let status = "status"
        static let category = "category"
        static let daysPastDue = "days_past_due"
    }
    
    /// SwiftData Configuration
    struct SwiftData {
        // Constants for database configuration
        enum Constants {
            static let schemaVersion = "1.0.0"
            static let defaultDatabaseName = "RuniT_Finance.sqlite"
        }
        
        // Database URL
        static var databaseURL: URL? {
            let fileManager = FileManager.default
            guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            
            return documentsURL.appendingPathComponent(Constants.defaultDatabaseName)
        }
        
        // Create model configurations
        static func createModelConfiguration() -> ModelConfiguration {
            return configureSchema()
        }
        
        // Create model container - for use in previews or tests
        static func createPreviewContainer() -> ModelContainer {
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                let container = try ModelContainer(for: [
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
                ], configurations: config)
                return container
            } catch {
                fatalError("Failed to create model container: \(error.localizedDescription)")
            }
        }
    }
}