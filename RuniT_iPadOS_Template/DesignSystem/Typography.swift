import SwiftUI

extension Font {
    // Title Styles
    static let titleLarge = Font.system(size: 28, weight: .bold, design: .default)
    static let titleRegular = Font.system(size: 22, weight: .bold, design: .default)
    static let titleSmall = Font.system(size: 17, weight: .semibold, design: .default)
    
    // Text Styles
    static let headlineRegular = Font.system(size: 15, weight: .semibold, design: .default)
    static let bodyRegular = Font.system(size: 13, weight: .regular, design: .default)
    static let captionRegular = Font.system(size: 11, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .default)
    
    // Financial Specific Typography
    static let currencyLarge = Font.system(size: 28, weight: .bold, design: .monospaced)
    static let currencyRegular = Font.system(size: 17, weight: .medium, design: .monospaced)
    static let currencySmall = Font.system(size: 13, weight: .regular, design: .monospaced)
    static let percentageRegular = Font.system(size: 13, weight: .medium, design: .monospaced)
}

// Text style modifiers for consistent application
extension View {
    func titleLargeStyle() -> some View {
        self.font(.titleLarge)
            .foregroundColor(.appDarkText)
    }
    
    func titleStyle() -> some View {
        self.font(.titleRegular)
            .foregroundColor(.appDarkText)
    }
    
    func titleSmallStyle() -> some View {
        self.font(.titleSmall)
            .foregroundColor(.appDarkText)
    }
    
    func headlineStyle() -> some View {
        self.font(.headlineRegular)
            .foregroundColor(.appDarkText)
    }
    
    func bodyStyle() -> some View {
        self.font(.bodyRegular)
            .foregroundColor(.appDarkText)
    }
    
    func captionStyle() -> some View {
        self.font(.captionRegular)
            .foregroundColor(.appMidText)
    }
    
    func captionSmallStyle() -> some View {
        self.font(.captionSmall)
            .foregroundColor(.appMidText)
    }
    
    func currencyLargeStyle() -> some View {
        self.font(.currencyLarge)
    }
    
    func currencyStyle() -> some View {
        self.font(.currencyRegular)
    }
    
    func currencySmallStyle() -> some View {
        self.font(.currencySmall)
    }
    
    func percentageStyle() -> some View {
        self.font(.percentageRegular)
    }
} 