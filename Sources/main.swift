// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Main entry point
@main
struct MastermindApp {
    static func main() async {
        let game = Game()
        await game.start()
    }
}
