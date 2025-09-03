# Floating Timer

A minimal, sleek floating timer app for macOS with Apple's liquid glass translucent effect.

## Features

- **Floating Window**: Always stays on top, can be moved around the screen
- **Liquid Glass Effect**: Beautiful translucent background with blur and vibrancy
- **Timer Functionality**: Start, pause, reset, and custom time presets
- **Opacity Control**: Adjustable window transparency (30% to 100%)
- **Minimal Design**: Clean, Apple-like interface
- **Menu Bar App**: Runs as a background utility app

## Quick Presets

- 1, 5, 10, 15, 20, 25, 30, 45, 60 minutes
- Easy access through the controls menu

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building from source)

## Installation

### Option 1: Download Pre-built App
1. Download the latest release from the releases page
2. Extract the zip file
3. Drag `Floating Timer.app` to your Applications folder
4. Launch the app

### Option 2: Build from Source
1. Clone this repository
2. Open `FloatingTimer.xcodeproj` in Xcode
3. Build and run the project (⌘+R)

## Usage

1. Launch the app - a floating timer window will appear
2. Click the play button to start the timer (default: 5 minutes)
3. Use the ellipsis (•••) button to access:
   - Quick time presets (1-60 minutes)
   - Opacity slider
   - Quit option
4. Drag the window anywhere on screen
5. The timer will beep when completed and auto-reset

## Technical Implementation

- Built with **SwiftUI** and **AppKit**
- Uses `NSVisualEffectView` with `.hudWindow` material for liquid glass effect
- Custom gradient layers for enhanced translucency
- Floating window with `.floating` level and borderless style
- Background utility app (LSUIElement = YES)

## Architecture

```
FloatingTimer/
├── FloatingTimerApp.swift     # Main app and app delegate
├── ContentView.swift          # Main UI and controls
├── TimerViewModel.swift       # Timer logic and state management
├── LiquidGlassWindow.swift    # Custom window with liquid glass effect
└── Assets.xcassets/           # App icons and assets
```

## License

MIT License - Feel free to use and modify as needed.