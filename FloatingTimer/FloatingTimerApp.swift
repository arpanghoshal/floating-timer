import SwiftUI
import AppKit

@main
struct FloatingTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: LiquidGlassWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        
        let contentView = ContentView()
        floatingWindow = LiquidGlassWindow(contentView: contentView)
        floatingWindow?.makeKeyAndOrderFront(nil)
        
        NSApp.windows.first { $0.title.isEmpty }?.close()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}