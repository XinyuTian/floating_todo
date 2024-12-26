import SwiftUI
import AppKit

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    var floatingWindow: NSWindow?
    @Published var tasks: [String] = [""]
    @Published var highlightedIndex: Int? = nil
    @Published var isEditing: Bool = false
    
    private init() {
        createFloatingWindow()
    }
    
    func addTask() {
        if isEditing {
            NSSound.beep()
            return
        }
        tasks.append("")
        updateWindowHeight()
    }
    
    func toggleHighlight(at index: Int) {
        if isEditing {
            NSSound.beep()
            return
        }
        
        if highlightedIndex == index {
            // If clicking the currently highlighted task, unhighlight it
            highlightedIndex = nil
        } else {
            // Highlight the new task (this automatically unhighlights the previous one)
            highlightedIndex = index
        }
    }
    
    private func updateWindowHeight() {
        let taskHeight: CGFloat = 40
        let verticalMargin: CGFloat = 20 // 10 points on top and bottom
        let newHeight = CGFloat(tasks.count) * taskHeight + verticalMargin
        floatingWindow?.setContentSize(NSSize(width: 220, height: newHeight)) // Added 20 for horizontal margins
    }
    
    private func createFloatingWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 220, height: 60), // Initial size includes margins
            styleMask: [.borderless, .titled],
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isOpaque = false
        window.acceptsMouseMovedEvents = true
        
        let floatingView = FloatingDisplayView()
            .environmentObject(self)
        window.contentView = NSHostingView(rootView: floatingView)
        
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            // Add margin to initial position
            window.setFrameTopLeftPoint(NSPoint(x: screenFrame.minX + 10, y: screenFrame.maxY - 10))
        }
        
        window.makeKeyAndOrderFront(nil)
        self.floatingWindow = window
    }
}
