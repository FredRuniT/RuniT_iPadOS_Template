import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem?
    @EnvironmentObject var userManager: UserManager
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        List(selection: $selection) {
            Section("Overview") {
                NavigationLink(value: SidebarItem.dashboard) {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.insights) {
                    Label("Insights", systemImage: "lightbulb.fill")
                        .foregroundColor(.primary)
                }
            }
            
            Section("Money") {
                NavigationLink(value: SidebarItem.accounts) {
                    Label("Accounts", systemImage: "creditcard.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.transactions) {
                    Label("Transactions", systemImage: "list.bullet.rectangle.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.bills) {
                    Label("Bills", systemImage: "doc.text.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.income) {
                    Label("Income", systemImage: "arrow.down.circle.fill")
                        .foregroundColor(.primary)
                }
            }
            
            Section("Planning") {
                NavigationLink(value: SidebarItem.budget) {
                    Label("Budget", systemImage: "chart.pie.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.goals) {
                    Label("Goals", systemImage: "target")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.wishlist) {
                    Label("Wishlist", systemImage: "heart.fill")
                        .foregroundColor(.primary)
                }
            }
            
            Section("Debt") {
                NavigationLink(value: SidebarItem.loans) {
                    Label("Loans", systemImage: "banknote.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.mortgages) {
                    Label("Mortgages", systemImage: "house.fill")
                        .foregroundColor(.primary)
                }
                
                NavigationLink(value: SidebarItem.studentLoans) {
                    Label("Student Loans", systemImage: "graduationcap.fill")
                        .foregroundColor(.primary)
                }
            }
            
            Section("Family") {
                NavigationLink(value: SidebarItem.familyMembers) {
                    Label("Family Members", systemImage: "person.3.fill")
                        .foregroundColor(.primary)
                }
            }
            
            Section("AI Assistant") {
                NavigationLink(value: SidebarItem.aiChat) {
                    Label("Financial Assistant", systemImage: "bubble.left.fill")
                        .foregroundColor(.primary)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Finance Tracker")
        .frame(minWidth: horizontalSizeClass == .regular ? 250 : nil)
    }
} 