import Foundation

/// Database configuration for table and column names
/// Provides a type-safe way to reference database schema elements
struct DatabaseConfig {
    /// Database table names
    struct Tables {
        /// Table name for monthly bills
        static let monthlyBills = "monthly_bills"
    }
    
    /// Column names for the monthly bills table
    struct MonthlyBillColumns {
        /// Primary key column
        static let id = "id"
        /// Name of the bill
        static let name = "name"
        /// Monthly amount due
        static let monthlyAmount = "monthly_amount"
        /// Whether the bill is past due
        static let pastDue = "past_due"
        /// Due date for the bill
        static let dueDate = "due_date"
        /// Status of the bill (paid, unpaid, etc.)
        static let status = "status"
        /// Category of the bill
        static let category = "category"
        /// Number of days past due
        static let daysPastDue = "days_past_due"
    }
}