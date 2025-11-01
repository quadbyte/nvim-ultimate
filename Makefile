# ══════════════════════════════════════════════════════════════════════
# Neovim Ultimate Edition - Makefile
# Copyright (c) 2024-2025 QuadByte
# ══════════════════════════════════════════════════════════════════════

.PHONY: help install uninstall update test clean build docker-test lint format check-deps version

# Default target
.DEFAULT_GOAL := help

# Variables
SHELL := /bin/bash
NVIM_CONFIG_DIR := $(HOME)/.config/nvim
BACKUP_DIR := $(HOME)/.config/nvim-backup-$(shell date +%Y%m%d-%H%M%S)
PROJECT_DIR := $(shell pwd)

# Colors for output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

##@ General

help: ## Display this help message
	@echo "$(CYAN)╔════════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║$(NC)  Neovim Ultimate Edition - Makefile Commands"
	@echo "$(CYAN)╚════════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make $(CYAN)<target>$(NC)\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(CYAN)%-20s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(YELLOW)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo ""

version: ## Display version information
	@echo "$(CYAN)Neovim Ultimate Edition$(NC)"
	@echo "Version: 0.1.0"
	@echo "Copyright (c) 2024-2025 QuadByte"
	@echo "Repository: https://github.com/quadbyte/nvim-ultimate"

##@ Installation

install: ## Install Neovim Ultimate Edition
	@echo "$(GREEN)Installing Neovim Ultimate Edition...$(NC)"
	@bash install.sh

install-dry-run: ## Dry run installation (no changes made)
	@echo "$(YELLOW)Running installation in dry-run mode...$(NC)"
	@bash install.sh --dry-run

install-skip-deps: ## Install without dependency installation
	@echo "$(GREEN)Installing without dependencies...$(NC)"
	@bash install.sh --skip-deps

uninstall: ## Uninstall Neovim Ultimate Edition
	@echo "$(RED)Uninstalling Neovim Ultimate Edition...$(NC)"
	@bash uninstall.sh

update: ## Update Neovim Ultimate Edition
	@echo "$(GREEN)Updating Neovim Ultimate Edition...$(NC)"
	@bash update.sh

##@ Development

test: ## Run all tests
	@echo "$(GREEN)Running all tests...$(NC)"
	@bash tests/run-all-tests.sh

test-profile: ## Test profile switching (requires PROFILE variable)
	@if [ -z "$(PROFILE)" ]; then \
		echo "$(RED)Error: PROFILE variable required$(NC)"; \
		echo "Usage: make test-profile PROFILE=frontend"; \
		exit 1; \
	fi
	@echo "$(GREEN)Testing profile: $(PROFILE)$(NC)"
	@bash tests/test-profile.sh $(PROFILE)

test-themes: ## Test all themes
	@echo "$(GREEN)Testing all themes...$(NC)"
	@bash tests/test-themes.sh

test-icons: ## Test all icon sets
	@echo "$(GREEN)Testing all icon sets...$(NC)"
	@bash tests/test-icons.sh

test-components: ## Test all components
	@echo "$(GREEN)Testing all components...$(NC)"
	@bash tests/test-components.sh

benchmark: ## Run performance benchmarks
	@echo "$(GREEN)Running performance benchmarks...$(NC)"
	@bash tests/benchmark.sh

##@ Docker

docker-build: ## Build Docker image
	@echo "$(GREEN)Building Docker image...$(NC)"
	@docker compose build nvim-ultimate-test

docker-test: ## Run tests in Docker
	@echo "$(GREEN)Running tests in Docker...$(NC)"
	@docker compose up nvim-ultimate-test

docker-test-interactive: ## Start interactive Docker environment
	@echo "$(GREEN)Starting interactive Docker environment...$(NC)"
	@docker compose up -d nvim-interactive
	@docker compose exec nvim-interactive bash

docker-benchmark: ## Run benchmarks in Docker
	@echo "$(GREEN)Running benchmarks in Docker...$(NC)"
	@docker compose up nvim-benchmark

docker-clean: ## Clean Docker containers and images
	@echo "$(YELLOW)Cleaning Docker containers and images...$(NC)"
	@docker compose down
	@docker compose rm -f

##@ Quality

lint: ## Lint Lua files
	@echo "$(GREEN)Linting Lua files...$(NC)"
	@if command -v luacheck >/dev/null 2>&1; then \
		luacheck lua/ --no-unused-args --no-max-line-length; \
	else \
		echo "$(YELLOW)Warning: luacheck not installed$(NC)"; \
		echo "Install with: sudo luarocks install luacheck"; \
	fi

