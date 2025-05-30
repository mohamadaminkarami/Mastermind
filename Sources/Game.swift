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
        print("Welcome to Mastermind!")
        print("======================")
        print("Game Rules:")
        print("- Guess a 4-digit code (digits 1-6)")
        print("- B = Correct digit in correct position")
        print("- W = Correct digit in wrong position")
        print("- Type 'exit' to quit\n")
        
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
            print("Guess #\(guessCount + 1): ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespaces) else {
                continue
            }
            
            // Check for exit command
            if input.lowercased() == "exit" {
                await endGame()
                break
            }
            
            // Validate input
            guard isValidGuess(input) else {
                print("Invalid input! Please enter exactly 4 digits (1-6).\n")
                continue
            }
            
            do {
                // Submit guess
                let response = try await apiClient.submitGuess(gameId: gameId, guess: input)
                guessCount += 1
                
                // Format and display response
                let formattedResponse = formatResponse(response)
                print("Response: \(formattedResponse)")
                
                // Check if the game is won
                if response.black == 4 {
                    print("\nCongratulations! You won in \(guessCount) guesses! 🎉")
                    await playAgain()
                    break
                }
                
                print() // Empty line for better readability
                
            } catch {
                print("Error: \(error.localizedDescription)\n")
            }
        }
    }
    
    // End the current game
    private func endGame() async {
        guard let gameId = gameId else { return }
        
        do {
            try await apiClient.deleteGame(gameId: gameId)
            print("\nGame ended. Thanks for playing!")
        } catch {
            print("\nError ending game: \(error.localizedDescription)")
        }
    }
    
    // Ask if the player wants to play again
    private func playAgain() async {
        print("\nWould you like to play again? (yes/no): ", terminator: "")
        
        guard let input = readLine()?.lowercased().trimmingCharacters(in: .whitespaces) else {
            await endGame()
            return
        }
        
        if input == "yes" || input == "y" {
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
} 