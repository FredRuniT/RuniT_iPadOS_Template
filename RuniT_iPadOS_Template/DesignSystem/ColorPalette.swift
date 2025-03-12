import SwiftUI

extension Color {
    // Primary Colors
    static let appPrimaryBlue = Color("PrimaryBlue")
    static let appSuccessGreen = Color("SuccessGreen")
    static let appCautionOrange = Color("CautionOrange")
    static let appDangerRed = Color("DangerRed")
    
    // Neutral Colors
    static let appDarkText = Color("DarkText")
    static let appMidText = Color("MidText")
    static let appLightText = Color("LightText")
    static let appUltraLightText = Color("UltraLightText")
    
    // Convenience methods for financial values
    static func forAmount(_ amount: Double) -> Color {
        if amount < 0 {
            return appDangerRed
        } else if amount > 0 {
            return appSuccessGreen
        } else {
            return .primary
        }
    }
    
    // Convenience method for budget progress
    static func forBudgetProgress(_ percentage: Double) -> Color {
        switch percentage {
        case 0..<0.7:
            return appSuccessGreen
        case 0.7..<0.9:
            return appCautionOrange
        default:
            return appDangerRed
        }
    }
} 