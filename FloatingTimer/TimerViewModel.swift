import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval = 300
    @Published var originalTime: TimeInterval = 300
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var opacity: Double = 0.95
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        guard originalTime > 0 else { return 0 }
        return 1.0 - (timeRemaining / originalTime)
    }
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        $opacity
            .sink { [weak self] newOpacity in
                self?.updateWindowOpacity(newOpacity)
            }
            .store(in: &cancellables)
    }
    
    func startTimer() {
        guard !isRunning else { return }
        
        if !isPaused {
            originalTime = timeRemaining
        }
        
        isRunning = true
        isPaused = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func pauseTimer() {
        isRunning = false
        isPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        timeRemaining = originalTime
    }
    
    func setTime(minutes: Int) {
        guard !isRunning else { return }
        let newTime = TimeInterval(minutes * 60)
        timeRemaining = newTime
        originalTime = newTime
        isPaused = false
    }
    
    private func tick() {
        guard timeRemaining > 0 else {
            timerCompleted()
            return
        }
        
        timeRemaining -= 0.1
    }
    
    private func timerCompleted() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        timer = nil
        timeRemaining = 0
        
        NSSound.beep()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.resetTimer()
        }
    }
    
    private func updateWindowOpacity(_ opacity: Double) {
        DispatchQueue.main.async {
            if let window = NSApp.windows.first(where: { $0 is LiquidGlassWindow }) {
                window.alphaValue = opacity
            }
        }
    }
}