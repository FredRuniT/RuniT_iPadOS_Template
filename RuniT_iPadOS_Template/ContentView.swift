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
    @StateObject private var userManager = UserManager()
    @StateObject private var financeManager = FinanceManager()
    
    @State private var selectedSidebarItem: SidebarItem? = .dashboard
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
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
        .modelContainer(for: Item.self, inMemory: true)
}