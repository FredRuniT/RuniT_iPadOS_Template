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
    
    @State private var selectedSidebarItem: SidebarItem? = .dashboard
    @State private var selectedDetailItem: UUID? = nil
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedSidebarItem)
                .environmentObject(userManager)
        } content: {
            ContentListView(sidebarSelection: selectedSidebarItem, detailSelection: $selectedDetailItem)
        } detail: {
            DetailView(sidebarSelection: selectedSidebarItem, detailID: selectedDetailItem)
        }
        .navigationSplitViewStyle(.balanced)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
