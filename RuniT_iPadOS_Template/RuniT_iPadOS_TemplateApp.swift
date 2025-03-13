import SwiftUI
import SwiftData

@main
struct RuniT_iPadOS_TemplateApp: App {
    @StateObject private var userManager = UserManager()
    @StateObject private var financeManager = FinanceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(financeManager)
                .environment(\.themeManager, ThemeManager())
        }
        .modelContainer(for: [
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
        ], configurations: {
            // Use the configuration from DatabaseConfig
            configureSchema()
        })
    }
}