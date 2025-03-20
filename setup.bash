#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting Video Downloader setup..."

# Check if the script is in the correct directory
if [[ ! -f "downloader.py" ]]; then
    echo "Error: downloader.py not found in current directory."
    echo "Please run this script from the directory containing downloader.py."
    exit 1
fi

# Check if brew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew is already installed."
fi

# Install Python 3 if not already installed
if ! command -v python3 &> /dev/null; then
    echo "Installing Python 3..."
    brew install python
else
    echo "✅ Python 3 is already installed."
fi

# Create virtual environment directory if it doesn't exist
echo "Setting up virtual environment..."
mkdir -p ~/.env

# Create the virtual environment
python3 -m venv ~/.env/video-downloader

# Activate virtual environment and install yt-dlp
echo "Installing dependencies..."
source ~/.env/video-downloader/bin/activate
pip install yt-dlp
deactivate
echo "✅ Dependencies installed."

# Make downloader.py executable
echo "Setting up the downloader script..."
chmod +x downloader.py
echo "✅ Script is now executable."

# Move the script to /usr/local/bin/
echo "Installing the downloader command..."
sudo cp downloader.py /usr/local/bin/video-downloader
echo "✅ Downloader installed to /usr/local/bin/"

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

# Add alias to shell configuration
if [[ -n "$SHELL_CONFIG" ]]; then
    echo "Adding alias to $SHELL_CONFIG..."
    if ! grep -q "alias download='source ~/.env/video-downloader/bin/activate && video-downloader; deactivate'" "$SHELL_CONFIG"; then
        echo "alias download='source ~/.env/video-downloader/bin/activate && video-downloader; deactivate'" >> "$SHELL_CONFIG"
        echo "✅ Alias added to $SHELL_CONFIG."
    else
        echo "✅ Alias already exists in $SHELL_CONFIG."
    fi
    
    echo ""
    echo "Setup completed successfully! 🎉"
    echo ""
    echo "To use the downloader, restart your terminal or run:"
    echo "source $SHELL_CONFIG"
    echo ""
    echo "Then simply type 'download' to use the program."
else
    echo "⚠️ Could not find shell configuration file (.zshrc or .bashrc)."
    echo "Please add the following line to your shell configuration file manually:"
    echo "alias download='source ~/.env/video-downloader/bin/activate && video-downloader; deactivate'"
fi
