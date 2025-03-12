import SwiftUI

// Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(Color.appPrimaryBlue)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Secondary Button
struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.appPrimaryBlue)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.appPrimaryBlue, lineWidth: 1)
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Icon Button
struct IconButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appPrimaryBlue)
                .frame(width: 36, height: 36)
                .background {
                    Circle()
                        .fill(.ultraThinMaterial)
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Danger Button
struct DangerButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(Color.appDangerRed)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Section Header with Button
struct SectionHeader: View {
    let title: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.titleSmall)
            Spacer()
            Button(buttonTitle, action: action)
                .font(.caption)
                .foregroundColor(.appPrimaryBlue)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
    }
}

// Preview Provider
struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PrimaryButton(title: "Add Account") {
                print("Primary button tapped")
            }
            
            SecondaryButton(title: "See Details") {
                print("Secondary button tapped")
            }
            
            IconButton(systemName: "plus") {
                print("Icon button tapped")
            }
            
            DangerButton(title: "Delete") {
                print("Danger button tapped")
            }
            
            SectionHeader(title: "Recent Transactions", buttonTitle: "View All") {
                print("Section header button tapped")
            }
        }
        .padding()
    }
} 