# Oh My Zsh Customizer Tool

The **Oh My Zsh Customizer** is a powerful and interactive shell script designed to simplify the installation, configuration, and management of Zsh and the Oh My Zsh framework. Whether you are setting up a new machine or just want to refresh your terminal's look and feel, this tool provides a streamlined menu-driven experience to get you up and running in minutes.

-----

## Features

  - **Interactive Menu**: A user-friendly, menu-based interface for all operations.
  - **Automated Installation**: Installs Zsh and Oh My Zsh, and sets Zsh as the default shell.
  - **Dependency Check**: Automatically checks for required tools like `git`, `curl`, and `wget`.
  - **Theme Management**: Displays a table of available themes and allows you to easily switch between them. It includes special installers for popular themes like `Powerlevel10k`.
  - **Plugin Management**: Quickly install essential plugins like `zsh-autosuggestions` and `zsh-syntax-highlighting`.
  - **Font Installation**: One-click installation of recommended Nerd Fonts (MesloLGS NF) for perfect theme rendering.
  - **Customization**: Easily add a set of useful aliases and functions to your configuration.
  - **Non-Interactive Mode**: Supports command-line arguments for automated setups.
  - **Clean Uninstall**: A dedicated option to safely remove Oh My Zsh and restore your previous configuration.

-----

## Prerequisites

Before running the script, ensure you have the following installed on your system:

  * A Unix-like operating system (e.g., Linux, macOS).
  * `sudo` / root privileges to install packages.
  * `git`
  * `curl` or `wget`

The script will check for these dependencies and guide you if any are missing.

-----

## Installation and Usage

You can get started with just two commands.

### 1\. Download the script

Download the `zshc.sh` script using `curl` or `wget`:

```bash
git clone  https://github.com/Mikivirus0/ohmyzsh-inst
```

### 2\. Make it executable

```bash
cd ohmyzsh-inst
chmod +x ohmyzshc.sh
```

### 3\. Run the tool

Execute the script to launch the interactive menu:

```bash
./ohmyzshc.sh
```

You will be greeted by the main menu where you can select the desired operation.

-----

## Command-Line Usage (Non-Interactive)

For automation or quick tasks, you can use the following command-line arguments instead of the interactive menu.

```bash
╔════════════════════════════════════════════════════════════════╗
║             OH MY ZSH CUSTOMIZER TOOL                      ║
║             Complete Setup & Configuration                 ║
╚════════════════════════════════════════════════════════════════╝

What would you like to do?

1) 🚀 Complete Setup (Install Zsh, Oh My Zsh, themes, plugins)
2) 🎨 Change Theme
3) 🔌 Install External Plugins
4) ⚙️  Add Custom Aliases/Functions
5) 🔤 Install Fonts
6) 🗑️  Uninstall Oh My Zsh
7) ℹ️  Show Current Configuration
8) ❌ Exit

Choose option (1-8): 
```

**Example:**

```bash
# Run the complete installation non-interactively
./zshc.sh --complete
```

```bash
# Uninstall Oh My Zsh
./zshc.sh --uninstall
```

-----


## License

This project is distributed under the MIT License. See the `LICENSE` file for more information.