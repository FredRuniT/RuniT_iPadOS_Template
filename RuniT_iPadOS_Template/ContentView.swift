//
//  ContentView.swift
//  RuniT_iPadOS_Template
//
//  Created by Fredrick Burns on 3/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var userManager: UserManager
    @EnvironmentObject private var financeManager: FinanceManager
    
    @State private var selectedSidebarItem: SidebarItem? = .dashboard
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var isFirstLaunch = true
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar column
            SidebarView(selection: $selectedSidebarItem)
                .environmentObject(userManager)
        } detail: {
            // Detail view - no middle column
            if let selectedItem = selectedSidebarItem {
                switch selectedItem {
                case .dashboard:
                    MainDashboardView()
                        .environmentObject(financeManager)
                        .environmentObject(userManager)
                default:
                    Text(selectedItem.title)
                        .font(.largeTitle)
                        .padding()
                }
            } else {
                Text("Select an item from the sidebar")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            if isFirstLaunch {
                isFirstLaunch = false
                
                // Check if we have any users in the database
                let descriptor = FetchDescriptor<User>(sortBy: [SortDescriptor(\.createdAt)])
                
                do {
                    let existingUsers = try modelContext.fetch(descriptor)
                    
                    if existingUsers.isEmpty {
                        // Create sample data on first launch
                        financeManager.createSampleSwiftDataForDemo(modelContext: modelContext)
                    } else if let firstUser = existingUsers.first {
                        // Load the first user
                        userManager.currentUser = UserProfile(from: firstUser)
                        userManager.isAuthenticated = true
                        
                        // Load bills for the UI
                        let bills = financeManager.loadBills(modelContext: modelContext, for: firstUser.id)
                        
                        // Convert to MonthlyBill type for the UI
                        financeManager.monthlyBills = bills.map { financeManager.convertToMonthlyBill($0) }
                    }
                } catch {
                    print("Error checking for existing users: \(error)")
                }
            }
        }
    }
}

extension UIDevice {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

#Preview(traits: .landscapeLeft) {
    ContentView()
        .environmentObject(UserManager())
        .environmentObject(FinanceManager())
        .environment(\.themeManager, ThemeManager())
        .modelContainer(for: [
            User.self,
            Account.self,
            Bill.self,
            Transaction.self,
            Category.self
        ], inMemory: true)
}