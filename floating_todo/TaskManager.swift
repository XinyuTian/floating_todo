import SwiftUI
import AppKit

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    var floatingWindow: NSWindow?
    
    private init() {
        createFloatingWindow()
    }
    
    private func createFloatingWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 40),
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
        window.contentView = NSHostingView(rootView: floatingView)
        
        // Position at top-left corner
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            window.setFrameTopLeftPoint(NSPoint(x: screenFrame.minX, y: screenFrame.maxY))
        }
        
        window.makeKeyAndOrderFront(nil)
        self.floatingWindow = window
    }
}
