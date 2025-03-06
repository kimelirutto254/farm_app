#!/bin/bash

# Exit if any command fails
set -e

echo "Installing Flutter..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PWD/flutter/bin:$PATH"

echo "Flutter installed successfully."

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build Flutter web app
flutter build web

echo "Flutter web build complete."
