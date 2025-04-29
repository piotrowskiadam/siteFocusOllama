#!/bin/bash
# Cross-platform build script for PyInstaller and packaging

set -e

# Ensure PyInstaller is installed
pip install --upgrade pyinstaller

# Detect OS
OS=$(uname -s)

# Build the application using the spec file
pyinstaller pyinstaller.spec

# Get the output binary name (assume app.exe for Windows, app for others)
BIN_NAME="app"
if [[ "$OS" == "MINGW"* || "$OS" == "CYGWIN"* || "$OS" == "MSYS"* || "$OS" == "Windows_NT" ]]; then
    BIN_NAME="app.exe"
fi

DIST_PATH="dist/$BIN_NAME"

# Linux: Build .deb and .rpm if fpm is available
if [ "$OS" = "Linux" ]; then
    if command -v fpm &> /dev/null; then
        echo "Building .deb and .rpm packages with fpm..."
        # Correctly map the binary into /opt/sitefocus/app
        fpm --force -s dir -t deb -n sitefocus -v 1.0.0 --prefix / -C dist $BIN_NAME=/opt/sitefocus/app
        fpm --force -s dir -t rpm -n sitefocus -v 1.0.0 --prefix / -C dist $BIN_NAME=/opt/sitefocus/app
        echo "Packages created in current directory."
    else
        echo "fpm not found. Skipping .deb and .rpm packaging."
        echo "To enable Linux packaging, install Ruby and fpm: sudo gem install --no-document fpm"
    fi
fi

# macOS: Build .dmg if hdiutil is available
if [ "$OS" = "Darwin" ]; then
    APP_BUNDLE="dist/SiteFocus.app"
    if [ -d "$APP_BUNDLE" ]; then
        if command -v hdiutil &> /dev/null; then
            echo "Building .dmg package..."
            hdiutil create -volname "SiteFocus" -srcfolder "$APP_BUNDLE" -ov -format UDZO "SiteFocus.dmg"
            echo "DMG created: SiteFocus.dmg"
        else
            echo "hdiutil not found. Skipping .dmg packaging."
        fi
    else
        echo "App bundle not found at $APP_BUNDLE. Skipping .dmg packaging."
    fi
fi

echo "Build complete. Check the dist/ directory for your executable."
