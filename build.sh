#!/bin/bash
# Cross-platform build script for PyInstaller and packaging

set -e

# Ensure PyInstaller is installed
pip install --upgrade pyinstaller

# Detect OS
OS=$(uname -s)

# Determine output binary name for packaging
BIN_NAME="app"
if [[ "$OS" == "MINGW"* || "$OS" == "CYGWIN"* || "$OS" == "MSYS"* || "$OS" == "Windows_NT" ]]; then
    BIN_NAME="app.exe"
fi

# Build the application using the spec file
pyinstaller pyinstaller.spec

# Determine the output binary name early for Windows packaging
BIN_NAME="app"
if [[ "$OS" == "MINGW"* || "$OS" == "CYGWIN"* || "$OS" == "MSYS"* || "$OS" == "Windows_NT" ]]; then
    BIN_NAME="app.exe"
fi

# Windows: Zip the portable executable
if [[ "$OS" == "MINGW"* || "$OS" == "CYGWIN"* || "$OS" == "MSYS"* || "$OS" == "Windows_NT" ]]; then
    echo "Packaging Windows executable..."
    if command -v zip &> /dev/null; then
        zip -j dist/sitefocus-1.0.0-windows.zip dist/$BIN_NAME
        echo "Windows package created: dist/sitefocus-1.0.0-windows.zip"
    elif command -v 7z &> /dev/null; then
        7z a dist/sitefocus-1.0.0-windows.zip dist/$BIN_NAME
        echo "Windows package created: dist/sitefocus-1.0.0-windows.zip"
    else
        echo "No zip or 7z found; skipping Windows packaging"
    elif command -v 7z &> /dev/null; then
        7z a sitefocus-1.0.0-windows.zip dist/$BIN_NAME
    else
        echo "No zip or 7z found; skipping Windows packaging"
    fi
    fi
fi

DIST_PATH="dist/$BIN_NAME"

# Linux: Build .deb and .rpm if fpm is available
if [ "$OS" = "Linux" ]; then
    if command -v fpm &> /dev/null; then
        echo "Building .deb and .rpm packages with fpm..."
        # Create desktop entry and AppStream metadata for Linux
        mkdir -p dist
        cat > dist/sitefocus.desktop <<EOF
[Desktop Entry]
Type=Application
Name=SiteFocus
Exec=/opt/sitefocus/app/app
Comment=SEO analysis tool
NoDisplay=false
Terminal=false
Categories=Utility;
EOF
        cat > dist/sitefocus.appdata.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<component type="desktop">
  <id>sitefocus.desktop</id>
  <metadata_license>MIT</metadata_license>
</component>
EOF
        # Package for Debian/Ubuntu
        fpm -s dir -t deb -n sitefocus -v 1.0.3 -C dist -p dist/ .
        # Package for Red Hat/Fedora
        fpm -s dir -t rpm -n sitefocus -v 1.0.3 -C dist -p dist/ .
        echo "Linux packages created in dist/"
    else
        echo "fpm not found; skipping Linux packaging"
    fi
fi
  <name>SiteFocus</name>
  <summary>SEO analysis tool for thematic consistency analysis</summary>
  <description>
    A tool to analyze thematic consistency of websites using text embeddings.
  </description>
  <url>https://github.com/username/sitefocus</url>
</component>
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
          sitefocus.appdata.xml=/usr/share/metainfo/sitefocus.appdata.xml \
          app=/opt/sitefocus/app
        fpm --force -s dir -t rpm -n sitefocus -v 1.0.0 \
          --description "SEO analysis tool for thematic consistency analysis" \
          --license "MIT" \
          --url "https://github.com/username/sitefocus" \
          --category "Utility" \
          --maintainer "SiteFocus Team <team@example.com>" \
          --prefix / \
          -C dist \
          sitefocus.desktop=/usr/share/applications/sitefocus.desktop \
          sitefocus.appdata.xml=/usr/share/metainfo/sitefocus.appdata.xml \
          app=/opt/sitefocus/app

        # Move generated packages into dist for consistent artifact paths
        mv sitefocus_*.deb dist/
        mv sitefocus-*.rpm dist/
        
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

# macOS: Zip the executable
if [ "$OS" = "Darwin" ]; then
    echo "Packaging macOS executable..."
    if command -v zip &> /dev/null; then
        zip -j dist/sitefocus-1.0.0-macos.zip dist/$BIN_NAME
        echo "macOS package created: dist/sitefocus-1.0.0-macos.zip"
    else
        echo "zip not found; skipping macOS packaging"
    fi
fi

echo "Build complete. Check the dist/ directory for your executable."
