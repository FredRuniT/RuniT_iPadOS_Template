import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem?
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        List(selection: $selection) {
            Section("Overview") {
                NavigationLink(value: SidebarItem.dashboard) {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                
                NavigationLink(value: SidebarItem.insights) {
                    Label("Insights", systemImage: "lightbulb.fill")
                }
            }
            
            Section("Money") {
                NavigationLink(value: SidebarItem.accounts) {
                    Label("Accounts", systemImage: "creditcard.fill")
                }
                
                NavigationLink(value: SidebarItem.transactions) {
                    Label("Transactions", systemImage: "list.bullet.rectangle.fill")
                }
                
                NavigationLink(value: SidebarItem.bills) {
                    Label("Bills", systemImage: "doc.text.fill")
                }
                
                NavigationLink(value: SidebarItem.income) {
                    Label("Income", systemImage: "arrow.down.circle.fill")
                }
            }
            
            Section("Planning") {
                NavigationLink(value: SidebarItem.budget) {
                    Label("Budget", systemImage: "chart.pie.fill")
                }
                
                NavigationLink(value: SidebarItem.goals) {
                    Label("Goals", systemImage: "target")
                }
                
                NavigationLink(value: SidebarItem.wishlist) {
                    Label("Wishlist", systemImage: "heart.fill")
                }
            }
            
            Section("Debt") {
                NavigationLink(value: SidebarItem.loans) {
                    Label("Loans", systemImage: "banknote.fill")
                }
                
                NavigationLink(value: SidebarItem.mortgages) {
                    Label("Mortgages", systemImage: "house.fill")
                }
                
                NavigationLink(value: SidebarItem.studentLoans) {
                    Label("Student Loans", systemImage: "graduationcap.fill")
                }
            }
            
            Section("Family") {
                NavigationLink(value: SidebarItem.familyMembers) {
                    Label("Family Members", systemImage: "person.3.fill")
                }
            }
            
            Section("AI Assistant") {
                NavigationLink(value: SidebarItem.aiChat) {
                    Label("Financial Assistant", systemImage: "bubble.left.fill")
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Finance Tracker")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { /* User profile action */ }) {
                    if let photoURL = userManager.currentUser?.avatarURL {
                        AsyncImage(url: photoURL) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle")
                    }
                }
            }
        }
    }
} 