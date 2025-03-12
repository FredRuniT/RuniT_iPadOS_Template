import SwiftUI

struct BillsTableView: View {
    @State private var selectedTab: BillsTab = .monthly
    @State private var bills: [MonthlyBill] = []
    
    enum BillsTab {
        case monthly, oneTime
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Tab selector
            HStack {
                TabButton(title: "Monthly Bills", isSelected: selectedTab == .monthly) {
                    selectedTab = .monthly
                }
                
                TabButton(title: "One-Time Bills", isSelected: selectedTab == .oneTime) {
                    selectedTab = .oneTime
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: Spacing.md) {
                    Button {
                        // Link to accounts action
                    } label: {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "link")
                                .font(.caption)
                            Text("Link to accounts: Add account")
                                .font(.caption)
                        }
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, 6)
                        .background {
                            Capsule()
                                .stroke(Color.appPrimaryBlue, lineWidth: 1)
                        }
                        .foregroundColor(.appPrimaryBlue)
                    }
                    
                    Button {
                        // View upcoming bills action
                    } label: {
                        Text("Your upcoming bills and payments")
                            .font(.caption)
                            .foregroundColor(.appPrimaryBlue)
                    }
                    
                    Button {
                        // Upload CSV action
                    } label: {
                        HStack(spacing: Spacing.xs) {
                            Image(systemName: "arrow.up.doc")
                                .font(.caption)
                            Text("Upload CSV")
                                .font(.caption)
                        }
                        .foregroundColor(.appPrimaryBlue)
                    }
                    
                    Button {
                        // Add new bill action
                    } label: {
                        Image(systemName: "plus")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.appPrimaryBlue)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
            
            // Table header
            HStack(spacing: 0) {
                Text("Name")
                    .frame(width: 180, alignment: .leading)
                
                Text("Monthly Amount")
                    .frame(width: 120, alignment: .trailing)
                
                Text("Past Due")
                    .frame(width: 120, alignment: .trailing)
                
                Text("Due Date")
                    .frame(width: 120, alignment: .leading)
                
                Text("Status")
                    .frame(width: 100, alignment: .leading)
                
                Text("Category")
                    .frame(width: 40, alignment: .center)
                
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.xs)
            .background(Color.gray.opacity(0.1))
            
            // Table rows
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(sampleBills) { bill in
                        BillRowView(bill: bill)
                            .padding(.vertical, Spacing.xs)
                            .padding(.horizontal, Spacing.md)
                            .background(
                                Color.white
                                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                            )
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // Sample data for preview
    private var sampleBills: [MonthlyBill] {
        [
            MonthlyBill(
                name: "SBA for PhrameBooth",
                monthlyAmount: 573.00,
                pastDue: 573.00,
                dueDate: Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 20))!,
                status: .late,
                category: "Entertainment Services",
                daysPastDue: 813
            ),
            MonthlyBill(
                name: "SBA for RunIT",
                monthlyAmount: 315.00,
                pastDue: 315.00,
                dueDate: Calendar.current.date(from: DateComponents(year: 2022, month: 12, day: 21))!,
                status: .late,
                category: "Entertainment Services",
                daysPastDue: 812
            ),
            MonthlyBill(
                name: "Life Insurance",
                monthlyAmount: 394.20,
                pastDue: 394.20,
                dueDate: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 14))!,
                status: .late,
                category: "Entertainment Services",
                daysPastDue: 576
            ),
            MonthlyBill(
                name: "Dentist Bill",
                monthlyAmount: 2384.90,
                pastDue: 2384.90,
                dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 16))!,
                status: .late,
                category: "Entertainment Services",
                daysPastDue: 361
            ),
            MonthlyBill(
                name: "Airport Parking Fees",
                monthlyAmount: 111.00,
                pastDue: 111.00,
                dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 11))!,
                status: .late,
                category: "Entertainment Services",
                daysPastDue: 274
            )
        ]
    }
}

// Tab button component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.vertical, Spacing.sm)
                .padding(.horizontal, Spacing.md)
                .background(isSelected ? Color.black : Color.clear)
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(4)
        }
    }
}

// Bill row component
struct BillRowView: View {
    let bill: MonthlyBill
    
    var body: some View {
        HStack(spacing: 0) {
            // Name column with avatar
            HStack(spacing: Spacing.sm) {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(bill.name)
                        .font(.subheadline)
                    
                    Text("\(bill.daysPastDue) days past due")
                        .font(.caption2)
                        .foregroundColor(.appDangerRed)
                }
            }
            .frame(width: 180, alignment: .leading)
            
            // Monthly Amount
            Text("$\(bill.monthlyAmount, specifier: "%.2f")")
                .font(.system(.subheadline, design: .monospaced))
                .frame(width: 120, alignment: .trailing)
            
            // Past Due
            Text("$\(bill.pastDue, specifier: "%.2f")")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.appDangerRed)
                .frame(width: 120, alignment: .trailing)
            
            // Due Date
            Text(formattedDate(bill.dueDate))
                .font(.subheadline)
                .frame(width: 120, alignment: .leading)
            
            // Status
            HStack {
                Text(bill.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, Spacing.xs)
                    .padding(.vertical, 4)
                    .background(statusColor(bill.status).opacity(0.2))
                    .foregroundColor(statusColor(bill.status))
                    .cornerRadius(4)
            }
            .frame(width: 100, alignment: .leading)
            
            // Category - Simplified to just show the color icon
            Circle()
                .fill(Color.appPrimaryBlue)
                .frame(width: 8, height: 8)
                .frame(width: 40, alignment: .center)
            
            // Actions
            Spacer()
            
            Button {
                // Show actions menu
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, Spacing.sm)
        }
        .padding(.vertical, Spacing.xs)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func statusColor(_ status: MonthlyBill.BillStatus) -> Color {
        switch status {
        case .paid:
            return .appSuccessGreen
        case .pending:
            return .appCautionOrange
        case .late:
            return .appDangerRed
        }
    }
}

#Preview {
    BillsTableView()
        .padding()
        .frame(height: 500)
} 