#!/bin/bash

# ══════════════════════════════════════════════════════════════════════
# Neovim Ultimate Edition - Uninstall Script
# Remove configuration and optionally remove data
# ══════════════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
BACKUP_DIR="$HOME/.config/nvim-backup-before-uninstall-$(date +%Y%m%d-%H%M%S)"

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

main() {
  echo -e "${RED}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║${NC}  Neovim Ultimate Edition - Uninstall"
  echo -e "${RED}╚════════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  print_warning "This will remove your Neovim configuration!"
  echo ""
  echo "What to remove?"
  echo "  1) Configuration only (keep plugins and data)"
  echo "  2) Configuration + data (complete removal)"
  echo "  3) Cancel"
  echo ""
  read -p "Choose [1-3]: " choice < /dev/tty

  case $choice in
    1)
      print_info "Removing configuration only..."
      if [ -d "$NVIM_CONFIG_DIR" ]; then
        print_info "Creating backup..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$NVIM_CONFIG_DIR" "$BACKUP_DIR/"
        print_success "Backup created: $BACKUP_DIR"

        rm -rf "$NVIM_CONFIG_DIR"
        print_success "Configuration removed"
      else
        print_info "Configuration directory not found"
      fi
      ;;
    2)
      print_info "Removing configuration and data..."
      if [ -d "$NVIM_CONFIG_DIR" ] || [ -d "$NVIM_DATA_DIR" ]; then
        print_info "Creating backup..."
        mkdir -p "$BACKUP_DIR"
        [ -d "$NVIM_CONFIG_DIR" ] && cp -r "$NVIM_CONFIG_DIR" "$BACKUP_DIR/config"
        [ -d "$NVIM_DATA_DIR" ] && cp -r "$NVIM_DATA_DIR" "$BACKUP_DIR/data"
        print_success "Backup created: $BACKUP_DIR"

        rm -rf "$NVIM_CONFIG_DIR"
        rm -rf "$NVIM_DATA_DIR"
        print_success "Configuration and data removed"
      else
        print_info "Nothing to remove"
      fi
      ;;
    3)
      print_info "Uninstall cancelled"
      exit 0
      ;;
    *)
      print_error "Invalid choice"
      exit 1
      ;;
  esac

  echo ""
  print_success "Uninstall complete!"
  echo ""
  print_info "Backup location: $BACKUP_DIR"
  echo ""
  echo "To restore from backup:"
  echo "  cp -r $BACKUP_DIR/config $NVIM_CONFIG_DIR"
  [ -d "$BACKUP_DIR/data" ] && echo "  cp -r $BACKUP_DIR/data $NVIM_DATA_DIR"
}

main "$@"
