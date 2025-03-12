import SwiftUI

class ThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme?
    @Published var accentColor: Color = .appPrimaryBlue
    
    // Custom configuration options
    @Published var useUltraThinMaterial: Bool = true
    @Published var cornerRadiusSize: CornerRadiusSize = .medium
    @Published var animationsEnabled: Bool = true
    
    enum CornerRadiusSize: String, CaseIterable, Identifiable {
        case small, medium, large
        
        var value: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 12
            case .large: return 16
            }
        }
        
        var id: String { self.rawValue }
    }
    
    // Get the correct material based on settings
    var cardMaterial: Material {
        useUltraThinMaterial ? .ultraThinMaterial : .regularMaterial
    }
    
    // Get correct corner radius based on settings
    var cardCornerRadius: CGFloat {
        cornerRadiusSize.value
    }
}

// Theme manager environment key
struct ThemeManagerKey: EnvironmentKey {
    static let defaultValue = ThemeManager()
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

// Themed Card with Theme Integration
struct ThemedCard<Content: View>: View {
    @Environment(\.themeManager) private var themeManager
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
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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

// Hover effect modifier
struct CardHoverEffect: ViewModifier {
    @Environment(\.themeManager) private var themeManager
    @State private var isHovering: Bool = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isHovering ? 1.02 : 1.0)
            .shadow(color: isHovering ? .black.opacity(0.15) : .black.opacity(0.1), 
                    radius: isHovering ? 6 : 4, 
                    x: 0, 
                    y: isHovering ? 3 : 2)
            .onHover { hovering in
                guard themeManager.animationsEnabled else { return }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isHovering = hovering
                }
            }
    }
}

extension View {
    func cardHoverEffect() -> some View {
        self.modifier(CardHoverEffect())
    }
} 