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
- macOS or Linux
- Internet connection (uses remote API)

## Building

```bash
swift build
```

## Running

```bash
swift run
```

## Commands

- Enter a 4-digit guess (digits 1-6)
- Type `exit` to quit the game at any time

## API

This game uses the Mastermind API at https://mastermind.darkube.app/docs/index.html 