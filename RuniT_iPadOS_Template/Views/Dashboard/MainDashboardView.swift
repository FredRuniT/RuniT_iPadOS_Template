import SwiftUI

struct MainDashboardView: View {
    @EnvironmentObject private var financeManager: FinanceManager
    @Environment(\.themeManager) private var themeManager
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                // Top row with Bills Table and Payment Schedule
                HStack(alignment: .top, spacing: 0) {
                    // Bills Table
                    BillsTableView()
                        .padding(.trailing, 8)
                    
                    // Payment Schedule
                    PaymentScheduleView()
                        .frame(width: 300)
                }
                .padding(.bottom, 16)
                
                // Bottom row with three panels
                HStack(alignment: .top, spacing: 16) {
                    // Budget Breakdown
                    BudgetBreakdownView()
                        .frame(maxWidth: .infinity)
                    
                    // Budget Insights
                    BudgetInsightsView()
                        .frame(maxWidth: .infinity)
                    
                    // Financial Freedom Journey
                    FinancialFreedomView()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    // Search field
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        Text("Search...")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("⌘K")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .frame(width: 200)
                    
                    // Refresh button
                    Button(action: { /* Refresh data */ }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.medium)
                    }
                    
                    // User profile
                    Button(action: { /* User profile action */ }) {
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("FB")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        MainDashboardView()
            .environmentObject(FinanceManager())
            .environment(\.themeManager, ThemeManager())
    }
    .previewInterfaceOrientation(.landscapeLeft)
} 
