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