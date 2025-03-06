#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e  

echo "Installing Flutter..."

# Clone Flutter with the correct branch
git clone https://github.com/flutter/flutter.git --depth 1 || {
    echo "Failed to clone Flutter repository. Trying default branch."
    git clone https://github.com/flutter/flutter.git -b main --depth 1
}
export PATH="$PWD/flutter/bin:$PATH"

echo "Flutter installed successfully."

# Verify Flutter is installed
flutter --version

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the Flutter web app
flutter build web

echo "Flutter web build complete."