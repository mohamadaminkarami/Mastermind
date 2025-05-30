import Foundation

class InputHandler {
    
    static func displayBanner() {
        let banner = """
        
        ╔═════════════════════════════════════╗
        ║           MASTERMIND GAME           ║
        ║                                     ║
        ║  Crack the secret 4-digit code!     ║
        ║  Each digit is between 1 and 6.     ║
        ║                                     ║
        ║  B = Correct digit & position       ║
        ║  W = Correct digit, wrong position  ║
        ╚═════════════════════════════════════╝
        
        """
        print(banner)
    }
    
    static func readInput(prompt: String) -> String? {
        print(prompt, terminator: "")
        fflush(stdout)
        return readLine()
    }
    
    static func displayStats(guessCount: Int) {
        print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print("  Game Statistics:")
        print("  Total Guesses: \(guessCount)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
} 