import SwiftUI
import AppKit

@main
struct FloatingTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: LiquidGlassWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        // Close the default window first
        DispatchQueue.main.async {
            for window in NSApp.windows {
                if window.title.isEmpty {
                    window.close()
                }
            }
        }
        
        // Create floating window after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let contentView = ContentView()
            self.floatingWindow = LiquidGlassWindow(contentView: contentView)
            
            // Center the window on screen
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let windowSize = self.floatingWindow?.frame.size ?? NSSize(width: 280, height: 160)
                let x = screenFrame.midX - windowSize.width / 2
                let y = screenFrame.midY - windowSize.height / 2
                self.floatingWindow?.setFrameOrigin(NSPoint(x: x, y: y))
            }
            
            self.floatingWindow?.makeKeyAndOrderFront(nil)
            self.floatingWindow?.orderFrontRegardless()
            
            print("Floating window created at: \(self.floatingWindow?.frame ?? .zero)")
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}