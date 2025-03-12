import SwiftUI

struct BillsTableView: View {
    @EnvironmentObject private var financeManager: FinanceManager
    @State private var selectedTab: BillsTab = .monthly
    @State private var sortOrder: [KeyPathComparator<MonthlyBill>] = [
        .init(\.name, order: .forward)
    ]
    @State private var filterStatus: MonthlyBill.BillStatus?
    @State private var searchText: String = ""
    @State private var selectedBill: MonthlyBill?
    @State private var showBillDetail = false
    var onBillSelected: ((MonthlyBill) -> Void)?
    
    enum BillsTab: String, CaseIterable {
        case monthly = "Monthly Bills"
        case oneTime = "One-Time Bills"
    }
    
    // Computed property for filtered bills
    private var filteredBills: [MonthlyBill] {
        // Start with sample bills for preview or actual bills from finance manager
        let bills = financeManager.monthlyBills.isEmpty ? sampleBills : financeManager.monthlyBills
        
        // Apply filters
        return bills.filter { bill in
            let matchesSearch = searchText.isEmpty || 
                bill.name.localizedCaseInsensitiveContains(searchText) ||
                bill.category.localizedCaseInsensitiveContains(searchText)
            
            let matchesStatus = filterStatus == nil || bill.status == filterStatus
            
            return matchesSearch && matchesStatus
        }
    }
    
    init(onBillSelected: ((MonthlyBill) -> Void)? = nil) {
        self.onBillSelected = onBillSelected
        _selectedBill = State(initialValue: nil)
        _showBillDetail = State(initialValue: false)
    }
    
    // Bill detail view shown when a bill is tapped
    struct BillDetailsSheet: View {
        let bill: MonthlyBill
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            NavigationView {
                VStack {
                    Text("Bill Details: \(bill.name)")
                        .font(.headline)
                    
                    VStack(alignment: .leading) {
                        Text("Amount: $\(bill.monthlyAmount, specifier: "%.2f")")
                        Text("Due Date: \(formattedDate(bill.dueDate))")
                        Text("Status: \(bill.status.rawValue)")
                        Text("Category: \(bill.category)")
                    }
                    .padding()
                    
                    Spacer()
                }
                .navigationBarItems(trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
        
        private func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with title and actions
            HStack {
                Text("Bills & Payments")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Tab selector for bill types
                Picker("Bill Type", selection: $selectedTab) {
                    ForEach(BillsTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 240)
                
                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search bills", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(width: 200)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Bills table
            VStack {
                // Table header
                HStack {
                    Text("Name")
                        .fontWeight(.medium)
                        .frame(width: 200, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Amount")
                        .fontWeight(.medium)
                        .frame(width: 100, alignment: .trailing)
                    
                    Text("Due Date")
                        .fontWeight(.medium)
                        .frame(width: 120, alignment: .trailing)
                    
                    Text("Status")
                        .fontWeight(.medium)
                        .frame(width: 100, alignment: .trailing)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                
                // Bills list
                if financeManager.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if filteredBills.isEmpty {
                    Spacer()
                    Text("No bills found")
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    List {
                        ForEach(filteredBills) { bill in
                            HStack {
                                Text(bill.name)
                                    .fontWeight(.medium)
                                    .frame(width: 200, alignment: .leading)
                                
                                Spacer()
                                
                                Text("$\(bill.monthlyAmount, specifier: "%.2f")")
                                    .monospacedDigit()
                                    .frame(width: 100, alignment: .trailing)
                                
                                Text(formattedDate(bill.dueDate))
                                    .frame(width: 120, alignment: .trailing)
                                
                                Text(bill.status.rawValue)
                                    .foregroundColor(statusColor(bill.status))
                                    .frame(width: 100, alignment: .trailing)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedBill = bill
                                showBillDetail = true
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .sheet(isPresented: $showBillDetail, content: {
            if let bill = selectedBill {
                BillDetailsSheet(bill: bill)
            }
        })
    }
    
    // Helper function to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    // Helper function to get status color
    private func statusColor(_ status: MonthlyBill.BillStatus) -> Color {
        switch status {
        case .paid: return .green
        case .unpaid: return .blue
        case .scheduled: return .orange
        case .late: return .red
        }
    }
    
    // Handle bill tap
    private func handleBillTap(_ bill: MonthlyBill) {
        selectedBill = bill
        if let callback = onBillSelected {
            callback(bill)
        } else {
            showBillDetail = true
        }
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
                category: "Insurance",
                daysPastDue: 576
            ),
            MonthlyBill(
                name: "Dentist Bill",
                monthlyAmount: 2384.90,
                pastDue: 2384.90,
                dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 16))!,
                status: .late,
                category: "Healthcare",
                daysPastDue: 361
            ),
            MonthlyBill(
                name: "Airport Parking Fees",
                monthlyAmount: 111.00,
                pastDue: 111.00,
                dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 11))!,
                status: .late,
                category: "Transportation",
                daysPastDue: 274
            )
        ]
    }
}