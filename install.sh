#!/bin/bash

set -e

BINARY_NAME="notify"
INSTALL_PATH="/usr/local/bin"

echo "📦 Building $BINARY_NAME..."
swiftc notify.swift -o $BINARY_NAME

echo "🔧 Installing to $INSTALL_PATH..."
sudo cp $BINARY_NAME $INSTALL_PATH/$BINARY_NAME
sudo chmod +x $INSTALL_PATH/$BINARY_NAME
sudo codesign --sign - --force $INSTALL_PATH/$BINARY_NAME

echo "✅ Installation complete!"
echo ""
echo "You can now use '$BINARY_NAME' from anywhere:"
echo "  notify --title \"Hello\" --description \"World\" --icon checkmark.circle.fill"
echo ""
echo "Run 'notify --help' for more options."
