import SwiftUI

// Standard Card
struct StandardCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Spacing.md)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
    }
}

// Account Card
struct AccountCard: View {
    let name: String
    let institution: String
    let balance: Double
    let type: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text(name)
                    .font(.titleSmall)
                Spacer()
                Text(type)
                    .font(.captionRegular)
                    .padding(.horizontal, Spacing.xs)
                    .padding(.vertical, 4)
                    .background {
                        Capsule()
                            .fill(Color.appPrimaryBlue.opacity(0.2))
                    }
            }
            
            Text(institution)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(balance, format: .currency(code: "USD"))
                .font(.currencyRegular)
                .foregroundColor(Color.forAmount(balance))
        }
        .padding(Spacing.md)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .frame(height: 120)
    }
}

// Transaction Card
struct TransactionCard: View {
    let merchantName: String
    let date: Date
    let amount: Double
    let category: String
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            ZStack {
                Circle()
                    .fill(Color.appPrimaryBlue.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: categoryIcon)
                    .foregroundColor(.appPrimaryBlue)
            }
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(merchantName)
                    .font(.headline)
                
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(amount, format: .currency(code: "USD"))
                .font(.currencySmall)
                .foregroundColor(Color.forAmount(amount))
        }
        .padding(Spacing.md)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        }
    }
    
    private var categoryIcon: String {
        switch category.lowercased() {
        case "food", "dining", "restaurant":
            return "fork.knife"
        case "shopping":
            return "bag"
        case "transportation", "transit":
            return "car"
        case "housing", "rent", "mortgage":
            return "house"
        case "utilities":
            return "bolt"
        case "entertainment":
            return "tv"
        case "health", "medical":
            return "heart"
        case "education":
            return "book"
        case "travel":
            return "airplane"
        case "income", "salary":
            return "arrow.down.circle"
        default:
            return "dollarsign.circle"
        }
    }
}

// Budget Progress Card
struct BudgetProgressCard: View {
    let spent: Double
    let total: Double
    let category: String
    
    private var percentage: Double {
        min(spent / total, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Text(category)
                    .font(.headline)
                Spacer()
                Text("\(Int(percentage * 100))%")
                    .font(.percentageRegular)
                    .foregroundColor(Color.forBudgetProgress(percentage))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.forBudgetProgress(percentage))
                        .frame(width: geometry.size.width * percentage, height: 8)
                }
            }
            .frame(height: 8)
            
            HStack {
                Text(spent, format: .currency(code: "USD"))
                    .font(.captionRegular)
                Spacer()
                Text(total, format: .currency(code: "USD"))
                    .font(.captionRegular)
                    .foregroundColor(.secondary)
            }
        }
        .padding(Spacing.md)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        }
    }
}

// Preview Provider
struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            StandardCard {
                Text("Standard Card")
                    .padding()
            }
            
            AccountCard(
                name: "Checking Account",
                institution: "Bank of America",
                balance: 2543.67,
                type: "Checking"
            )
            
            TransactionCard(
                merchantName: "Starbucks",
                date: Date(),
                amount: -4.95,
                category: "Food"
            )
            
            BudgetProgressCard(
                spent: 750,
                total: 1000,
                category: "Dining"
            )
        }
        .padding()
    }
} 