import SwiftUI

// Custom TextField
struct AppTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(Spacing.sm)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                }
        }
    }
}

// Amount Field (for currency)
struct AmountField: View {
    let label: String
    @Binding var amount: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("$")
                    .font(.currencyRegular)
                    .foregroundColor(.secondary)
                
                TextField("0.00", value: $amount, format: .number)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .font(.currencyRegular)
            }
            .padding(Spacing.sm)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
            }
        }
    }
}

// Date Picker Field
struct DatePickerField: View {
    let label: String
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            DatePicker("", selection: $date, displayedComponents: [.date])
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .padding(Spacing.sm)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.ultraThinMaterial)
                }
        }
    }
}

// Picker Field
struct PickerField<T: Hashable & Identifiable & CustomStringConvertible>: View {
    let label: String
    @Binding var selection: T
    let options: [T]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Picker("", selection: $selection) {
                ForEach(options) { option in
                    Text(option.description).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(Spacing.sm)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.ultraThinMaterial)
            }
        }
    }
}

// Toggle Field
struct ToggleField: View {
    let label: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .appPrimaryBlue))
        }
        .padding(Spacing.sm)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
        }
    }
}

// Preview Provider
struct FormElements_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var text = ""
        @State private var amount = 0.0
        @State private var date = Date()
        @State private var selection = Option.option1
        @State private var isOn = false
        
        enum Option: String, Hashable, Identifiable, CustomStringConvertible, CaseIterable {
            case option1, option2, option3
            
            var id: String { self.rawValue }
            var description: String { self.rawValue.capitalized }
        }
        
        var body: some View {
            VStack(spacing: 20) {
                AppTextField(label: "Name", placeholder: "Enter your name", text: $text)
                
                AmountField(label: "Amount", amount: $amount)
                
                DatePickerField(label: "Date", date: $date)
                
                PickerField(label: "Category", selection: $selection, options: Option.allCases)
                
                ToggleField(label: "Notifications", isOn: $isOn)
            }
            .padding()
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
} 