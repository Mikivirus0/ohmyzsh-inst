#!/bin/bash

# Oh My Zsh Customizer Tool By MikiVirus

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$OH_MY_ZSH_PATH/custom"
ZSHRC_PATH="$HOME/.zshrc"
ZSHRC_BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"



print_header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║             OH MY ZSH CUSTOMIZER TOOL                      ║${NC}"
    echo -e "${BLUE}║             Complete Setup & Configuration                 ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

print_section() {
    echo -e "\n${CYAN}▶ $1${NC}"
    echo -e "${CYAN}$(printf '─%.0s' {1..60})${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ensure_omz_installed() {
    if [ ! -d "$OH_MY_ZSH_PATH" ]; then
        print_error "Oh My Zsh is not installed. Please run a full installation first."
        exit 1
    fi
}



check_requirements() {
    print_section "Checking System Requirements"
    local missing_deps=()

    if ! command_exists "curl" && ! command_exists "wget"; then
        missing_deps+=("curl or wget")
    fi
    if ! command_exists "git"; then
        missing_deps+=("git")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        echo -e "\nPlease install the missing dependencies and run the script again."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo -e "\nOn Ubuntu/Debian: ${YELLOW}sudo apt update && sudo apt install curl git${NC}"
            echo -e "On RHEL/CentOS: ${YELLOW}sudo yum install curl git${NC}"
            echo -e "On Arch: ${YELLOW}sudo pacman -S curl git${NC}"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "\nOn macOS: ${YELLOW}brew install curl git${NC}"
        fi
        exit 1
    fi
    print_success "All dependencies are available"
}

setup_zsh() {
    print_section "Setting up Zsh Shell"
    if ! command_exists "zsh"; then
        print_warning "Zsh is not installed. Installing..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command_exists "apt"; then sudo apt update && sudo apt install -y zsh
            elif command_exists "yum"; then sudo yum install -y zsh
            elif command_exists "dnf"; then sudo dnf install -y zsh
            elif command_exists "pacman"; then sudo pacman -S --noconfirm zsh
            else
                print_error "Could not install zsh. Please install it manually."
                exit 1
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command_exists "brew"; then brew install zsh
            else print_info "Zsh is usually default on macOS. If not, install Homebrew and run: brew install zsh"
            fi
        fi
        print_success "Zsh installed successfully"
    else
        print_success "Zsh is already installed"
    fi

    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Current shell: $SHELL"
        read -p "Would you like to set Zsh as your default shell? (y/n): " -r set_default
        if [[ "$set_default" =~ ^[Yy]$ ]]; then
            echo "Changing default shell to Zsh..."
            chsh -s "$(which zsh)"
            print_success "Default shell changed to Zsh (will take effect on next login)"
        fi
    else
        print_success "Zsh is already the default shell"
    fi
}

install_fresh_ohmyzsh() {
    print_info "Installing Oh My Zsh..."
    
    if [ -f "$ZSHRC_PATH" ]; then
        cp "$ZSHRC_PATH" "$ZSHRC_BACKUP"
        print_info "Backed up existing .zshrc to $ZSHRC_BACKUP"
    fi
    
    if command_exists "curl"; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    elif command_exists "wget"; then
        sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended
    fi
    
    print_success "Oh My Zsh installed successfully"
}

install_oh_my_zsh() {
    print_section "Installing Oh My Zsh"
    if [ -d "$OH_MY_ZSH_PATH" ]; then
        print_warning "Oh My Zsh is already installed at $OH_MY_ZSH_PATH"
        echo -e "\nWould you like to:"
        echo "1) Keep existing installation and continue"
        echo "2) Backup and reinstall"
        echo "3) Exit"
        read -p "Choose option (1-3): " -r choice
        
        case $choice in
            1) print_info "Continuing with existing installation..." ;;
            2)
                echo "Backing up existing Oh My Zsh installation..."
                mv "$OH_MY_ZSH_PATH" "${OH_MY_ZSH_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
                install_fresh_ohmyzsh
                ;;
            3) echo "Exiting..."; exit 0 ;;
            *) print_error "Invalid choice. Exiting..."; exit 1 ;;
        esac
    else
        install_fresh_ohmyzsh
    fi
}

set_theme() {
    local theme_name="$1"
    sed -i.bak "s/^ZSH_THEME=\".*\"/ZSH_THEME=\"$theme_name\"/" "$ZSHRC_PATH"
    print_success "Theme set to: $theme_name"
}

install_powerlevel10k() {
    print_info "Installing Powerlevel10k theme..."
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    else
        print_info "Powerlevel10k already downloaded."
    fi
    set_theme "powerlevel10k/powerlevel10k"
    print_success "Powerlevel10k is set! Run 'p10k configure' in your new terminal to configure it."
}

