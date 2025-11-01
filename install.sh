#!/bin/bash

# ══════════════════════════════════════════════════════════════════════
# Neovim Ultimate Edition - Universal Installer
# Multi-platform, profile-based Neovim configuration
# Supports: macOS (ARM64/Intel), Linux (Ubuntu/Arch/Fedora), Windows WSL
# Features: dry-run, rollback, dependency check, profile selection
# ══════════════════════════════════════════════════════════════════════

set -e

# Parse command line arguments
DRY_RUN=false
SKIP_DEPS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skip-deps)
      SKIP_DEPS=true
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --dry-run     Show what would be installed without making changes"
      echo "  --skip-deps   Skip dependency installation"
      echo "  --help        Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
BACKUP_DIR="$HOME/.config/nvim-backup-$(date +%Y%m%d-%H%M%S)"
LOG_FILE="/tmp/nvim-ultimate-install-$(date +%Y%m%d-%H%M%S).log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_URL="https://github.com/quadbyte/nvim-ultimate.git"
TEMP_CLONE_DIR=""

# ══════════════════════════════════════════════════════════════════════
# Helper Functions
# ══════════════════════════════════════════════════════════════════════

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

print_header() {
  echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║${NC}  $1"
  echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
  log "SUCCESS: $1"
}

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
  log "INFO: $1"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
  log "WARNING: $1"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
  log "ERROR: $1"
}

error_exit() {
  print_error "$1"
  echo "Check log: $LOG_FILE"

  # Offer rollback if backup exists
  if [ -d "$BACKUP_DIR" ]; then
    echo ""
    read -p "Would you like to rollback to backup? [y/N] " -n 1 -r < /dev/tty
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      print_info "Rolling back..."
      if [ -d "$BACKUP_DIR/config" ]; then
        rm -rf "$NVIM_CONFIG_DIR"
        cp -r "$BACKUP_DIR/config" "$NVIM_CONFIG_DIR"
        print_success "Configuration restored from backup"
      fi
      if [ -d "$BACKUP_DIR/data" ]; then
        rm -rf "$NVIM_DATA_DIR"
        cp -r "$BACKUP_DIR/data" "$NVIM_DATA_DIR"
        print_success "Data restored from backup"
      fi
    fi
  fi

  exit 1
}

# ══════════════════════════════════════════════════════════════════════
# Platform Detection
# ══════════════════════════════════════════════════════════════════════

detect_platform() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="macos"
    ARCH=$(uname -m)
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if grep -qi microsoft /proc/version 2>/dev/null; then
      PLATFORM="wsl"
    else
      PLATFORM="linux"
    fi
    ARCH=$(uname -m)
  else
    error_exit "Unsupported platform: $OSTYPE"
  fi

  print_info "Detected: $PLATFORM ($ARCH)"
}

detect_package_manager() {
  if [[ "$PLATFORM" == "macos" ]]; then
    PKG_MANAGER="brew"
  elif [[ "$PLATFORM" == "linux" ]] || [[ "$PLATFORM" == "wsl" ]]; then
    if command -v apt &> /dev/null; then
      PKG_MANAGER="apt"
    elif command -v pacman &> /dev/null; then
      PKG_MANAGER="pacman"
    elif command -v dnf &> /dev/null; then
      PKG_MANAGER="dnf"
    else
      error_exit "No supported package manager found"
    fi
  fi
  print_info "Package manager: $PKG_MANAGER"
}

# ══════════════════════════════════════════════════════════════════════
# Repository Cloning (for curl installation)
# ══════════════════════════════════════════════════════════════════════

