#!/bin/bash

logs_folder="$(dirname "${BASH_SOURCE[0]}")/logs"
mkdir -p "$logs_folder"

logfile_path="$logs_folder/$(basename "${BASH_SOURCE[0]}" .sh)-$(date +%Y-%m-%d).log"
# echo "$logfile_path"
# exit 0

all_apps=(
    neovim
)

all_apps2=(
    atuin
    bat
    bpytop
    cargo
    eza
    fastfetch
    fd
    fonts-firacode
    gcc
    golang
    keychain
    lazygit
    lsd
    lynx
    mc
    most
    nala
    neofetch
    neovim
    net-tools
    pandoc
    pfetch
    python3
    python3-pip
    ranger
    ripgrep
    stow
    tmux
    tldr
    unzip
    vim
    wakeonlan
    w3m
    yazi
    zoxide
)

linux_apps=(
    tilix
)

brew_linux_apps=(
    fzf
    node
)

brew_mac_apps=(
    fzf
    node
)

mac_cask_brew_apps=(
    iterm2
    font-delugia-complete
    font-fira-code
    font-fira-code-nerd-font
    wezterm
)

# --- Parse command-line arguments ----------------

no_brew_installation=false
no_special_linux=false
no_terminal=false

for arg in "$@"; do
    case $arg in
    --no-brew)
        # Set the flag if --no-brew is passed
        no_brew_installation=true
        shift # Remove --no-brew from processing
        ;;
    --no-special-linux)
        # Set the flag if --no-special-linux is passed
        no_special_linux=true
        shift # Remove --no-special-linux from processing
        ;;
    --no-terminal)
        # Set the flag if --no-terminal is passed
        no_terminal=true
        shift # Remove --no-terminal from processing
        ;;
    *)
        shift # Skip unknown options
        ;;
    esac
done

# ---- Brew --------------------------------------------

install_brew() {
    if [ "$no_brew_installation" = false ]; then
        echo "**** Installing brew ..." | tee -a "$logfile_path"
    else
        echo "**** Skipping brew installation ..." | tee -a "$logfile_path"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "brew is required on Mac" | tee -a "$logfile_path"
            exit 1
        fi
        return
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | tee -a "$logfile_path"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" | tee -a "$logfile_path"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OS
        $(which bash) -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" | tee -a "$logfile_path"
    else
        echo "Unsupported $OSTYPE for brew installation" | tee -a "$logfile_path"
    fi
}

# ---- Mac --------------------------------------------

install_mac_brew_apps() {
    if [ "$no_brew_installation" = true ]; then
        echo "**** Skipping brew installation ..." | tee -a "$logfile_path"
        return
    fi

    for app in "${all_apps[@]}"; do
        if brew list "$app" &>/dev/null; then
            echo "**** $app is already installed" | tee -a "$logfile_path"
        else
            echo "**** Trying 'brew install $app' ..." | tee -a "$logfile_path"
            brew install "$app"
        fi
    done

    for app in "${brew_mac_apps[@]}"; do
        if brew list "$app" &>/dev/null; then
            echo "**** $app is already installed" | tee -a "$logfile_path"
        else
            echo "**** Trying 'brew install $app' ..." | tee -a "$logfile_path"
            brew install "$app"
        fi
    done

    brew tap homebrew/cask-fonts
    for app in "${mac_cask_brew_apps[@]}"; do
        echo "**** Trying 'brew --cask install $app' ..." | tee -a "$logfile_path"
        if ! brew list "$app" &>/dev/null; then
            brew install --cask "$app"
        fi
    done
}

# -- Linux --------------------------------------------

install_linux_special_apps() {
    if [ "$no_special_linux" = true ]; then
        echo "**** Skipping special Linux apps installation ..." | tee -a "$logfile_path"
        return
    fi

    echo "installing special apps" | tee -a "$logfile_path"

    # lf ========================================
    local appv=r32
    local appcpu=amd # or arm

    local download_file="lf-linux-${appcpu}64.tar.gz"

    wget "https://github.com/gokcehan/lf/releases/download/${appv}/${download_file}" -O "$download_file" | tee -a "$logfile_path"
    tar xvf "$download_file" | tee -a "$logfile_path"
    chmod +x lf | tee -a "$logfile_path"
    sudo mv lf /usr/local/bin | tee -a "$logfile_path"

    rm "$download_file" | tee -a "$logfile_path"

    # delugia font ========================================
    local appv="v2111.01.2"
    local target="delugia-complete"
    local download_file="${target}.zip"
    wget "https://github.com/adam7/delugia-code/releases/download/${appv}/${download_file}" -O "$download_file" | tee -a "$logfile_path"
    unzip -o "$download_file" | tee -a "$logfile_path"
    sudo rm -r /usr/share/fonts/"${target}" | tee -a "$logfile_path"
    sudo mv -f "${target}" /usr/share/fonts/ | tee -a "$logfile_path"
    sudo fc-cache -f -v | tee -a "$logfile_path"
    rm "$download_file" | tee -a "$logfile_path"
}

install_linux_app() {
    local app=$1
    if dpkg -l "$app" &>/dev/null; then
        echo "**** $app is already installed" | tee -a "$logfile_path"
    else
        echo "**** Trying 'apt install' $app ..." | tee -a "$logfile_path"
        if ! sudo apt install -y "$app"; then
            if [ "$no_brew_installation" = false ]; then
                echo "**** apt failed, trying 'brew install $app' with brew..." | tee -a "$logfile_path"
                brew install "$app"
            fi
        fi
    fi
}

install_brew_linux_apps() {
    if [ "$no_brew_installation" = true ]; then
        echo "**** Skipping brew installation ..." | tee -a "$logfile_path"
        return
    fi

    for app in "${brew_linux_apps[@]}"; do
        echo "**** Trying to install $app ..." | tee -a "$logfile_path"
        if brew list "$app" &>/dev/null; then
            echo "**** $app is already installed" | tee -a "$logfile_path"
        else
            brew install "$app"
        fi
    done
}

install_linux_apps() {
    for app in "${all_apps[@]}"; do
        install_linux_app "$app"
    done

    for app in "${linux_apps[@]}"; do
        install_linux_app "$app"
    done

    install_linux_special_apps

    install_brew_linux_apps
}

# ---- Environment setup --------------------------------------------

setup_terminal() {
    if [[ "$no_terminal" = true ]]; then
        echo "**** Skipping terminal setup ..." | tee -a "$logfile_path"
        return
    fi

    # Starship
    yes | curl -fsSL https://starship.rs/install.sh | sh -s -- --bin-dir /usr/local/bin --force | tee -a "$logfile_path"

    # ZSH Auto Suggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions | tee -a "$logfile_path"

    # ZSH Highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-highlighting | tee -a "$logfile_path"
}

# ---- Main logic --------------------------------------------

install_brew

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_linux_apps
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_mac_brew_apps
else
    echo "Unsupported $OSTYPE for brew installation" | tee -a "$logfile_path"
    exit 1
fi

setup_terminal