select_theme() {
    print_section "Theme Selection"
    ensure_omz_installed

    print_info "Gathering list of available themes..."
    local all_themes=()
    local builtin_themes_path="$OH_MY_ZSH_PATH/themes"
    local custom_themes_path="$ZSH_CUSTOM/themes"

    if [ -d "$builtin_themes_path" ]; then
        all_themes+=( $(find "$builtin_themes_path" -maxdepth 1 -name "*.zsh-theme" -exec basename {} .zsh-theme \;) )
    fi

    if [ -d "$custom_themes_path" ]; then
        all_themes+=( $(find "$custom_themes_path" -maxdepth 1 -name "*.zsh-theme" -exec basename {} .zsh-theme \;) )
    fi

    if [ ${#all_themes[@]} -eq 0 ]; then
        print_warning "Could not find any themes to display."
        print_info "You can still manually enter a theme name below."
    else
        local sorted_unique_themes=($(printf "%s\n" "${all_themes[@]}" | sort -u))

        echo -e "\n${PURPLE}Available Themes:${NC}"
        if command_exists "column"; then
            printf "%s\n" "${sorted_unique_themes[@]}" | column
        else
            echo "${sorted_unique_themes[@]}"
        fi
    fi

    echo 
    print_info "Popular choices: powerlevel10k (installs automatically), agnoster, robbyrussell"
    read -p "Enter the name of the theme to use (or press Enter to cancel): " -r theme_name

    if [ -z "$theme_name" ]; then
        print_info "Theme selection cancelled."
        return
    fi

    if [[ "$theme_name" == "powerlevel10k" ]]; then
        install_powerlevel10k
    else
        set_theme "$theme_name"
    fi
}

add_plugin_to_zshrc() {
    local plugin_name="$1"
    local current_plugins
    current_plugins=$(grep "^plugins=" "$ZSHRC_PATH" | sed 's/plugins=(//' | sed 's/)//')
    
    if [[ ! " $current_plugins " =~ " $plugin_name " ]]; then
        local new_plugins="$current_plugins $plugin_name"
        sed -i.bak "s/plugins=(.*)/plugins=($new_plugins)/" "$ZSHRC_PATH"
        print_success "Added plugin: $plugin_name"
    else
        print_info "Plugin already enabled: $plugin_name"
    fi
}

install_external_plugins() {
    print_section "Installing External Plugins"
    ensure_omz_installed
    print_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    add_plugin_to_zshrc "zsh-autosuggestions"
    
    print_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
    add_plugin_to_zshrc "zsh-syntax-highlighting"
}

additional_customizations() {
    print_section "Adding Customizations"
    ensure_omz_installed
    
    echo "Adding useful aliases and functions to $ZSHRC_PATH..."
    cat >> "$ZSHRC_PATH" << 'EOF'

# --- CUSTOM ALIASES & FUNCTIONS ---
# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias c='clear'
alias myip='curl http://ipecho.net/plain; echo'
alias ports='netstat -tulanp'

# Functions
# Create a directory and cd into it
mkcd () {
    mkdir -p "$1" && cd "$1"
}
EOF
    print_success "Customizations added!"
}

install_fonts() {
    print_section "Font Installation"
    read -p "Install recommended fonts (MesloLGS NF for Powerlevel10k)? (y/n): " -r choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        print_info "Installing Nerd Fonts..."
        local font_dir="$HOME/.local/share/fonts"
        mkdir -p "$font_dir"
        
        curl -fLo "$font_dir/MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        curl -fLo "$font_dir/MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
        curl -fLo "$font_dir/MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
        curl -fLo "$font_dir/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
        
        if command_exists "fc-cache"; then
            fc-cache -fv
        fi
        
        print_success "Fonts installed! Please set your terminal font to 'MesloLGS NF'."
    fi
}

uninstall_oh_my_zsh() {
    print_section "Uninstalling Oh My Zsh"
    read -p "⚠️ Are you sure you want to remove Oh My Zsh? (y/N): " -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Uninstalling..."
        if [ -f "$OH_MY_ZSH_PATH/tools/uninstall.sh" ]; then
            bash "$OH_MY_ZSH_PATH/tools/uninstall.sh"
        else
            rm -rf "$OH_MY_ZSH_PATH"
            if [ -f "$ZSHRC_BACKUP" ]; then
                mv "$ZSHRC_BACKUP" "$ZSHRC_PATH"
                print_success "Configuration restored from backup."
            fi
        fi
        print_success "Oh My Zsh uninstalled."
    else
        print_info "Uninstall cancelled."
    fi
}

show_current_config() {
    print_section "Current Configuration"
    echo -e "${CYAN}• OS:${NC} $(uname -s)"
    echo -e "${CYAN}• Shell:${NC} $SHELL"
    echo -e "${CYAN}• Zsh Version:${NC} $(zsh --version 2>/dev/null || echo 'Not installed')"

    if [ -d "$OH_MY_ZSH_PATH" ]; then
        echo -e "\n${PURPLE}Oh My Zsh:${NC}"
        echo -e "${CYAN}• Status:${NC} ${GREEN}Installed${NC}"
        if [ -f "$ZSHRC_PATH" ]; then
            local theme plugins
            theme=$(grep "^ZSH_THEME=" "$ZSHRC_PATH" | cut -d'"' -f2)
            plugins=$(grep "^plugins=" "$ZSHRC_PATH" | sed 's/plugins=(//;s/)//')
            echo -e "${CYAN}• Theme:${NC} $theme"
            echo -e "${CYAN}• Plugins:${NC} $plugins"
        fi
    else
        echo -e "\n${PURPLE}Oh My Zsh:${NC} ${RED}Not installed${NC}"
    fi

    echo -e "\nPress Enter to return to the menu..."
    read -r
}

final_setup() {
    print_section "Final Summary"
    echo -e "\n${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                     SETUP COMPLETE!                          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    
    echo -e "\n${YELLOW}What was configured:${NC}"
    if [ -f "$ZSHRC_PATH" ]; then
        current_theme=$(grep "^ZSH_THEME=" "$ZSHRC_PATH" | cut -d'"' -f2)
        current_plugins=$(grep "^plugins=" "$ZSHRC_PATH" | sed 's/plugins=(//' | sed 's/)//')
        echo -e "${CYAN}• Theme:${NC} $current_theme"
        echo -e "${CYAN}• Plugins:${NC} $current_plugins"
        echo -e "${CYAN}• Configuration file:${NC} $ZSHRC_PATH"
        if [ -f "$ZSHRC_BACKUP" ]; then
            echo -e "${CYAN}• Backup created:${NC} $ZSHRC_BACKUP"
        fi
    fi

    echo -e "\n${YELLOW}Next steps:${NC}"
    echo -e "1. Restart your terminal or run: ${GREEN}source ~/.zshrc${NC}"
    echo -e "2. If you installed Powerlevel10k, run: ${GREEN}p10k configure${NC}"
    echo -e "3. Set your terminal font to 'MesloLGS NF' if you installed fonts."
}

run_full_setup() {
    check_requirements
    setup_zsh
    install_oh_my_zsh
    select_theme
    install_external_plugins
    additional_customizations
    install_fonts
    final_setup
}



show_menu() {
    while true; do
        clear
        print_header
        echo -e "${PURPLE}What would you like to do?${NC}"
        echo
        echo "1) 🚀 Complete Setup (Install Zsh, Oh My Zsh, themes, plugins)"
        echo "2) 🎨 Change Theme"
        echo "3) 🔌 Install External Plugins"
        echo "4) ⚙️  Add Custom Aliases/Functions"
        echo "5) 🔤 Install Fonts"
        echo "6) 🗑️  Uninstall Oh My Zsh"
        echo "7) ℹ️  Show Current Configuration"
        echo "8) ❌ Exit"
        echo
        read -p "Choose option (1-8): " -r menu_choice
        case $menu_choice in
            1) run_full_setup; break ;;
            2) select_theme; final_setup; break ;;
            3) install_external_plugins; final_setup; break ;;
            4) additional_customizations; final_setup; break ;;
            5) install_fonts; break ;;
            6) uninstall_oh_my_zsh; break ;;
            7) show_current_config ;; # Loop back to menu after showing config
            8) echo "Goodbye! 👋"; exit 0 ;;
            *) print_error "Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

handle_arguments() {
    case "$1" in
        --install|--complete) run_full_setup ;;
        --theme) select_theme; final_setup ;;
        --plugins) install_external_plugins; final_setup ;;
        --customize) additional_customizations; final_setup ;;
        --fonts) install_fonts ;;
        --uninstall) uninstall_oh_my_zsh ;;
        --status) show_current_config ;;
        --help|-h)
            print_header
            echo "Usage: $0 [argument]"
            echo "  --complete    Run the full interactive setup."
            echo "  --uninstall   Remove Oh My Zsh."
            echo "  --status      Show the current configuration."
            echo "  --help, -h    Show this help message."
            echo "Running with no arguments starts the interactive menu."
            ;;
        *)
            print_error "Invalid argument: $1"
            echo "Use '$0 --help' for a list of available options."
            exit 1
            ;;
    esac
}



main() {
    trap 'echo -e "\n${RED}Setup interrupted by user.${NC}"; exit 1' INT
    if [ $# -gt 0 ]; then
        handle_arguments "$1"
    else
        show_menu
    fi
}

main "$@"