clone_repository() {
  # Check if we're running from a cloned repo or from curl
  if [ ! -f "$SCRIPT_DIR/init.lua" ] || [ ! -d "$SCRIPT_DIR/lua" ]; then
    print_header "CLONING REPOSITORY"
    print_info "Downloading Neovim Ultimate Edition..."

    TEMP_CLONE_DIR="/tmp/nvim-ultimate-$(date +%Y%m%d-%H%M%S)"

    if [ "$DRY_RUN" = true ]; then
      print_info "[DRY RUN] Would clone $REPO_URL to $TEMP_CLONE_DIR"
      SCRIPT_DIR="$TEMP_CLONE_DIR"
      return
    fi

    if ! command -v git &> /dev/null; then
      error_exit "git is required but not installed. Please install git first."
    fi

    git clone --depth 1 "$REPO_URL" "$TEMP_CLONE_DIR" 2>&1 | tee -a "$LOG_FILE" || error_exit "Failed to clone repository"
    SCRIPT_DIR="$TEMP_CLONE_DIR"
    print_success "Repository cloned to $TEMP_CLONE_DIR"
  else
    print_info "Running from local repository: $SCRIPT_DIR"
  fi
}

cleanup_temp_clone() {
  if [ -n "$TEMP_CLONE_DIR" ] && [ -d "$TEMP_CLONE_DIR" ]; then
    print_info "Cleaning up temporary clone..."
    rm -rf "$TEMP_CLONE_DIR"
  fi
}

# ══════════════════════════════════════════════════════════════════════
# Profile Selection
# ══════════════════════════════════════════════════════════════════════

select_profile() {
  clear
  print_header "PROFILE SELECTION"
  echo ""
  echo "Choose your development profile:"
  echo ""
  echo "  1) 🎨 Frontend Developer  (JS/TS, React, Vue, Tailwind)"
  echo "  2) 🔧 Backend Developer   (Python, Go, Rust, Node, SQL)"
  echo "  3) 📱 Mobile Developer    (React Native, Flutter, Swift)"
  echo "  4) 📊 Data Engineer       (Python, SQL, R, Jupyter)"
  echo "  5) 🚀 DevOps Engineer     (Bash, Docker, K8s, Terraform)"
  echo "  6) 🌐 Full Stack          (Frontend + Backend)"
  echo "  7) ⚡ Minimal             (Lightweight, core only)"
  echo ""
  read -p "Choose profile [1-7]: " profile_choice < /dev/tty

  case $profile_choice in
    1) PROFILE="frontend" ;;
    2) PROFILE="backend" ;;
    3) PROFILE="mobile" ;;
    4) PROFILE="data" ;;
    5) PROFILE="devops" ;;
    6) PROFILE="fullstack" ;;
    7) PROFILE="minimal" ;;
    *) error_exit "Invalid choice" ;;
  esac

  print_success "Selected profile: $PROFILE"
}

# ══════════════════════════════════════════════════════════════════════
# Dependency Check
# ══════════════════════════════════════════════════════════════════════

check_dependencies() {
  print_header "CHECKING DEPENDENCIES"

  local deps_ok=true
  local required_deps=("git" "nvim")
  local optional_deps=("node" "rg" "fd" "fzf" "lazygit")

  # Check required dependencies
  for dep in "${required_deps[@]}"; do
    if command -v "$dep" &> /dev/null; then
      print_success "$dep found"
    else
      print_error "$dep not found (required)"
      deps_ok=false
    fi
  done

  # Check optional dependencies
  for dep in "${optional_deps[@]}"; do
    if command -v "$dep" &> /dev/null; then
      print_success "$dep found"
    else
      print_warning "$dep not found (optional, some features may not work)"
    fi
  done

  # Check Neovim version
  if command -v nvim &> /dev/null; then
    local nvim_version=$(nvim --version | head -n 1 | grep -oP 'v\K[0-9]+\.[0-9]+')
    local major=$(echo "$nvim_version" | cut -d. -f1)
    local minor=$(echo "$nvim_version" | cut -d. -f2)

    if [ "$major" -eq 0 ] && [ "$minor" -lt 9 ]; then
      print_error "Neovim 0.9+ required. Found: $nvim_version"
      deps_ok=false
    else
      print_success "Neovim version $nvim_version (OK)"
    fi
  fi

  if [ "$deps_ok" = false ]; then
    error_exit "Required dependencies missing"
  fi
}

# ══════════════════════════════════════════════════════════════════════
# Dependency Installation
# ══════════════════════════════════════════════════════════════════════

