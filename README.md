# Mastermind Game

A command-line implementation of the classic Mastermind code-breaking game in Swift.

## Game Rules

- The game generates a secret 4-digit code
- Each digit can be a number between 1 and 6
- After each guess, the system responds with:
  - **B (Black)**: Number of digits correct in both value and position
  - **W (White)**: Number of digits correct in value but in wrong position

## Example

If the secret code is `1234`:
- Guess `1235` → Response: `BBB` (three correct digits in the right place)
- Guess `4321` → Response: `WWWW` (four correct digits in the wrong place)

## Requirements

- Swift 5.0 or later
- macOS 12.0 or later
- Internet connection (uses remote API)

## Quick Start

The easiest way to run the game is using the demo script:

```bash
./demo.sh
```

## Building

```bash
swift build
```

## Running

```bash
swift run
```

## In-Game Commands

- Enter a 4-digit guess (digits 1-6)
- Type `help` for game instructions
- Type `example` to see example guesses
- Type `exit` to quit the game at any time

## Project Structure

```
Mastermind/
├── Sources/
│   ├── main.swift          # Entry point
│   ├── Game.swift          # Main game logic
│   ├── APIClient.swift     # API communication
│   ├── Models.swift        # Data models
│   ├── InputHandler.swift  # Console I/O utilities
│   └── NetworkReachability.swift  # Network error handling
├── Package.swift           # Swift package configuration
├── README.md              # This file
└── demo.sh               # Demo script
```

## Features

- Clean, colorful terminal UI with emoji support
- Network error handling with automatic retry
- Input validation and helpful error messages
- Game statistics tracking
- Play again functionality

## API

This game uses the Mastermind API at https://mastermind.darkube.app/docs/index.html 