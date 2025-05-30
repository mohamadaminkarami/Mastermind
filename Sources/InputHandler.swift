import Foundation

// Utility class for handling console input/output
class InputHandler {
    
    // Display a banner
    static func displayBanner() {
        let banner = """
        
        ╔══════════════════════════════════════╗
        ║         MASTERMIND GAME              ║
        ║                                      ║
        ║  Crack the secret 4-digit code!     ║
        ║  Each digit is between 1 and 6.     ║
        ║                                      ║
        ║  B = Correct digit & position       ║
        ║  W = Correct digit, wrong position  ║
        ╚══════════════════════════════════════╝
        
        """
        print(banner)
    }
    
    // Read user input with a prompt
    static func readInput(prompt: String) -> String? {
        print(prompt, terminator: "")
        fflush(stdout) // Ensure the prompt is displayed immediately
        return readLine()
    }
    
    // Display game statistics
    static func displayStats(guessCount: Int) {
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("  Game Statistics:")
        print("  Total Guesses: \(guessCount)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
} 