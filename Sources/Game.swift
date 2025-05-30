import Foundation

class Game {
    private let apiClient = APIClient()
    private var gameId: String?
    private var guessCount = 0
    
    private func isValidGuess(_ guess: String) -> Bool {
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
    
    func start() async {
        InputHandler.displayBanner()
        print("Type 'exit' at any time to quit.")
        print("Type 'help' for game instructions.\n")
        
        do {
            print("Starting new game...")
            gameId = try await NetworkReachability.retryWithBackoff {
                try await self.apiClient.createGame()
            }
            guessCount = 0
            print("Game started! Make your first guess.\n")
            
            await gameLoop()
            
        } catch let error as GameError {
            await handleGameError(error)
        } catch {
            print("❌ Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func handleGameError(_ error: GameError) async {
        switch error {
        case .networkError:
            print("❌ \(error.localizedDescription)")
            print("Please check your internet connection and try again.")
        case .serverError:
            print("❌ Server error: \(error.localizedDescription)")
            print("The game server is having issues. Please try again later.")
        case .gameNotFound:
            print("❌ \(error.localizedDescription)")
            print("Starting a new game...")
            await start()
        case .invalidInput:
            print("❌ \(error.localizedDescription)")
        case .apiError(let message):
            print("❌ \(message)")
        case .unknownError:
            print("❌ \(error.localizedDescription)")
        }
    }
    
    private func gameLoop() async {
        guard let gameId = gameId else { return }
        
        while true {
            // Use InputHandler for better input handling
            guard let input = InputHandler.readInput(prompt: "Guess #\(guessCount + 1): ") else {
                print("\nError reading input. Please try again.")
                continue
            }
            
            let trimmedInput = input.trimmingCharacters(in: .whitespaces)
            
            if trimmedInput.lowercased() == "exit" {
                await endGame()
                break
            }
            
            if trimmedInput.lowercased() == "help" {
                displayHelp()
                continue
            }
            
            if trimmedInput.lowercased() == "example" {
                displayExample()
                continue
            }
            
            guard isValidGuess(trimmedInput) else {
                print("❌ Invalid input! Please enter exactly 4 digits (1-6).\n")
                continue
            }
            
            do {
                let response = try await NetworkReachability.retryWithBackoff {
                    try await self.apiClient.submitGuess(gameId: gameId, guess: trimmedInput)
                }
                guessCount += 1
                
                let formattedResponse = formatResponse(response)
                print("Response: \(formattedResponse)")
                
                if response.black == 4 {
                    print("\n🎉 Congratulations! You won in \(guessCount) guesses! 🎉")
                    InputHandler.displayStats(guessCount: guessCount)
                    await playAgain()
                    break
                }
                
                print()
                
            } catch let error as GameError {
                await handleGameError(error)
                if case .gameNotFound = error {
                    break
                }
            } catch {
                print("❌ Unexpected error: \(error.localizedDescription)")
            }
        }
    }
    
    private func endGame() async {
        guard let gameId = gameId else { return }
        
        do {
            try await apiClient.deleteGame(gameId: gameId)
            print("\n👋 Game ended. Thanks for playing!")
        } catch let error as GameError {
            await handleGameError(error)
        } catch {
            print("\n❌ Unexpected error: \(error.localizedDescription)")
        }
    }
    
    private func playAgain() async {
        guard let input = InputHandler.readInput(prompt: "\nWould you like to play again? (yes/no): ") else {
            await endGame()
            return
        }
        
        let trimmedInput = input.lowercased().trimmingCharacters(in: .whitespaces)
        
        if trimmedInput == "yes" || trimmedInput == "y" {
            if let gameId = gameId {
                try? await apiClient.deleteGame(gameId: gameId)
            }
            
            await start()
        } else {
            await endGame()
        }
    }
    
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