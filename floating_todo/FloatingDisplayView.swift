import SwiftUI
import AppKit

struct FloatingDisplayView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var hovering = false
    @State var keyPressed: KeyCombination?

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(taskManager.tasks.indices, id: \.self) { index in
                TaskItemView(
                    text: Binding(
                        get: { taskManager.tasks[index].text },
                        set: { taskManager.tasks[index].text = $0 }
                    ),
                    index: index,
                    keyPressed: taskManager.activeTaskIndex == index ? taskManager.keyPressed : nil
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
    @FocusState private var isFocused: Bool
    @State private var isEditing: Bool = false
    let index: Int
    let keyPressed: KeyCombination?

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
            }
        }
        .frame(height: 40)
        .background(backgroundColor)
        .cornerRadius(4)
        .padding(.horizontal, 10)
        .onTapGesture(count: 2) {
            startEditingGenral()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("EndEditingAll"))) { _ in
            isEditing = false
        }
        .onChange(of: keyPressed) {
            switch keyPressed {
            case .enter:
                if isEditing {
                    endEditing()
                } else {
                    startEditingGenral()
                }
            case .enterCommand:
                endEditing()
                taskManager.addTask()
            default:
                break
            }
        }
    }
    
    private func startEditingGenral() {
        if taskManager.isEditing {
            taskManager.endEditing()  // End the current editing session
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                startEditing()
            }
            return
        }
        startEditing()
    }
    
    private func startEditing() {
        isEditing = true
        isFocused = true
        taskManager.startEditing(at: index)
        print("Starting editing. Active task index:", index)
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
