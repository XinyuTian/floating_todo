import SwiftUI

struct FloatingDisplayView: View {
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(taskManager.visibleTasks) { task in
                TaskBoxView(task: task)
            }
        }
    }
}

struct TaskBoxView: View {
    @EnvironmentObject var taskManager: TaskManager
    let task: TaskManager.Task
    
    var isSelected: Bool {
        taskManager.selectedTaskId == task.id
    }
    
    var body: some View {
        Text(task.title)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(
                task.color.opacity(isSelected ? 1.0 : 0.3)
            )
            .onTapGesture {
                taskManager.toggleSelection(task)
            }
    }
}
