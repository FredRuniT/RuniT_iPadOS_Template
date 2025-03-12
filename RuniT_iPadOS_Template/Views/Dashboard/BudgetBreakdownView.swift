import SwiftUI

struct BudgetBreakdownView: View {
    // Sample data
    private let totalBudget: Double = 1500.0
    private let spentAmount: Double = 1203.0
    
    private let categories: [BudgetCategory] = [
        BudgetCategory(name: "Housing", amount: 450.0, percentage: 30.0, icon: "house.fill"),
        BudgetCategory(name: "Drinks & dining", amount: 300.0, percentage: 20.0, icon: "cup.and.saucer.fill"),
        BudgetCategory(name: "Auto & transport", amount: 225.0, percentage: 15.0, icon: "car.fill"),
        BudgetCategory(name: "Childcare & education", amount: 150.0, percentage: 10.0, icon: "book.fill"),
        BudgetCategory(name: "Utilities", amount: 150.0, percentage: 10.0, icon: "bolt.fill"),
        BudgetCategory(name: "Entertainment", amount: 120.0, percentage: 8.0, icon: "tv.fill"),
        BudgetCategory(name: "Healthcare", amount: 105.0, percentage: 7.0, icon: "heart.fill"),
        BudgetCategory(name: "Shopping", amount: 60.0, percentage: 4.0, icon: "bag.fill"),
        BudgetCategory(name: "Savings", amount: 45.0, percentage: 3.0, icon: "banknote.fill"),
        BudgetCategory(name: "Other", amount: 45.0, percentage: 3.0, icon: "ellipsis.circle.fill")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Budget Breakdown")
                    .titleSmallStyle()
                
                Text("Your monthly spending by category")
                    .captionStyle()
            }
            .padding(.horizontal, Spacing.md)
            
            // Progress bar
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("$\(Int(spentAmount)) of $\(Int(totalBudget))")
                    .font(.subheadline)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(progressColor)
                            .frame(width: geometry.size.width * progressPercentage, height: 8)
                    }
                }
                .frame(height: 8)
                
                Text("\(Int(progressPercentage * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, Spacing.md)
            
            // Categories list
            ScrollView {
                VStack(spacing: Spacing.sm) {
                    ForEach(categories) { category in
                        BudgetCategoryRow(category: category)
                    }
                }
                .padding(.horizontal, Spacing.md)
            }
        }
        .padding(.vertical, Spacing.md)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var progressPercentage: Double {
        min(spentAmount / totalBudget, 1.0)
    }
    
    private var progressColor: Color {
        if progressPercentage < 0.7 {
            return .appSuccessGreen
        } else if progressPercentage < 0.9 {
            return .appCautionOrange
        } else {
            return .appDangerRed
        }
    }
}

struct BudgetCategoryRow: View {
    let category: BudgetCategory
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Icon
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 28, height: 28)
                
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                    .foregroundColor(categoryColor)
            }
            
            // Category name
            Text(category.name)
                .font(.subheadline)
            
            Spacer()
            
            // Percentage
            Text("\(Int(category.percentage))%")
                .font(.system(.subheadline, design: .monospaced))
            
            // Mini progress bar
            RoundedRectangle(cornerRadius: 2)
                .fill(categoryColor)
                .frame(width: 50 * (category.percentage / 100), height: 4)
                .frame(width: 50, alignment: .leading)
        }
        .padding(.vertical, Spacing.xs)
    }
    
    private var categoryColor: Color {
        switch category.name.lowercased() {
        case "housing":
            return .green
        case "drinks & dining":
            return .orange
        case "auto & transport":
            return .blue
        case "childcare & education":
            return .purple
        case "utilities":
            return .yellow
        case "entertainment":
            return .pink
        case "healthcare":
            return .red
        case "shopping":
            return .teal
        case "savings":
            return .appPrimaryBlue
        default:
            return .gray
        }
    }
}

#Preview {
    BudgetBreakdownView()
        .frame(width: 350, height: 500)
        .padding()
} 