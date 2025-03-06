#!/bin/bash

# Exit if any command fails
set -e

echo "Installing Flutter..."

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PWD/flutter/bin:$PATH"

# Disable root user check
export FLUTTER_SUPPRESS_ANALYTICS=true
export NO_COLOR=true
export CI=true

echo "Flutter installed successfully."

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the Flutter web app
flutter build web

echo "Flutter web build complete."
