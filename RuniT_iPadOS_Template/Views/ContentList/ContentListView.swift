import SwiftUI

struct ContentListView: View {
    let sidebarSelection: SidebarItem?
    @Binding var detailSelection: UUID?
    
    var body: some View {
        Group {
            switch sidebarSelection {
            case .dashboard:
                Text("Quick Access")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                DashboardQuickAccessList(selection: $detailSelection)
                
            case .accounts:
                AccountsList(selection: $detailSelection)
                    .navigationTitle("Accounts")
                
            case .transactions:
                TransactionsList(selection: $detailSelection)
                    .navigationTitle("Transactions")
                
            case .bills:
                BillsList(selection: $detailSelection)
                    .navigationTitle("Bills")
                
            // Other cases for each sidebar item
            case .insights:
                Text("Insights List")
                    .navigationTitle("Insights")
                
            case .income:
                Text("Income List")
                    .navigationTitle("Income")
                
            case .budget:
                Text("Budget List")
                    .navigationTitle("Budget")
                
            case .goals:
                Text("Goals List")
                    .navigationTitle("Goals")
                
            case .wishlist:
                Text("Wishlist Items")
                    .navigationTitle("Wishlist")
                
            case .loans:
                Text("Loans List")
                    .navigationTitle("Loans")
                
            case .mortgages:
                Text("Mortgages List")
                    .navigationTitle("Mortgages")
                
            case .studentLoans:
                Text("Student Loans List")
                    .navigationTitle("Student Loans")
                
            case .familyMembers:
                Text("Family Members List")
                    .navigationTitle("Family Members")
                
            case .aiChat:
                Text("AI Chat History")
                    .navigationTitle("Financial Assistant")
                
            default:
                Text("Select an item from the sidebar")
                    .foregroundColor(.secondary)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                contextualActions
            }
        }
    }
    
    @ViewBuilder
    private var contextualActions: some View {
        // Contextual actions based on the current selection
        switch sidebarSelection {
        case .accounts:
            Button(action: { /* Add account */ }) {
                Label("Add Account", systemImage: "plus")
            }
            
        case .transactions:
            Menu {
                Button("Date", action: { /* Sort by date */ })
                Button("Amount", action: { /* Sort by amount */ })
                Button("Category", action: { /* Sort by category */ })
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
            
        case .bills:
            Button(action: { /* Add bill */ }) {
                Label("Add Bill", systemImage: "plus")
            }
            
        case .goals:
            Button(action: { /* Add goal */ }) {
                Label("Add Goal", systemImage: "plus")
            }
            
        case .wishlist:
            Button(action: { /* Add wishlist item */ }) {
                Label("Add Item", systemImage: "plus")
            }
            
        default:
            EmptyView()
        }
    }
}

// Placeholder views for the content lists
struct DashboardQuickAccessList: View {
    @Binding var selection: UUID?
    
    var body: some View {
        List(selection: $selection) {
            Text("Recent Transactions")
            Text("Upcoming Bills")
            Text("Budget Overview")
        }
    }
}

struct AccountsList: View {
    @Binding var selection: UUID?
    
    var body: some View {
        List(selection: $selection) {
            Text("Checking Account")
            Text("Savings Account")
            Text("Credit Card")
        }
    }
}

struct TransactionsList: View {
    @Binding var selection: UUID?
    
    var body: some View {
        List(selection: $selection) {
            Text("Grocery Shopping - $85.42")
            Text("Gas Station - $45.00")
            Text("Restaurant - $65.30")
        }
    }
}

struct BillsList: View {
    @Binding var selection: UUID?
    
    var body: some View {
        List(selection: $selection) {
            Text("Rent - $1,200")
            Text("Electricity - $85")
            Text("Internet - $65")
        }
    }
} 