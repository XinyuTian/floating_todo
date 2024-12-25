import SwiftUI

struct FloatingDisplayView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var hovering = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(taskManager.tasks.indices, id: \.self) { index in
                TaskItemView(text: Binding(
                    get: { taskManager.tasks[index] },
                    set: { taskManager.tasks[index] = $0 }
                ))
            }
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottomLeading) {
            Button(action: { taskManager.addTask() }) {
                Circle()
                    .fill(Color.blue.opacity(hovering ? 0.8 : 0.0))
                    .frame(width: 24, height: 24)
                    .overlay {
                        if hovering {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
            }
            .buttonStyle(.plain)
            .padding(10)
            .transition(.opacity)
        }
        .onHover { isHovering in
            withAnimation {
                hovering = isHovering
            }
        }
    }
}

struct TaskItemView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("task name", text: $text)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .padding(.horizontal, 10)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(4)
            .padding(.horizontal, 10)
    }
}
