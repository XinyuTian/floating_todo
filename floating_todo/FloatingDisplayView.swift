import SwiftUI

struct FloatingDisplayView: View {
    var body: some View {
        Text("task name")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.blue.opacity(0.8))
    }
}
