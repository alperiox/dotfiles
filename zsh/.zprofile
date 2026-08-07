# Set PATH, MANPATH, etc., for Homebrew.
if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # macOS Python framework
    PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
    export PATH
elif [ -d /home/linuxbrew/.linuxbrew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
