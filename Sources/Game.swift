import Foundation

class Game {
    private let apiClient = APIClient()
    private var gameId: String?
    private var guessCount = 0
    
    // Validate user input
    private func isValidGuess(_ guess: String) -> Bool {
        // Check if it's exactly 4 digits
        guard guess.count == 4 else { return false }
        
        // Check if all characters are digits between 1 and 6
        for char in guess {
            guard let digit = char.wholeNumberValue, (1...6).contains(digit) else {
                return false
            }
        }
        
        return true
    }
    
    // Format the response
    private func formatResponse(_ response: GuessResponse) -> String {
        var result = ""
        
        // Add B's for black (correct position)
        for _ in 0..<response.black {
            result += "B"
        }
        
        // Add W's for white (wrong position)
        for _ in 0..<response.white {
            result += "W"
        }
        
        // If no matches, return a dash
        if result.isEmpty {
            result = "-"
        }
        
        return result
    }
    
    // Start a new game
    func start() async {
        InputHandler.displayBanner()
        print("Type 'exit' at any time to quit.")
        print("Type 'help' for game instructions.\n")
        
        do {
            // Create a new game
            print("Starting new game...")
            gameId = try await apiClient.createGame()
            guessCount = 0
            print("Game started! Make your first guess.\n")
            
            // Start the game loop
            await gameLoop()
            
        } catch {
            print("Error starting game: \(error.localizedDescription)")
        }
    }
    
    // Main game loop
    private func gameLoop() async {
        guard let gameId = gameId else { return }
        
        while true {
            // Use InputHandler for better input handling
            guard let input = InputHandler.readInput(prompt: "Guess #\(guessCount + 1): ") else {
                print("\nError reading input. Please try again.")
                continue
            }
            
            let trimmedInput = input.trimmingCharacters(in: .whitespaces)
            
            // Check for exit command
            if trimmedInput.lowercased() == "exit" {
                await endGame()
                break
            }
            
            // Check for help command
            if trimmedInput.lowercased() == "help" {
                displayHelp()
                continue
            }
            
            // Check for example command
            if trimmedInput.lowercased() == "example" {
                displayExample()
                continue
            }
            
            // Validate input
            guard isValidGuess(trimmedInput) else {
                print("❌ Invalid input! Please enter exactly 4 digits (1-6).\n")
                continue
            }
            
            do {
                // Submit guess
                let response = try await apiClient.submitGuess(gameId: gameId, guess: trimmedInput)
                guessCount += 1
                
                // Format and display response
                let formattedResponse = formatResponse(response)
                print("Response: \(formattedResponse)")
                
                // Check if the game is won
                if response.black == 4 {
                    print("\n🎉 Congratulations! You won in \(guessCount) guesses! 🎉")
                    InputHandler.displayStats(guessCount: guessCount)
                    await playAgain()
                    break
                }
                
                print() // Empty line for better readability
                
            } catch {
                print("❌ Error: \(error.localizedDescription)\n")
            }
        }
    }
    
    // End the current game
    private func endGame() async {
        guard let gameId = gameId else { return }
        
        do {
            try await apiClient.deleteGame(gameId: gameId)
            print("\n👋 Game ended. Thanks for playing!")
        } catch {
            print("\n❌ Error ending game: \(error.localizedDescription)")
        }
    }
    
    // Ask if the player wants to play again
    private func playAgain() async {
        guard let input = InputHandler.readInput(prompt: "\nWould you like to play again? (yes/no): ") else {
            await endGame()
            return
        }
        
        let trimmedInput = input.lowercased().trimmingCharacters(in: .whitespaces)
        
        if trimmedInput == "yes" || trimmedInput == "y" {
            // End current game first
            if let gameId = gameId {
                try? await apiClient.deleteGame(gameId: gameId)
            }
            // Start a new game
            await start()
        } else {
            await endGame()
        }
    }
    
    // Display help information
    private func displayHelp() {
        print("\n📖 HELP:")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("• Enter a 4-digit code using digits 1-6")
        print("• B = Correct digit in correct position")
        print("• W = Correct digit in wrong position")
        print("• Type 'example' to see example guesses")
        print("• Type 'exit' to quit the game")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    }
    
    // Display example guesses
    private func displayExample() {
        print("\n💡 EXAMPLE:")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("If the secret code is: 1234")
        print("")
        print("Guess: 1235 → Response: BBB")
        print("(Three correct digits in right place)")
        print("")
        print("Guess: 4321 → Response: WWWW")
        print("(Four correct digits in wrong place)")
        print("")
        print("Guess: 5612 → Response: WW")
        print("(Two correct digits in wrong place)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
    }
} 