lint-shell: ## Lint shell scripts
	@echo "$(GREEN)Linting shell scripts...$(NC)"
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck install.sh update.sh uninstall.sh tests/*.sh; \
	else \
		echo "$(YELLOW)Warning: shellcheck not installed$(NC)"; \
		echo "Install with: brew install shellcheck (macOS) or apt install shellcheck (Linux)"; \
	fi

lint-docs: ## Check markdown documentation
	@echo "$(GREEN)Checking markdown documentation...$(NC)"
	@if command -v markdown-link-check >/dev/null 2>&1; then \
		for file in *.md; do \
			echo "Checking $$file"; \
			markdown-link-check "$$file" --config .github/markdown-link-check-config.json || true; \
		done; \
	else \
		echo "$(YELLOW)Warning: markdown-link-check not installed$(NC)"; \
		echo "Install with: npm install -g markdown-link-check"; \
	fi

check-deps: ## Check system dependencies
	@echo "$(GREEN)Checking system dependencies...$(NC)"
	@echo -n "Neovim: "; command -v nvim >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "Git: "; command -v git >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "Node.js: "; command -v node >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "ripgrep: "; command -v rg >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "fd: "; command -v fd >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "fzf: "; command -v fzf >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "lazygit: "; command -v lazygit >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"
	@echo -n "Docker: "; command -v docker >/dev/null 2>&1 && echo "$(GREEN)✓$(NC)" || echo "$(RED)✗$(NC)"

##@ Maintenance

clean: ## Clean temporary files and caches
	@echo "$(YELLOW)Cleaning temporary files...$(NC)"
	@find . -type f -name "*.log" -delete
	@find . -type f -name ".DS_Store" -delete
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "$(GREEN)Clean complete$(NC)"

backup: ## Backup current Neovim configuration
	@echo "$(GREEN)Creating backup...$(NC)"
	@if [ -d "$(NVIM_CONFIG_DIR)" ]; then \
		mkdir -p $(BACKUP_DIR); \
		cp -r $(NVIM_CONFIG_DIR) $(BACKUP_DIR)/; \
		echo "$(GREEN)Backup created: $(BACKUP_DIR)$(NC)"; \
	else \
		echo "$(YELLOW)No existing configuration to backup$(NC)"; \
	fi

restore: ## Restore from latest backup (requires BACKUP variable)
	@if [ -z "$(BACKUP)" ]; then \
		echo "$(RED)Error: BACKUP variable required$(NC)"; \
		echo "Usage: make restore BACKUP=/path/to/backup"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restoring from: $(BACKUP)$(NC)"
	@rm -rf $(NVIM_CONFIG_DIR)
	@cp -r $(BACKUP) $(NVIM_CONFIG_DIR)
	@echo "$(GREEN)Restore complete$(NC)"

##@ Documentation

docs: ## Open documentation in browser
	@echo "$(GREEN)Opening documentation...$(NC)"
	@if command -v open >/dev/null 2>&1; then \
		open README.md; \
	elif command -v xdg-open >/dev/null 2>&1; then \
		xdg-open README.md; \
	else \
		echo "$(YELLOW)Please open README.md manually$(NC)"; \
	fi

docs-serve: ## Serve documentation locally (requires Python)
	@echo "$(GREEN)Serving documentation at http://localhost:8000$(NC)"
	@if command -v python3 >/dev/null 2>&1; then \
		cd $(PROJECT_DIR) && python3 -m http.server 8000; \
	else \
		echo "$(RED)Error: Python 3 required$(NC)"; \
	fi

##@ Release

release-check: ## Check if ready for release
	@echo "$(GREEN)Checking release readiness...$(NC)"
	@echo -n "Git clean: "; \
		if [ -z "$$(git status --porcelain)" ]; then \
			echo "$(GREEN)✓$(NC)"; \
		else \
			echo "$(RED)✗ (uncommitted changes)$(NC)"; \
		fi
	@echo -n "Tests passing: "; \
		if bash tests/run-all-tests.sh >/dev/null 2>&1; then \
			echo "$(GREEN)✓$(NC)"; \
		else \
			echo "$(YELLOW)! (run 'make test' to check)$(NC)"; \
		fi
	@echo -n "Documentation: "; \
		if [ -f README.md ] && [ -f CHANGELOG.md ]; then \
			echo "$(GREEN)✓$(NC)"; \
		else \
			echo "$(RED)✗$(NC)"; \
		fi

.PHONY: all
all: check-deps lint test ## Run all checks and tests
	@echo "$(GREEN)All checks complete!$(NC)"
