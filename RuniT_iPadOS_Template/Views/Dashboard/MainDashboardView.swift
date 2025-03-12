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
    @State private var showingAddBillSheet = false
    @State private var selectedBill: MonthlyBill?
    @State private var isCustomizingDashboard = false
    @State private var dashboardLayout: DashboardLayout = .default
    @State private var pinnedActions: [QuickAction] = [.addBill, .payBill, .setBudget, .schedulePayment]
    
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
                Button(action: { isCustomizingDashboard.toggle() }) {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    NavigationView {
        MainDashboardView()
            .environmentObject(FinanceManager())
            .environment(\.themeManager, ThemeManager())
    }
}