install_dependencies() {
  print_header "INSTALLING DEPENDENCIES"

  if [ "$DRY_RUN" = true ]; then
    print_info "[DRY RUN] Would install dependencies using $PKG_MANAGER"
    return
  fi

  case $PKG_MANAGER in
    brew)
      TOOLS=(neovim git node ripgrep fd fzf lazygit)
      for tool in "${TOOLS[@]}"; do
        if brew list "$tool" &>/dev/null; then
          print_info "$tool already installed"
        else
          print_info "Installing $tool..."
          brew install "$tool" || print_warning "Failed to install $tool"
        fi
      done
      ;;
    apt)
      sudo apt update
      sudo apt install -y neovim git nodejs npm ripgrep fd-find fzf curl unzip || error_exit "apt install failed"
      ;;
    pacman)
      sudo pacman -Sy --noconfirm neovim git nodejs npm ripgrep fd fzf || error_exit "pacman install failed"
      ;;
    dnf)
      sudo dnf install -y neovim git nodejs npm ripgrep fd-find fzf || error_exit "dnf install failed"
      ;;
  esac

  print_success "Dependencies installed"
}

# ══════════════════════════════════════════════════════════════════════
# Backup & Deploy
# ══════════════════════════════════════════════════════════════════════

backup_existing() {
  if [ -d "$NVIM_CONFIG_DIR" ]; then
    if [ "$DRY_RUN" = true ]; then
      print_info "[DRY RUN] Would backup existing config to $BACKUP_DIR"
      return
    fi

    print_info "Backing up existing config..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$NVIM_CONFIG_DIR" "$BACKUP_DIR/config"
    [ -d "$NVIM_DATA_DIR" ] && cp -r "$NVIM_DATA_DIR" "$BACKUP_DIR/data"
    print_success "Backup created: $BACKUP_DIR"
  fi
}

deploy_config() {
  print_header "DEPLOYING CONFIGURATION"

  if [ "$DRY_RUN" = true ]; then
    print_info "[DRY RUN] Would deploy configuration to $NVIM_CONFIG_DIR"
    print_info "[DRY RUN] Would create profile: $PROFILE"
    return
  fi

  # Create directories
  mkdir -p "$NVIM_CONFIG_DIR"
  mkdir -p "$NVIM_DATA_DIR"

  # Copy configuration files
  print_info "Copying config files..."
  cp "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG_DIR/"
  cp -r "$SCRIPT_DIR/lua" "$NVIM_CONFIG_DIR/"

  # Copy additional files
  [ -f "$SCRIPT_DIR/profile.json" ] && cp "$SCRIPT_DIR/profile.json" "$NVIM_CONFIG_DIR/"
  [ -f "$SCRIPT_DIR/.gitignore" ] && cp "$SCRIPT_DIR/.gitignore" "$NVIM_CONFIG_DIR/"

  # Copy documentation files
  print_info "Copying documentation..."
  for doc in README.md QUICKSTART.md KEYBINDINGS.md THEMES.md ICONS.md CUSTOMIZATION.md CONTRIBUTING.md CHANGELOG.md LICENSE; do
    [ -f "$SCRIPT_DIR/$doc" ] && cp "$SCRIPT_DIR/$doc" "$NVIM_CONFIG_DIR/"
  done

  # Copy scripts
  [ -f "$SCRIPT_DIR/update.sh" ] && cp "$SCRIPT_DIR/update.sh" "$NVIM_CONFIG_DIR/" && chmod +x "$NVIM_CONFIG_DIR/update.sh"
  [ -f "$SCRIPT_DIR/uninstall.sh" ] && cp "$SCRIPT_DIR/uninstall.sh" "$NVIM_CONFIG_DIR/" && chmod +x "$NVIM_CONFIG_DIR/uninstall.sh"

  # Create/update profile configuration
  cat > "$NVIM_CONFIG_DIR/profile.json" << EOF
{
  "active_profile": "$PROFILE",
  "performance_mode": "balanced",
  "last_updated": "$(date +%Y-%m-%d)",
  "custom_settings": {
    "enable_inlay_hints": false,
    "format_on_save": true,
    "auto_install_lsp": true,
    "session_autosave": true
  }
}
EOF

  print_success "Configuration deployed"
}

