#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e  

# Check if Flutter is already installed
if [ ! -d "flutter" ]; then
    echo "Installing Flutter..."

    # Clone Flutter with the correct branch
    git clone https://github.com/flutter/flutter.git --depth 1 || {
        echo "Failed to clone Flutter repository. Trying default branch."
        git clone https://github.com/flutter/flutter.git -b main --depth 1
    }
    export PATH="$PWD/flutter/bin:$PATH"

    echo "Flutter installed successfully."
else
    echo "Flutter is already installed."
fi

# Verify Flutter is installed
flutter --version

# Enable web support (this is usually only needed once)
flutter config --enable-web || echo "Web support is already enabled."

# Get dependencies
flutter pub get

# Build the Flutter web app
flutter build web --release

echo "Flutter web build complete."