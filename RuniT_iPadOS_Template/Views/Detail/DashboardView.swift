import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    
    init(financeManager: FinanceManager) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(financeManager: financeManager))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Net Worth Summary
                netWorthCard
                
                // Monthly Cash Flow and Upcoming Bills
                HStack(spacing: 16) {
                    cashFlowCard
                    upcomingBillsCard
                }
                .frame(minHeight: 200)
                
                // Recent Transactions
                recentTransactionsCard
                
                // Spending by Category
                spendingByCategoryCard
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { /* Refresh data */ }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    // MARK: - Card Views
    
    private var netWorthCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Net Worth")
                .font(.headline)
            
            Text(viewModel.formatCurrency(viewModel.netWorth))
                .font(.title)
                .bold()
            
            HStack {
                Text("Total Assets:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(viewModel.formatCurrency(max(viewModel.netWorth, 0)))
            }
            
            HStack {
                Text("Total Liabilities:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(viewModel.formatCurrency(abs(min(viewModel.netWorth, 0))))
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
    
    private var cashFlowCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Monthly Cash Flow")
                .font(.headline)
            
            Text(viewModel.formatCurrency(viewModel.monthlyCashFlow))
                .font(.title2)
                .bold()
                .foregroundColor(viewModel.monthlyCashFlow >= 0 ? .green : .red)
            
            HStack {
                Text("Income:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(viewModel.formatCurrency(viewModel.monthlyIncome))
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Expenses:")
                    .foregroundColor(.secondary)
                Spacer()
                Text(viewModel.formatCurrency(viewModel.monthlyExpenses))
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
    
    private var upcomingBillsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Upcoming Bills")
                .font(.headline)
            
            if viewModel.upcomingBills.isEmpty {
                Text("No upcoming bills")
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            } else {
                ForEach(viewModel.upcomingBills.prefix(3)) { bill in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(bill.name)
                                .fontWeight(.medium)
                            Text("Due in \(viewModel.daysUntil(date: bill.dueDate)) days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(viewModel.formatCurrency(bill.amount))
                            .fontWeight(.semibold)
                    }
                    .padding(.vertical, 4)
                    
                    if bill.id != viewModel.upcomingBills.prefix(3).last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
    
    private var recentTransactionsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Transactions")
                .font(.headline)
            
            if viewModel.recentTransactions.isEmpty {
                Text("No recent transactions")
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            } else {
                ForEach(viewModel.recentTransactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.description)
                                .fontWeight(.medium)
                            Text(viewModel.formatDate(transaction.date))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(viewModel.formatCurrency(transaction.amount))
                            .fontWeight(.semibold)
                            .foregroundColor(transaction.amount >= 0 ? .green : .red)
                    }
                    .padding(.vertical, 4)
                    
                    if transaction.id != viewModel.recentTransactions.last?.id {
                        Divider()
                    }
                }
                
                Button(action: { /* View all transactions */ }) {
                    Text("View All Transactions")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
    
    private var spendingByCategoryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Spending by Category")
                .font(.headline)
            
            if viewModel.spendingByCategory.isEmpty {
                Text("No spending data available")
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            } else {
                ForEach(Array(viewModel.spendingByCategory.keys.sorted { viewModel.spendingByCategory[$0]! > viewModel.spendingByCategory[$1]! }).prefix(5), id: \.self) { category in
                    if let amount = viewModel.spendingByCategory[category] {
                        HStack {
                            Text(category.rawValue)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text(viewModel.formatCurrency(amount))
                                .fontWeight(.semibold)
                        }
                        .padding(.vertical, 4)
                        
                        // Progress bar showing percentage of total spending
                        let totalSpending = viewModel.spendingByCategory.values.reduce(0, +)
                        let percentage = totalSpending > 0 ? amount / totalSpending : 0
                        
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: geometry.size.width, height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * CGFloat(percentage), height: 8)
                                .cornerRadius(4)
                        }
                        .frame(height: 8)
                        
                        if category != Array(viewModel.spendingByCategory.keys.sorted { viewModel.spendingByCategory[$0]! > viewModel.spendingByCategory[$1]! }).prefix(5).last {
                            Divider()
                        }
                    }
                }
                
                Button(action: { /* View spending breakdown */ }) {
                    Text("View Full Breakdown")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.indigo.opacity(0.1))
        .cornerRadius(AppConstants.UI.cornerRadius)
    }
} 