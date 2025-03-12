import SwiftUI

struct Spacing {
    // Base Units
    static let base: CGFloat = 4
    static let xs: CGFloat = base * 2     // 8pt
    static let sm: CGFloat = base * 3     // 12pt
    static let md: CGFloat = base * 4     // 16pt
    static let lg: CGFloat = base * 6     // 24pt
    static let xl: CGFloat = base * 8     // 32pt
    static let xxl: CGFloat = base * 12   // 48pt
    
    // Specific use cases
    static let cardPadding: CGFloat = md
    static let listItemSpacing: CGFloat = sm
    static let sectionSpacing: CGFloat = lg
    static let contentSpacing: CGFloat = md
}

// Spacing modifiers for consistent application
extension View {
    func standardPadding() -> some View {
        self.padding(Spacing.md)
    }
    
    func cardPadding() -> some View {
        self.padding(Spacing.cardPadding)
    }
    
    func standardHorizontalPadding() -> some View {
        self.padding(.horizontal, Spacing.md)
    }
    
    func standardVerticalPadding() -> some View {
        self.padding(.vertical, Spacing.md)
    }
    
    func sectionSpacing() -> some View {
        self.padding(.bottom, Spacing.sectionSpacing)
    }
} 