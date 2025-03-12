import SwiftUI

struct BudgetInsightsView: View {
    @State private var selectedTab: InsightsTab = .overview
    
    // Sample data
    private let budgetInsight = BudgetInsight(
        id: UUID(),
        income: 5154.05,
        expenses: 4295.04,
        savings: 859.01,
        needsPercentage: 0.0,
        needsTarget: 50.0,
        wantsPercentage: 83.3,
        wantsTarget: 30.0,
        goalsPercentage: 0.0
    )
    
    enum InsightsTab {
        case overview, breakdown
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Budget Insights")
                    .titleSmallStyle()
                
                Text("30-day overview of your spending habits")
                    .captionStyle()
            }
            .padding(.horizontal, Spacing.md)
            
            // Tab selector
            HStack {
                Button {
                    selectedTab = .overview
                } label: {
                    Text("Overview")
                        .font(.subheadline)
                        .padding(.vertical, Spacing.xs)
                        .padding(.horizontal, Spacing.sm)
                        .background(selectedTab == .overview ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(4)
                        .foregroundColor(selectedTab == .overview ? .primary : .secondary)
                }
                
                Button {
                    selectedTab = .breakdown
                } label: {
                    Text("Breakdown")
                        .font(.subheadline)
                        .padding(.vertical, Spacing.xs)
                        .padding(.horizontal, Spacing.sm)
                        .background(selectedTab == .breakdown ? Color.gray.opacity(0.2) : Color.clear)
                        .cornerRadius(4)
                        .foregroundColor(selectedTab == .breakdown ? .primary : .secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, Spacing.md)
            
            if selectedTab == .overview {
                overviewContent
            } else {
                breakdownContent
            }
        }
        .padding(.vertical, Spacing.md)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var overviewContent: some View {
        VStack(spacing: Spacing.md) {
            // Financial cards
            HStack(spacing: Spacing.md) {
                FinancialCardView(
                    title: "Income",
                    amount: budgetInsight.income,
                    iconName: "arrow.down.circle.fill",
                    iconColor: .appSuccessGreen
                )
                
                FinancialCardView(
                    title: "Expenses",
                    amount: budgetInsight.expenses,
                    iconName: "arrow.up.circle.fill",
                    iconColor: .appDangerRed
                )
                
                FinancialCardView(
                    title: "Savings",
                    amount: budgetInsight.savings,
                    iconName: "banknote.fill",
                    iconColor: .appPrimaryBlue
                )
            }
            .padding(.horizontal, Spacing.md)
            
            // Budget Distribution
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text("Budget Distribution")
                    .font(.headline)
                    .padding(.horizontal, Spacing.md)
                
                // Needs
                BudgetDistributionRow(
                    title: "Needs",
                    percentage: budgetInsight.needsPercentage,
                    target: budgetInsight.needsTarget,
                    color: .appSuccessGreen
                )
                
                // Wants
                BudgetDistributionRow(
                    title: "Wants",
                    percentage: budgetInsight.wantsPercentage,
                    target: budgetInsight.wantsTarget,
                    color: .appCautionOrange
                )
                
                // Goals
                BudgetDistributionRow(
                    title: "Goals",
                    percentage: budgetInsight.goalsPercentage,
                    target: 0,
                    color: .appPrimaryBlue
                )
            }
        }
    }
    
    private var breakdownContent: some View {
        Text("Detailed breakdown coming soon")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
}

struct FinancialCardView: View {
    let title: String
    let amount: Double
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.system(.headline, design: .monospaced))
        }
        .padding(Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct BudgetDistributionRow: View {
    let title: String
    let percentage: Double
    let target: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Text("\(percentage, specifier: "%.1f")%")
                    .font(.system(.subheadline, design: .monospaced))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    // Progress bar
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
            
            if target > 0 {
                Text("Target: \(Int(target))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.xs)
    }
}

#Preview {
    BudgetInsightsView()
        .frame(width: 350, height: 500)
        .padding()
} 