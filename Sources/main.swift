import Foundation

// Create and run the game
Task {
    let game = Game()
    await game.start()
    exit(0)
}

// Keep the program running
RunLoop.main.run() 