#!/bin/bash
# Cross-platform build script for PyInstaller and packaging

set -e

# Ensure PyInstaller is installed
pip install --upgrade pyinstaller

# Detect OS
OS=$(uname -s)

# Build the application using the spec file
pyinstaller pyinstaller.spec

# Windows: Zip the portable executable
if [[ "$OS" == "MINGW"* || "$OS" == "CYGWIN"* || "$OS" == "MSYS"* || "$OS" == "Windows_NT" ]]; then
    echo "Packaging Windows executable..."
    zip -j sitefocus-1.0.0-windows.zip dist/$BIN_NAME
    echo "Windows package created: sitefocus-1.0.0-windows.zip"
fi

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
        # Create desktop entry for Linux
        cat > dist/sitefocus.desktop <<EOF
[Desktop Entry]
Type=Application
Name=SiteFocus
Exec=/opt/sitefocus/app
Comment=SEO analysis tool
NoDisplay=false
Terminal=false
Categories=Utility;
EOF
        # Correctly map the binary into /opt/sitefocus/app
        fpm --force -s dir -t deb -n sitefocus -v 1.0.0 \
          --description "SEO analysis tool for thematic consistency analysis" \
          --license "MIT" \
          --url "https://github.com/username/sitefocus" \
          --category "Utility" \
          --maintainer "SiteFocus Team <team@example.com>" \
          --prefix / \
          -C dist \
          sitefocus.desktop=/usr/share/applications/sitefocus.desktop \
          $BIN_NAME=/opt/sitefocus/app
        
        fpm --force -s dir -t rpm -n sitefocus -v 1.0.0 \
          --description "SEO analysis tool for thematic consistency analysis" \
          --license "MIT" \
          --url "https://github.com/username/sitefocus" \
          --category "Utility" \
          --maintainer "SiteFocus Team <team@example.com>" \
          --prefix / \
          -C dist \
          sitefocus.desktop=/usr/share/applications/sitefocus.desktop \
          $BIN_NAME=/opt/sitefocus/app
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
            # Zip the DMG for distribution
            zip -j sitefocus-1.0.0-macos.zip SiteFocus.dmg
            echo "macOS package created: sitefocus-1.0.0-macos.zip"
        else
            echo "hdiutil not found. Skipping .dmg packaging."
        fi
    else
        echo "App bundle not found at $APP_BUNDLE. Skipping .dmg packaging."
    fi
fi

echo "Build complete. Check the dist/ directory for your executable."
