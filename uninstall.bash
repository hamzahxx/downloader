#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting Video Downloader uninstallation..."

# Remove the virtual environment
if [[ -d ~/.env/video-downloader ]]; then
    echo "Removing virtual environment..."
    rm -rf ~/.env/video-downloader
    echo "✅ Virtual environment removed."
else
    echo "❓ Virtual environment not found."
fi

# Remove the executable from /usr/local/bin/
if [[ -f /usr/local/bin/video-downloader ]]; then
    echo "Removing downloader command..."
    sudo rm /usr/local/bin/video-downloader
    echo "✅ Command removed from /usr/local/bin/"
else
    echo "❓ Command not found in /usr/local/bin/"
fi

# Determine which shell configuration file to use
SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]] && [[ -f ~/.zshrc ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]] && [[ -f ~/.bashrc ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [[ -f ~/.zshrc ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ -f ~/.bashrc ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

# Remove alias from shell configuration
if [[ -n "$SHELL_CONFIG" ]]; then
    echo "Removing alias from $SHELL_CONFIG..."
    if grep -q "alias download='source ~/.env/video-downloader/bin/activate && video-downloader; deactivate'" "$SHELL_CONFIG"; then
        # Create a temporary file without the alias
        grep -v "alias download='source ~/.env/video-downloader/bin/activate && video-downloader; deactivate'" "$SHELL_CONFIG" > "$SHELL_CONFIG.tmp"
        mv "$SHELL_CONFIG.tmp" "$SHELL_CONFIG"
        echo "✅ Alias removed from $SHELL_CONFIG."
    else
        echo "❓ Alias not found in $SHELL_CONFIG."
    fi
    
    echo ""
    echo "Uninstallation completed successfully! 🎉"
    echo ""
    echo "To apply changes to your current terminal, run:"
    echo "source $SHELL_CONFIG"
    echo ""
else
    echo "⚠️ Could not find shell configuration file (.zshrc or .bashrc)."
    echo "If you manually added the alias, please remove it from your shell configuration file."
fi

echo "Note: Python and Homebrew were not removed as they may be used by other applications."
