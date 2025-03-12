//
//  ContentView.swift
//  RuniT_iPadOS_Template
//
//  Created by Fredrick Burns on 3/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @StateObject private var userManager = UserManager()
    @StateObject private var financeManager = FinanceManager()
    
    @State private var selectedSidebarItem: SidebarItem? = .dashboard
    @State private var selectedDetailItem: UUID? = nil
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @State private var showSettings = false
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selection: $selectedSidebarItem)
                .environmentObject(userManager)
        } detail: {
            if let selectedItem = selectedSidebarItem {
                mainContentView(for: selectedItem)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showSettings = true
                            }) {
                                if let photoURL = userManager.currentUser?.avatarURL {
                                    AsyncImage(url: photoURL) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "gear")
                                        .imageScale(.large)
                                }
                            }
                            .help("Settings")
                        }
                    }
            } else {
                Text("Select an item from the sidebar")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ToggleSidebar"))) { _ in
            withAnimation {
                toggleSidebar()
            }
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                Text("Settings")
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showSettings = false
                            }
                        }
                    }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    private func toggleSidebar() {
        columnVisibility = columnVisibility == .all ? .detailOnly : .all
    }
    
    @ViewBuilder
    private func mainContentView(for item: SidebarItem) -> some View {
        switch item {
        case .dashboard:
            MainDashboardView()
                .environmentObject(financeManager)
        case .accounts:
            AccountsView()
                .environmentObject(financeManager)
        case .transactions:
            TransactionsView()
                .environmentObject(financeManager)
        case .bills:
            BillsView()
                .environmentObject(financeManager)
        case .insights:
            InsightsView()
                .environmentObject(financeManager)
        case .income:
            IncomeView()
                .environmentObject(financeManager)
        case .budget:
            BudgetView()
                .environmentObject(financeManager)
        case .goals:
            GoalsView()
                .environmentObject(financeManager)
        case .wishlist:
            WishlistView()
                .environmentObject(financeManager)
        case .loans:
            LoansView()
                .environmentObject(financeManager)
        case .mortgages:
            MortgagesView()
                .environmentObject(financeManager)
        case .studentLoans:
            StudentLoansView()
                .environmentObject(financeManager)
        case .familyMembers:
            FamilyMembersView()
                .environmentObject(financeManager)
        case .aiChat:
            AIChatView()
                .environmentObject(financeManager)
        }
    }
    
    // Placeholder views for content
    struct AccountsView: View {
        var body: some View {
            Text("Accounts View")
                .font(.largeTitle)
                .navigationTitle("Accounts")
        }
    }
    
    struct TransactionsView: View {
        var body: some View {
            Text("Transactions View")
                .font(.largeTitle)
                .navigationTitle("Transactions")
        }
    }
    
    struct BillsView: View {
        var body: some View {
            Text("Bills View")
                .font(.largeTitle)
                .navigationTitle("Bills")
        }
    }
    
    struct InsightsView: View {
        var body: some View {
            Text("Insights View")
                .font(.largeTitle)
                .navigationTitle("Insights")
        }
    }
    
    struct IncomeView: View {
        var body: some View {
            Text("Income View")
                .font(.largeTitle)
                .navigationTitle("Income")
        }
    }
    
    struct BudgetView: View {
        var body: some View {
            Text("Budget View")
                .font(.largeTitle)
                .navigationTitle("Budget")
        }
    }
    
    struct GoalsView: View {
        var body: some View {
            Text("Goals View")
                .font(.largeTitle)
                .navigationTitle("Goals")
        }
    }
    
    struct WishlistView: View {
        var body: some View {
            Text("Wishlist View")
                .font(.largeTitle)
                .navigationTitle("Wishlist")
        }
    }
    
    struct LoansView: View {
        var body: some View {
            Text("Loans View")
                .font(.largeTitle)
                .navigationTitle("Loans")
        }
    }
    
    struct MortgagesView: View {
        var body: some View {
            Text("Mortgages View")
                .font(.largeTitle)
                .navigationTitle("Mortgages")
        }
    }
    
    struct StudentLoansView: View {
        var body: some View {
            Text("Student Loans View")
                .font(.largeTitle)
                .navigationTitle("Student Loans")
        }
    }
    
    struct FamilyMembersView: View {
        var body: some View {
            Text("Family Members View")
                .font(.largeTitle)
                .navigationTitle("Family Members")
        }
    }
    
    struct AIChatView: View {
        var body: some View {
            Text("AI Chat View")
                .font(.largeTitle)
                .navigationTitle("Financial Assistant")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
