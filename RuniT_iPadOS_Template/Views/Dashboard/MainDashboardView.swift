import SwiftUI
import Combine

// Dashboard layout options
enum DashboardLayout {
    case `default`
    case focusedBills
    case focusedCalendar
    case stacked
}

// Quick action model
struct QuickAction: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    
    static func == (lhs: QuickAction, rhs: QuickAction) -> Bool {
        return lhs.title == rhs.title
    }
    
    static let addBill = QuickAction(title: "Add Bill", icon: "plus.circle.fill", color: .blue)
    static let payBill = QuickAction(title: "Pay Bill", icon: "dollarsign.circle.fill", color: .green)
    static let setBudget = QuickAction(title: "Set Budget", icon: "chart.pie.fill", color: .orange)
    static let viewReports = QuickAction(title: "View Reports", icon: "chart.bar.fill", color: .purple)
    static let addReminder = QuickAction(title: "Add Reminder", icon: "bell.fill", color: .red)
    static let schedulePayment = QuickAction(title: "Schedule Payment", icon: "calendar.badge.clock", color: .blue)
    
    static let allActions = [addBill, payBill, setBudget, viewReports, addReminder, schedulePayment]
}

// Quick action button component
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MainDashboardView: View {
    @EnvironmentObject private var financeManager: FinanceManager
    @Environment(\.themeManager) private var themeManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var userManager: UserManager
    @State private var showingAddBillSheet = false
    @State private var selectedBill: MonthlyBill?
    @State private var isCustomizingDashboard = false
    @State private var dashboardLayout: DashboardLayout = .default
    @State private var pinnedActions: [QuickAction] = [.addBill, .payBill, .setBudget, .schedulePayment]
    @State private var showSearch = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with quick actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to RuniT Finance")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Your financial command center")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Quick actions row
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 16)
                    ], spacing: 16) {
                        ForEach(pinnedActions) { action in
                            QuickActionButton(
                                title: action.title,
                                icon: action.icon,
                                color: action.color
                            ) {
                                if action.title == "Add Bill" {
                                    showingAddBillSheet = true
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // Main dashboard content
                HStack(alignment: .top, spacing: 20) {
                    // Left column: Bills table
                    BillsTableView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 600)
                    
                    // Right column: Calendar and insights
                    VStack(spacing: 20) {
                        // Payment schedule
                        PaymentScheduleView()
                            .frame(height: 350)
                        
                        // Budget insights
                        BudgetInsightsView()
                            .frame(height: 230)
                    }
                    .frame(width: horizontalSizeClass == .regular ? 350 : nil)
                }
                
                // Bottom row - additional widgets
                HStack(spacing: 20) {
                    // Financial freedom progress
                    FinancialFreedomView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                    
                    // Budget breakdown
                    BudgetBreakdownView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingAddBillSheet) {
            Text("Add Bill Form")
                .padding()
        }
        .navigationTitle("Dashboard")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Stylish Command+K search button
                Button(action: { showSearch.toggle() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        Text("Ask Me Anything...")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("⌘K")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .cornerRadius(4)
                    }
                    .padding(8)
                    .frame(width: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Material.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .commonKeyboardShortcut("k")
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                // User avatar button
                Button(action: { /* User profile action */ }) {
                    if let user = userManager.currentUser, let photoURL = user.avatarURL {
                        AsyncImage(url: photoURL) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .help("User Profile")
            }
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
                .environmentObject(financeManager)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    NavigationView {
        MainDashboardView()
            .environmentObject(FinanceManager())
            .environmentObject(UserManager())
            .environment(\.themeManager, ThemeManager())
    }
}

// Search view with search bar and results
struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var financeManager: FinanceManager
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Ask Me Anything...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(size: 16, weight: .regular, design: .default))
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Material.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
                .padding(.horizontal)
                
                // Search results
                if searchText.isEmpty {
                    // Recent searches and suggestions
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Recent Searches")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(["unpaid bills", "groceries", "netflix"], id: \.self) { term in
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                Text(term)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                searchText = term
                            }
                        }
                        
                        Text("Suggested Searches")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ForEach(["bills due this week", "highest expenses", "monthly budget"], id: \.self) { term in
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.secondary)
                                Text(term)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                searchText = term
                            }
                        }
                    }
                    .padding(.top)
                } else {
                    // Search results list
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing:.zero) {
                            // Filter bills by search text
                            let filteredBills = financeManager.monthlyBills.filter {
                                $0.name.localizedCaseInsensitiveContains(searchText) ||
                                $0.category.localizedCaseInsensitiveContains(searchText)
                            }
                            
                            if !filteredBills.isEmpty {
                                sectionHeader("Bills")
                                
                                ForEach(filteredBills) { bill in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(bill.name)
                                                .font(.body)
                                            
                                            Text(bill.category)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("$\(bill.monthlyAmount, specifier: "%.2f")")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .onTapGesture {
                                        // Handle selection
                                        dismiss()
                                    }
                                    
                                    Divider()
                                        .padding(.leading)
                                }
                            }
                            
                            // Additional search results would be here
                            Text("No more results")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
    }
}