import SwiftUI

struct PaymentScheduleView: View {
    @State private var selectedWeek: Date = Date()
    @State private var hoveredDate: Date? = nil
    @State private var showingTooltip: Bool = false
    @State private var tooltipPosition: CGPoint = .zero
    private let calendar = Calendar.current
    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    // Sample payment dates with amounts and names
    private let upcomingPayments: [UpcomingPayment] = [
        UpcomingPayment(name: "Netflix", amount: 19.99, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 15))!, category: "Entertainment"),
        UpcomingPayment(name: "Rent", amount: 1200.00, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!, category: "Housing"),
        UpcomingPayment(name: "Car Insurance", amount: 89.50, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 10))!, category: "Insurance"),
        UpcomingPayment(name: "Phone Bill", amount: 65.00, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 22))!, category: "Utilities"),
        UpcomingPayment(name: "Gym", amount: 45.00, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 5))!, category: "Health & Fitness"),
        UpcomingPayment(name: "Internet", amount: 79.99, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 18))!, category: "Utilities"),
        UpcomingPayment(name: "Credit Card", amount: 350.00, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 25))!, category: "Financial"),
        UpcomingPayment(name: "Streaming Services", amount: 25.99, date: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 27))!, category: "Entertainment")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Upcoming Payments")
                        .font(.headline)
                    
                    Text("Next 7 days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // View calendar button with dropdown menu
                Menu {
                    Button("View Full Calendar", action: { /* Action to view full calendar */ })
                    Button("Add Payment", action: { /* Action to add payment */ })
                    Button("Filter by Category", action: { /* Action to filter payments */ })
                    Button("View Past Payments", action: { /* Action to view past payments */ })
                } label: {
                    HStack {
                        Text("Actions")
                        Image(systemName: "chevron.down")
                    }
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Week view
            VStack(spacing: 12) {
                // Days of week header
                HStack(spacing: 0) {
                    ForEach(0..<7) { index in
                        let date = calendar.date(byAdding: .day, value: index, to: startOfWeek(for: selectedWeek))!
                        
                        EnhancedWeekdayHeaderView(
                            dayLetter: daysOfWeek[index],
                            date: date,
                            isToday: calendar.isDateInToday(date),
                            payments: paymentsForDate(date),
                            onHover: { isHovering in
                                if isHovering {
                                    hoveredDate = date
                                    showingTooltip = true
                                } else if hoveredDate == date {
                                    showingTooltip = false
                                    hoveredDate = nil
                                }
                            }
                        )
                    }
                }
                
                Divider()
                
                // Payment statistics
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("This Week Total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(weeklyTotal(), specifier: "%.2f")")
                            .font(.headline)
                    }
                    
                    Divider()
                        .frame(height: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Number of Bills")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(upcomingPaymentsThisWeek().count)")
                            .font(.headline)
                    }
                    
                    Divider()
                        .frame(height: 24)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Largest Bill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if let largest = upcomingPaymentsThisWeek().max(by: { $0.amount < $1.amount }) {
                            Text("$\(largest.amount, specifier: "%.2f")")
                                .font(.headline)
                        } else {
                            Text("$0.00")
                                .font(.headline)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemGray6).opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                
                // Upcoming payments list with category filters
                VStack(alignment: .leading, spacing: 8) {
                    Text("Due this week")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    
                    // Category filter chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            CategoryFilterChip(name: "All", isSelected: true, color: .blue)
                            CategoryFilterChip(name: "Housing", isSelected: false, color: .purple)
                            CategoryFilterChip(name: "Utilities", isSelected: false, color: .green)
                            CategoryFilterChip(name: "Entertainment", isSelected: false, color: .orange)
                            CategoryFilterChip(name: "Insurance", isSelected: false, color: .red)
                            CategoryFilterChip(name: "Financial", isSelected: false, color: .blue)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    Divider()
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(upcomingPaymentsThisWeek()) { payment in
                                EnhancedPaymentRow(payment: payment)
                            }
                            
                            if upcomingPaymentsThisWeek().isEmpty {
                                Text("No payments due this week")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 20)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 8)
            
            // Navigation buttons
            HStack {
                Button {
                    moveWeek(by: -1)
                } label: {
                    Label("Previous Week", systemImage: "chevron.left")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                Text(weekRangeText())
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    moveWeek(by: 1)
                } label: {
                    Label("Next Week", systemImage: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .overlay(tooltipOverlay)
    }
    
    // Helper to move week forward or backward
    private func moveWeek(by amount: Int) {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: amount, to: selectedWeek) {
            selectedWeek = newDate
        }
    }
    
    // Get start of the week for a given date
    private func startOfWeek(for date: Date) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }
    
    // Format week range as text (e.g., "Mar 1 - Mar 7, 2024")
    private func weekRangeText() -> String {
        let startDate = startOfWeek(for: selectedWeek)
        guard let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate)), \(yearFormatter.string(from: startDate))"
    }
    
    // Extract tooltip overlay to improve type-checking
    private var tooltipOverlay: some View {
        Group {
            if showingTooltip, let date = hoveredDate {
                let paymentsOnDate = paymentsForDate(date)
                if !paymentsOnDate.isEmpty {
                    PaymentTooltip(payments: paymentsOnDate, date: date)
                        .offset(y: -60) // Position above the calendar
                }
            }
        }
    }
    
    // Filter payments for the current week
    private func upcomingPaymentsThisWeek() -> [UpcomingPayment] {
        let startDate = startOfWeek(for: selectedWeek)
        guard let endDate = calendar.date(byAdding: .day, value: 6, to: startDate) else {
            return []
        }
        
        return upcomingPayments.filter { payment in
            return (startDate...endDate).contains(payment.date)
        }
    }
    
    // Get payments for a specific date
    private func paymentsForDate(_ date: Date) -> [UpcomingPayment] {
        return upcomingPayments.filter { payment in
            return calendar.isDate(payment.date, inSameDayAs: date)
        }
    }
    
    // Calculate total payment amount for the week
    private func weeklyTotal() -> Double {
        return upcomingPaymentsThisWeek().reduce(0) { $0 + $1.amount }
    }
}

