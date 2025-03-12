import SwiftUI

struct PaymentScheduleView: View {
    @State private var currentMonth: Date = Date()
    private let calendar = Calendar.current
    private let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    // Sample payment dates
    private let paymentDates: [Int] = [4, 7, 11, 27]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Payment Schedule")
                    .titleSmallStyle()
                
                Text("Monthly bill due dates")
                    .captionStyle()
            }
            .padding(.horizontal, Spacing.md)
            
            // Month navigation
            HStack {
                Button {
                    moveMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.headline)
                
                Spacer()
                
                Button {
                    moveMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, Spacing.md)
            
            // Days of week header
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, Spacing.md)
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: Spacing.md) {
                ForEach(daysInMonth()) { calendarDay in
                    if calendarDay.day > 0 {
                        CalendarDayView(
                            day: calendarDay.day,
                            isCurrentMonth: calendarDay.isCurrentMonth,
                            hasPayment: paymentDates.contains(calendarDay.day) && calendarDay.isCurrentMonth
                        )
                    } else {
                        // Empty cell
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
        }
        .padding(.vertical, Spacing.md)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // Helper to move month forward or backward
    private func moveMonth(by amount: Int) {
        if let newDate = calendar.date(byAdding: .month, value: amount, to: currentMonth) {
            currentMonth = newDate
        }
    }
    
    // Format month and year string
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
    
    // Calendar day model
    struct CalendarDay: Identifiable, Hashable {
        let id = UUID()
        let day: Int
        let isCurrentMonth: Bool
    }
    
    // Calculate days to display in the calendar
    private func daysInMonth() -> [CalendarDay] {
        var days: [CalendarDay] = []
        
        // Get start of the month
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        
        // Get the weekday of the first day (0 = Sunday, 1 = Monday, etc.)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        // Add empty cells for days before the first of the month
        for _ in 1..<firstWeekday {
            days.append(CalendarDay(day: 0, isCurrentMonth: false))
        }
        
        // Get the range of days in the month
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        
        // Add all days of the current month
        for day in 1...daysInMonth {
            days.append(CalendarDay(day: day, isCurrentMonth: true))
        }
        
        // If we need to fill out the last row, add days from next month
        let remainingCells = 42 - days.count // 6 rows of 7 days
        if remainingCells > 0 && remainingCells < 7 {
            for day in 1...remainingCells {
                days.append(CalendarDay(day: day, isCurrentMonth: false))
            }
        }
        
        return days
    }
}

// Calendar day cell
struct CalendarDayView: View {
    let day: Int
    let isCurrentMonth: Bool
    let hasPayment: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(day)")
                .font(.subheadline)
                .foregroundColor(isCurrentMonth ? .primary : .gray.opacity(0.5))
            
            if hasPayment {
                Circle()
                    .fill(Color.appDangerRed)
                    .frame(width: 6, height: 6)
            } else {
                Spacer()
                    .frame(height: 6)
            }
        }
        .frame(height: 40)
    }
}

#Preview {
    PaymentScheduleView()
        .frame(width: 350)
        .padding()
} 