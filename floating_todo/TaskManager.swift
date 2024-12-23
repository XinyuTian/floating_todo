import SwiftUI
import AppKit

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    
    @Published var tasks: [Task] = []
    @Published var selectedTaskId: UUID?
    var floatingWindow: NSWindow?
    
    struct Task: Identifiable, Equatable {
        let id = UUID()
        var title: String
        var isVisible: Bool
        let color: Color
        
        static let colors: [Color] = [
            .blue, .green, .orange, .purple, .pink, .red, .yellow, .mint, .teal, .indigo
        ]
    }
    
    private init() {} // Ensure singleton pattern
    
    func addTask(title: String) {
        let colorIndex = tasks.count % Task.colors.count
        let task = Task(
            title: title,
            isVisible: true,
            color: Task.colors[colorIndex]
        )
        tasks.append(task)
        updateFloatingWindow()
    }
    
    func toggleVisibility(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isVisible.toggle()
            updateFloatingWindow()
        }
    }
    
    func toggleSelection(_ task: Task) {
        if selectedTaskId == task.id {
            selectedTaskId = nil
        } else {
            selectedTaskId = task.id
        }
    }
    
    var visibleTasks: [Task] {
        tasks.filter { $0.isVisible }
    }
    
    private func updateFloatingWindow() {
        let hasVisibleTasks = !visibleTasks.isEmpty
        
        if hasVisibleTasks && floatingWindow == nil {
            // Create floating window
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 400),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
            window.level = .floating
            window.backgroundColor = .clear
            window.isMovableByWindowBackground = true
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            
            let floatingView = FloatingDisplayView()
                .environmentObject(self)
            window.contentView = NSHostingView(rootView: floatingView)
            
            // Position at top-left corner
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                window.setFrameTopLeftPoint(NSPoint(x: screenFrame.minX, y: screenFrame.maxY))
            }
            
            window.makeKeyAndOrderFront(nil)
            
            self.floatingWindow = window
            
        } else if !hasVisibleTasks && floatingWindow != nil {
            // Close and remove floating window
            floatingWindow?.close()
            floatingWindow = nil
        }
    }
}
