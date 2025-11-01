#!/usr/bin/env bash

# ══════════════════════════════════════════════════════════════════════
# Neovim Ultimate Edition - Update Script
# Pull latest changes and update plugins
# ══════════════════════════════════════════════════════════════════════

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

print_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

main() {
  echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${NC}  Neovim Ultimate Edition - Update"
  echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
  echo ""

  # Check if config directory exists
  if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo "Error: Neovim config directory not found: $NVIM_CONFIG_DIR"
    exit 1
  fi

  cd "$NVIM_CONFIG_DIR"

  # Check if it's a git repository
  if [ -d ".git" ]; then
    print_info "Pulling latest changes..."
    git pull origin main || git pull origin master

    print_success "Configuration updated!"
  else
    print_warning "Not a git repository. Skipping git pull."
    print_info "To enable updates, clone the repository instead of copying files."
  fi

  echo ""
  print_info "Updating plugins..."
  nvim --headless "+Lazy! sync" +qa

  echo ""
  print_success "Update complete!"
  echo ""
  echo "Next steps:"
  echo "  1. Restart Neovim"
  echo "  2. Run ${YELLOW}:checkhealth${NC} to verify everything is working"
  echo "  3. Run ${YELLOW}:NvimUltimateHealth${NC} for detailed diagnostics"
}

main "$@"
