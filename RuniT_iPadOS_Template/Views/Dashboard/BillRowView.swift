import SwiftUI

// Simple bill row component
struct BillRowView: View {
    let bill: MonthlyBill
    
    var body: some View {
        HStack {
            // Bill name and avatar
            HStack(spacing: 12) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(billPriorityColor)
                        .frame(width: 36, height: 36)
                    
                    Text(bill.name.prefix(1))
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                }
                
                // Name and due date info
                VStack(alignment: .leading, spacing: 4) {
                    Text(bill.name)
                        .font(.system(.subheadline, weight: .medium))
                    
                    if bill.daysPastDue > 0 {
                        Text("\(bill.daysPastDue) days past due")
                            .font(.caption)
                            .foregroundColor(bill.daysPastDue > 30 ? .red : .orange)
                    }
                }
            }
            .frame(width: 200, alignment: .leading)
            .padding(.leading, 20)
            
            Spacer()
            
            // Amount
            Text("$\(bill.monthlyAmount, specifier: "%.2f")")
                .font(.system(.subheadline, design: .monospaced))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 12)
    }
    
    // Color based on bill priority
    private var billPriorityColor: Color {
        if bill.status == .late {
            return .red
        } else if bill.status == .unpaid {
            return .blue
        } else {
            return .green
        }
    }
}