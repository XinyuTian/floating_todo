import SwiftUI

struct TaskManagerView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var newTaskTitle: String = ""
    
    var body: some View {
        VStack {
            // Add task section
            HStack {
                TextField("New task...", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        if !newTaskTitle.isEmpty {
                            addTask()
                        }
                    }
                
                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                .disabled(newTaskTitle.isEmpty)
            }
            .padding()
            
            // Task list
            List(taskManager.tasks) { task in
                HStack {
                    Toggle(isOn: Binding(
                        get: { task.isVisible },
                        set: { _ in taskManager.toggleVisibility(task) }
                    )) { }
                    
                    Text(task.title)
                        .foregroundColor(task.color)
                    
                    Spacer()
                    
                    Circle()
                        .fill(task.color)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .frame(minWidth: 300, minHeight: 400)
    }
    
    private func addTask() {
        taskManager.addTask(title: newTaskTitle)
        newTaskTitle = ""
    }
}