// Enhanced weekday header view with payment indicators
struct EnhancedWeekdayHeaderView: View {
    let dayLetter: String
    let date: Date
    let isToday: Bool
    let payments: [UpcomingPayment]
    let onHover: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayLetter)
                .font(.caption)
                .foregroundColor(isToday ? .white : .secondary)
            
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.subheadline)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .white : .primary)
            
            // Show total payment amount if there are payments on this date
            if !payments.isEmpty {
                let total = payments.reduce(0) { $0 + $1.amount }
                Text("$\(total, specifier: "%.0f")")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(isToday ? .white : .primary)
                
                // Payment category indicators
                HStack(spacing: 2) {
                    ForEach(getUniqueCategories(for: payments).prefix(3), id: \.self) { category in
                        Circle()
                            .fill(categoryColor(category))
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .frame(width: 36, height: 48)
        .background(
            Circle()
                .fill(isToday ? Color.accentColor : payments.isEmpty ? Color.clear : Color(.systemGray5))
                .frame(width: 36, height: 36)
                .offset(y: -8)
        )
        .frame(maxWidth: .infinity)
        .onHover(perform: onHover)
    }
    
    // Get unique categories for the payment indicators
    private func getUniqueCategories(for payments: [UpcomingPayment]) -> [String] {
        return Array(Set(payments.map { $0.category }))
    }
    
    // Get color for a category
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "Housing":
            return .purple
        case "Utilities":
            return .green
        case "Entertainment":
            return .orange
        case "Insurance":
            return .red
        case "Health & Fitness":
            return .pink
        case "Financial":
            return .blue
        default:
            return .gray
        }
    }
}

// Tooltip showing payment details when hovering over a date
struct PaymentTooltip: View {
    let payments: [UpcomingPayment]
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formattedDate(date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            ForEach(payments) { payment in
                HStack {
                    Circle()
                        .fill(categoryColor(payment.category))
                        .frame(width: 8, height: 8)
                    
                    Text(payment.name)
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("$\(payment.amount, specifier: "%.2f")")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
            
            Divider()
            
            HStack {
                Text("Total")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("$\(payments.reduce(0) { $0 + $1.amount }, specifier: "%.2f")")
                    .font(.caption)
                    .fontWeight(.bold)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        .frame(width: 180)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "Housing":
            return .purple
        case "Utilities":
            return .green
        case "Entertainment":
            return .orange
        case "Insurance":
            return .red
        case "Health & Fitness":
            return .pink
        case "Financial":
            return .blue
        default:
            return .gray
        }
    }
}

// Category filter chip component
struct CategoryFilterChip: View {
    let name: String
    let isSelected: Bool
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 10))
            }
            
            Text(name)
                .font(.caption)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(isSelected ? color.opacity(0.2) : Color(.systemGray6))
        .foregroundColor(isSelected ? color : .primary)
        .cornerRadius(12)
    }
}

// Upcoming payment model with added category field
struct UpcomingPayment: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let date: Date
    let category: String
}

// Enhanced payment row with category and visual indicators
struct EnhancedPaymentRow: View {
    let payment: UpcomingPayment
    
    var body: some View {
        HStack {
            // Category indicator
            Circle()
                .fill(categoryColor(payment.category))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 6) {
                    Text(formattedDate(payment.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(payment.category)
                        .font(.caption)
                        .foregroundColor(categoryColor(payment.category))
                }
            }
            
            Spacer()
            
            // Amount with size indicator
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(payment.amount, specifier: "%.2f")")
                    .font(.system(.subheadline, design: .monospaced))
                    .fontWeight(.semibold)
                
                // Visual indicator for amount size
                HStack(spacing: 2) {
                    ForEach(0..<amountSizeIndicator(payment.amount), id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(amountColor(payment.amount))
                            .frame(width: 8, height: 4)
                    }
                }
            }
            
            // Quick action buttons
            Button {
                // Pay now action
            } label: {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.leading, 8)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "Housing":
            return .purple
        case "Utilities":
            return .green
        case "Entertainment":
            return .orange
        case "Insurance":
            return .red
        case "Health & Fitness":
            return .pink
        case "Financial":
            return .blue
        default:
            return .gray
        }
    }
    
    // Determine visual indicator based on amount
    private func amountSizeIndicator(_ amount: Double) -> Int {
        if amount >= 1000 {
            return 4
        } else if amount >= 500 {
            return 3
        } else if amount >= 100 {
            return 2
        } else {
            return 1
        }
    }
    
    // Get color based on amount
    private func amountColor(_ amount: Double) -> Color {
        if amount >= 1000 {
            return .red
        } else if amount >= 500 {
            return .orange
        } else if amount >= 100 {
            return .yellow
        } else {
            return .green
        }
    }
}

#Preview {
    PaymentScheduleView()
        .frame(width: 300, height: 400)
        .padding()
} 