# ══════════════════════════════════════════════════════════════════════
# Plugin Installation
# ══════════════════════════════════════════════════════════════════════

install_plugins() {
  print_header "INSTALLING PLUGINS"

  if [ "$DRY_RUN" = true ]; then
    print_info "[DRY RUN] Would install 50+ plugins using lazy.nvim"
    return
  fi

  echo ""
  print_info "This may take 2-5 minutes..."
  echo ""

  if nvim --headless "+Lazy! sync" +qa 2>&1 | tee -a "$LOG_FILE"; then
    print_success "Plugins installed successfully"
  else
    print_warning "Some plugins may need manual sync"
    print_info "Run :Lazy sync in Neovim"
  fi
}

# ══════════════════════════════════════════════════════════════════════
# Main Installation
# ══════════════════════════════════════════════════════════════════════

main() {
  # Set up cleanup trap
  trap cleanup_temp_clone EXIT

  clear
  print_header "NEOVIM ULTIMATE EDITION INSTALLER"
  echo ""
  echo "Multi-platform, profile-based Neovim configuration"
  if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN MODE - No changes will be made]${NC}"
  fi
  echo ""

  # Detect platform
  detect_platform
  detect_package_manager

  # Clone repository if running from curl
  clone_repository

  # Check dependencies first
  if [ "$SKIP_DEPS" = false ]; then
    check_dependencies
  fi

  # Select profile
  select_profile

  # Confirm installation
  if [ "$DRY_RUN" = false ]; then
    echo ""
    read -p "Continue with installation? [y/N] " -n 1 -r < /dev/tty
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_info "Installation cancelled"
      exit 0
    fi
  fi

  # Install
  backup_existing

  if [ "$SKIP_DEPS" = false ]; then
    install_dependencies
  else
    print_info "Skipping dependency installation (--skip-deps)"
  fi

  deploy_config
  install_plugins

  # Success
  if [ "$DRY_RUN" = true ]; then
    echo ""
    print_header "DRY RUN COMPLETE"
    echo ""
    print_info "No changes were made. Run without --dry-run to install."
    echo ""
    echo "Would install:"
    echo "  Profile: $PROFILE"
    echo "  Config: $NVIM_CONFIG_DIR"
    echo "  Plugins: 50+"
    exit 0
  fi

  echo ""
  print_header "INSTALLATION COMPLETE"
  echo ""
  print_success "Neovim Ultimate Edition installed successfully!"
  echo ""
  print_info "Profile: $PROFILE"
  print_info "Config: $NVIM_CONFIG_DIR"
  print_info "Backup: $BACKUP_DIR"
  print_info "Log: $LOG_FILE"
  echo ""
  echo "Next steps:"
  echo "  1. Launch Neovim:"
  echo "     nvim"
  echo ""
  echo "  2. Run health check:"
  echo "     :NvimUltimateHealth"
  echo ""
  echo "  3. View keybindings:"
  echo "     cat $NVIM_CONFIG_DIR/KEYBINDINGS.md"
  echo ""
  echo "  4. Switch profile:"
  echo "     :ProfileSwitch <name>"
  echo ""
  echo "  5. Profile picker:"
  echo "     :ProfilePicker"
  echo ""
  echo "  6. Manage plugins:"
  echo "     :Lazy"
  echo ""
  echo "Documentation:"
  echo "  README:      $NVIM_CONFIG_DIR/README.md"
  echo "  Keybindings: $NVIM_CONFIG_DIR/KEYBINDINGS.md"
  echo "  Themes:      $NVIM_CONFIG_DIR/THEMES.md"
  echo "  Icons:       $NVIM_CONFIG_DIR/ICONS.md"
  echo "  Customize:   $NVIM_CONFIG_DIR/CUSTOMIZATION.md"
  echo ""
  echo "Management:"
  echo "  Update:      $NVIM_CONFIG_DIR/update.sh"
  echo "  Uninstall:   $NVIM_CONFIG_DIR/uninstall.sh"
  echo ""
  print_success "Happy coding! 🚀"
}

main "$@"
