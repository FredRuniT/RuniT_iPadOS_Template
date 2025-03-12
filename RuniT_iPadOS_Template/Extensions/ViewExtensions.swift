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

// Card hover effect extension
extension View {
    func cardHoverEffect() -> some View {
        self.modifier(CardHoverEffect())
    }
}

// Card hover effect modifier
struct CardHoverEffect: ViewModifier {
    @Environment(\.themeManager) private var themeManager
    @State private var isHovering: Bool = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovering ? 1.02 : 1.0)
            .shadow(
                color: isHovering ? Color.black.opacity(0.15) : Color.black.opacity(0.1),
                radius: isHovering ? 8 : 4,
                x: 0,
                y: isHovering ? 4 : 2
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
            .onHover { hovering in
                guard themeManager.animationsEnabled else { return }
                self.isHovering = hovering
            }
    }
}

// ThemedCard with hover effect
struct ThemedCard<Content: View>: View {
    @Environment(\.themeManager) private var themeManager
    @State private var isHovering: Bool = false
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(Spacing.md)
            .background {
                RoundedRectangle(cornerRadius: themeManager.cardCornerRadius)
                    .fill(themeManager.cardMaterial)
                    .shadow(
                        color: isHovering ? Color.black.opacity(0.15) : Color.black.opacity(0.1),
                        radius: isHovering ? 8 : 4,
                        x: 0,
                        y: isHovering ? 4 : 2
                    )
            }
            .scaleEffect(isHovering ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovering)
            .onHover { hovering in
                guard themeManager.animationsEnabled else { return }
                self.isHovering = hovering
            }
            .onChange(of: themeManager.cardCornerRadius) { oldValue, newValue in
                if themeManager.animationsEnabled {
                    withAnimation(.spring(response: 0.3)) {}
                }
            }
            .onChange(of: themeManager.useUltraThinMaterial) { oldValue, newValue in
                if themeManager.animationsEnabled {
                    withAnimation(.spring(response: 0.3)) {}
                }
            }
    }
}

// Responsive grid layout
struct ResponsiveGrid<Content: View, Item: Identifiable>: View {
    let items: [Item]
    let minWidth: CGFloat
    let spacing: CGFloat
    let content: (Item) -> Content
    
    init(
        items: [Item],
        minWidth: CGFloat = 240,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.minWidth = minWidth
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let columns = max(1, Int(width / minWidth))
            let itemWidth = (width - (spacing * CGFloat(columns - 1))) / CGFloat(columns)
            
            VStack(spacing: spacing) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { column in
                            let index = row * columns + column
                            if index < items.count {
                                content(items[index])
                                    .frame(width: itemWidth)
                            } else {
                                Spacer()
                                    .frame(width: itemWidth)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var rows: Int {
        (items.count + columns - 1) / columns
    }
    
    private var columns: Int {
        max(1, Int(UIScreen.main.bounds.width / minWidth))
    }
} 