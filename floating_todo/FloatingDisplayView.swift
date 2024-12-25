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
    @State private var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            // Text display
            Text(text.isEmpty ? "task name" : text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .opacity(isEditing ? 0 : 1)
            
            // Text field for editing
            if isEditing {
                TextField("", text: $text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .focused($isFocused)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .onSubmit {
                        isEditing = false
                        isFocused = false
                    }
            }
        }
        .frame(height: 40)
        .background(Color.blue.opacity(isEditing ? 1.0 : 0.8))
        .cornerRadius(4)
        .padding(.horizontal, 10)
        .onTapGesture(count: 2) {
            isEditing = true
            isFocused = true
        }
    }
}
