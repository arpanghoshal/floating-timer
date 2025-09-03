#!/bin/bash

# Build script for Floating Timer
# This script builds the app for distribution

set -e

PROJECT_NAME="FloatingTimer"
SCHEME="FloatingTimer"
CONFIGURATION="Release"
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/$PROJECT_NAME.xcarchive"
APP_PATH="$BUILD_DIR/$PROJECT_NAME.app"

echo "🏗️  Building Floating Timer for distribution..."

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Build the archive
echo "📦 Creating archive..."
xcodebuild archive \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -archivePath "$ARCHIVE_PATH" \
    -destination "generic/platform=macOS" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Export the app
echo "📤 Exporting app..."
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$BUILD_DIR" \
    -exportOptionsPlist "ExportOptions.plist"

echo "✅ Build complete!"
echo "📁 App location: $BUILD_DIR/$PROJECT_NAME.app"

# Create DMG (optional)
if command -v create-dmg &> /dev/null; then
    echo "📀 Creating DMG..."
    create-dmg \
        --volname "Floating Timer" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "$PROJECT_NAME.app" 175 190 \
        --hide-extension "$PROJECT_NAME.app" \
        --app-drop-link 425 190 \
        "$BUILD_DIR/$PROJECT_NAME.dmg" \
        "$BUILD_DIR/"
    echo "✅ DMG created: $BUILD_DIR/$PROJECT_NAME.dmg"
fi

echo "🎉 Build process complete!"