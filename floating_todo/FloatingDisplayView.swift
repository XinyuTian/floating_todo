import SwiftUI
import AppKit

struct FloatingDisplayView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var hovering = false
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(taskManager.tasks.indices, id: \.self) { index in
                TaskItemView(
                    text: Binding(
                        get: { taskManager.tasks[index] },
                        set: { taskManager.tasks[index] = $0 }
                    ),
                    isHighlighted: taskManager.highlightedIndex == index,
                    onTap: { taskManager.toggleHighlight(at: index) }
                )
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
    @EnvironmentObject var taskManager: TaskManager
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @State private var isEditing: Bool = false
    let isHighlighted: Bool
    let onTap: () -> Void
    
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
                        endEditing()
                    }
            }
        }
        .frame(height: 40)
        .background(backgroundColor)
        .cornerRadius(4)
        .padding(.horizontal, 10)
        .onTapGesture(count: 2) {
            if taskManager.isEditing {
                NSSound.beep()
                return
            }
            startEditing()
        }
        .onTapGesture {
            if !isEditing {
                onTap()
            }
        }
    }
    
    private func startEditing() {
        isEditing = true
        isFocused = true
        taskManager.isEditing = true
    }
    
    private func endEditing() {
        isEditing = false
        isFocused = false
        taskManager.isEditing = false
    }
    
    private var backgroundColor: Color {
        if isEditing {
            return Color.blue
        } else if isHighlighted {
            return Color.blue.opacity(0.9)
        } else {
            return Color.blue.opacity(0.4)
        }
    }
}
