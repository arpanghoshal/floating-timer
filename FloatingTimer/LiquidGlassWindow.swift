import SwiftUI
import AppKit

class LiquidGlassWindow: NSWindow {
    private var isDragging = false
    private var lastMouseLocation = NSPoint.zero
    
    init<Content: View>(contentView: Content) {
        super.init(
            contentRect: NSRect(x: 200, y: 200, width: 280, height: 160),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        setupWindow()
        setupContentView(contentView)
    }
    
    private func setupWindow() {
        backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.1)
        isOpaque = false
        hasShadow = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .stationary]
        titlebarAppearsTransparent = true
        isMovableByWindowBackground = true
        alphaValue = 0.95
        
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }
    
    private func setupContentView<Content: View>(_ contentView: Content) {
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .withinWindow
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 16
        visualEffectView.layer?.masksToBounds = true
        
        visualEffectView.addSubview(hostingView)
        self.contentView = visualEffectView
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
        ])
        
        addLiquidGlassEffect(to: visualEffectView)
    }
    
    private func addLiquidGlassEffect(to view: NSView) {
        guard let layer = view.layer else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            NSColor.white.withAlphaComponent(0.3).cgColor,
            NSColor.white.withAlphaComponent(0.1).cgColor,
            NSColor.black.withAlphaComponent(0.05).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 16
        
        let borderLayer = CALayer()
        borderLayer.borderColor = NSColor.white.withAlphaComponent(0.2).cgColor
        borderLayer.borderWidth = 1.0
        borderLayer.cornerRadius = 16
        
        layer.addSublayer(gradientLayer)
        layer.addSublayer(borderLayer)
        
        gradientLayer.frame = layer.bounds
        borderLayer.frame = layer.bounds
        
        NotificationCenter.default.addObserver(
            forName: NSView.frameDidChangeNotification,
            object: view,
            queue: .main
        ) { _ in
            gradientLayer.frame = layer.bounds
            borderLayer.frame = layer.bounds
        }
    }
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
    
    override func mouseDown(with event: NSEvent) {
        isDragging = true
        lastMouseLocation = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard isDragging else { return }
        
        let currentLocation = event.locationInWindow
        let screenLocation = convertPoint(toScreen: currentLocation)
        let lastScreenLocation = convertPoint(toScreen: lastMouseLocation)
        
        let deltaX = screenLocation.x - lastScreenLocation.x
        let deltaY = screenLocation.y - lastScreenLocation.y
        
        let newOrigin = NSPoint(
            x: frame.origin.x + deltaX,
            y: frame.origin.y + deltaY
        )
        
        setFrameOrigin(newOrigin)
    }
    
    override func mouseUp(with event: NSEvent) {
        isDragging = false
    }
}