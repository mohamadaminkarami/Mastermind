# Mastermind Game Makefile

# Variables
SWIFT = swift
BUILD_DIR = .build
GAME_NAME = Mastermind

# Colors for terminal output
GREEN = \033[0;32m
RED = \033[0;31m
YELLOW = \033[0;33m
NC = \033[0m # No Color

# Default target
.PHONY: all
all: build

# Build the game
.PHONY: build
build:
	@echo "${YELLOW}🎮 Building Mastermind Game...${NC}"
	@$(SWIFT) build
	@if [ $$? -eq 0 ]; then \
		echo "${GREEN}✅ Build successful!${NC}"; \
	else \
		echo "${RED}❌ Build failed. Please check the error messages above.${NC}"; \
		exit 1; \
	fi

# Run the game
.PHONY: run
run: build
	@echo "${YELLOW}🎮 Starting Mastermind Game...${NC}"
	@echo "Remember:"
	@echo "- Enter 4-digit codes using digits 1-6"
	@echo "- Type 'help' for instructions"
	@echo "- Type 'example' to see examples"
	@echo "- Type 'exit' to quit"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@$(SWIFT) run

# Clean build artifacts
.PHONY: clean
clean:
	@echo "${YELLOW}🧹 Cleaning build artifacts...${NC}"
	@rm -rf $(BUILD_DIR)
	@echo "${GREEN}✅ Clean complete!${NC}"

# Show help
.PHONY: help
help:
	@echo "${YELLOW}Mastermind Game Makefile Help${NC}"
	@echo ""
	@echo "Available targets:"
	@echo "  ${GREEN}make${NC}        - Build the game (default)"
	@echo "  ${GREEN}make build${NC}  - Build the game"
	@echo "  ${GREEN}make run${NC}    - Build and run the game"
	@echo "  ${GREEN}make clean${NC}  - Remove build artifacts"
	@echo "  ${GREEN}make test${NC}   - Run tests"
	@echo "  ${GREEN}make help${NC}   - Show this help message" 