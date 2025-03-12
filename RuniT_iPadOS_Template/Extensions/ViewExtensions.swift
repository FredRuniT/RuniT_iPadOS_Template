import SwiftUI

// Apply across your layout for visual consistency
extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Material.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    // iPad-specific adaptive layout helpers
    @ViewBuilder
    func adaptiveHStack<Content: View>(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        // Create the content view once, outside of GeometryReader
        let contentView = content()
        
        GeometryReader { geometry in
            if geometry.size.width > 500 {
                HStack(alignment: verticalAlignment, spacing: spacing) {
                    contentView
                }
            } else {
                VStack(alignment: horizontalAlignment, spacing: spacing) {
                    contentView
                }
            }
        }
    }
    
    // Responsive padding based on device size
    func responsivePadding() -> some View {
        self.padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16)
            .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12)
    }
    
    // Keyboard shortcut wrapper for common actions
    func commonKeyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers = .command) -> some View {
        self.keyboardShortcut(key, modifiers: modifiers)
    }
} 