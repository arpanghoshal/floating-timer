import SwiftUI

struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    @State private var showingControls = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                
                Button(action: { showingControls.toggle() }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.primary.opacity(0.6))
                        .font(.system(size: 12, weight: .medium))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
                .padding(.trailing, 12)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.primary.opacity(0.2), lineWidth: 3)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: timerViewModel.progress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.2), value: timerViewModel.progress)
                
                Text(timerViewModel.formattedTime)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 16) {
                if timerViewModel.isRunning {
                    Button(action: timerViewModel.pauseTimer) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 16))
                    }
                } else {
                    Button(action: timerViewModel.startTimer) {
                        Image(systemName: "play.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 16))
                    }
                }
                
                Button(action: timerViewModel.resetTimer) {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .popover(isPresented: $showingControls, arrowEdge: .top) {
            ControlsView(timerViewModel: timerViewModel)
        }
    }
}

struct ControlsView: View {
    @ObservedObject var timerViewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let presetTimes = [1, 5, 10, 15, 20, 25, 30, 45, 60]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Timer Controls")
                .font(.headline)
                .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick Presets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(presetTimes, id: \.self) { minutes in
                        Button("\(minutes)m") {
                            timerViewModel.setTime(minutes: minutes)
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                        .font(.caption)
                    }
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Window Opacity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Transparent")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $timerViewModel.opacity, in: 0.3...1.0, step: 0.05)
                    
                    Text("Opaque")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            Button("Quit App") {
                NSApplication.shared.terminate(nil)
            }
            .foregroundColor(.red)
        }
        .padding()
        .frame(width: 220)
    }
}

#Preview {
    ContentView()
}