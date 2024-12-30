import SwiftUI
import AppKit

struct FloatingDisplayView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var hovering = false
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(taskManager.tasks.indices, id: \.self) { index in
                TaskItemView(
                    text: Binding(
                        get: { taskManager.tasks[index] },
                        set: { taskManager.tasks[index] = $0 }
                    ),
                    index: index
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
            if hovering != isHovering {
                withAnimation {
                    hovering = isHovering
                }
            }
        }
    }
}

struct TaskItemView: View {
    @EnvironmentObject var taskManager: TaskManager
    @Binding var text: String
    let index: Int // Add index property
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
                taskManager.endEditing()  // End the current editing session
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    startEditing()  // Start editing this task after a brief delay
                }
                return
            }
            startEditing()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("EndEditingAll"))) { _ in
            isEditing = false
        }
    }
    
    private func startEditing() {
        isEditing = true
        isFocused = true
        taskManager.startEditing(at: index)
    }
    
    private func endEditing() {
        isEditing = false
        isFocused = false
        taskManager.endEditing()
        print("Ending editing. Active task index:", taskManager.activeTaskIndex ?? "none")
    }
    
    private var backgroundColor: Color {
        if isEditing {
            return Color.gray
        } else if taskManager.activeTaskIndex == index {
            return Color.blue
        } else {
            return Color.blue.opacity(0.6)
        }
    }
}
