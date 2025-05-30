import Foundation

Task {
    let game = Game()
    await game.start()
    exit(0)
}

RunLoop.main.run() 