#!/bin/bash

set -e

BINARY_NAME="notify"
INSTALL_PATH="/usr/local/bin"

if [ -f "$INSTALL_PATH/$BINARY_NAME" ]; then
    echo "🗑️  Removing $BINARY_NAME from $INSTALL_PATH..."
    sudo rm "$INSTALL_PATH/$BINARY_NAME"
    echo "✅ Uninstallation complete!"
else
    echo "⚠️  $BINARY_NAME is not installed at $INSTALL_PATH"
    exit 1
fi
