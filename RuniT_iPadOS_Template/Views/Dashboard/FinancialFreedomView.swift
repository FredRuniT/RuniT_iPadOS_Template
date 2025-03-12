import SwiftUI

struct FinancialFreedomView: View {
    // Sample data
    private let milestones: [FinancialMilestone] = [
        FinancialMilestone(
            id: UUID(),
            title: "Build an Emergency Fund",
            timeframe: "Month 1-3",
            description: "Save $1,000 for unexpected expenses",
            isComplete: false
        ),
        FinancialMilestone(
            id: UUID(),
            title: "Pay Off High-Interest Debt",
            timeframe: "Month 4-6",
            description: "Focus on credit cards and personal loans",
            isComplete: false
        ),
        FinancialMilestone(
            id: UUID(),
            title: "Increase Emergency Fund",
            timeframe: "Month 7-12",
            description: "Build up to 3-6 months of expenses",
            isComplete: true
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Financial Freedom Journey")
                    .titleSmallStyle()
                
                Text("Track your progress towards financial independence")
                    .captionStyle()
            }
            .padding(.horizontal, Spacing.md)
            
            // Overall progress
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Overall Progress")
                    .font(.headline)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.appPrimaryBlue)
                            .frame(width: geometry.size.width * progressPercentage, height: 8)
                    }
                }
                .frame(height: 8)
                
                Text("\(completedMilestones) out of \(milestones.count) milestones completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, Spacing.md)
            
            // Milestones
            ScrollView {
                VStack(spacing: Spacing.md) {
                    ForEach(milestones) { milestone in
                        MilestoneCard(milestone: milestone)
                    }
                }
                .padding(.horizontal, Spacing.md)
            }
        }
        .padding(.vertical, Spacing.md)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var completedMilestones: Int {
        milestones.filter { $0.isComplete }.count
    }
    
    private var progressPercentage: Double {
        Double(completedMilestones) / Double(milestones.count)
    }
}

struct MilestoneCard: View {
    let milestone: FinancialMilestone
    
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.md) {
            // Status icon
            ZStack {
                Circle()
                    .stroke(milestone.isComplete ? Color.appSuccessGreen : Color.gray, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if milestone.isComplete {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.appSuccessGreen)
                }
            }
            .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Text(milestone.timeframe)
                        .font(.caption)
                        .padding(.horizontal, Spacing.xs)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    if milestone.isComplete {
                        Text("Complete")
                            .font(.caption)
                            .padding(.horizontal, Spacing.xs)
                            .padding(.vertical, 2)
                            .background(Color.appSuccessGreen.opacity(0.2))
                            .foregroundColor(.appSuccessGreen)
                            .cornerRadius(4)
                    }
                }
                
                Text(milestone.title)
                    .font(.headline)
                
                Text(milestone.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(Spacing.md)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    FinancialFreedomView()
        .frame(width: 350, height: 500)
        .padding()
} 