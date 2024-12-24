import SwiftUI

struct FloatingDisplayView: View {
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("task name", text: $text)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .tint(.white) // Makes the cursor white
            .textFieldStyle(.plain)
            .focused($isFocused)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.horizontal, 10)
            .background(Color.blue.opacity(0.8))
    }
}
