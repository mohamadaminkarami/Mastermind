import Foundation


struct CreateGameResponse: Codable {
    let gameId: String
    
    enum CodingKeys: String, CodingKey {
        case gameId = "game_id"
    }
}

struct GuessRequest: Codable {
    let gameId: String
    let guess: String
    
    enum CodingKeys: String, CodingKey {
        case gameId = "game_id"
        case guess
    }
}

struct GuessResponse: Codable {
    let black: Int
    let white: Int
}

struct ErrorResponse: Codable {
    let error: String
}


enum GameError: Error, LocalizedError {
    case invalidInput
    case networkError(String)
    case apiError(String)
    case gameNotFound
    case serverError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "Invalid input. Please enter a 4-digit code with digits 1-6."
        case .networkError(let message):
            return "Network error: \(message)"
        case .apiError(let message):
            return message
        case .gameNotFound:
            return "Game not found. Please start a new game."
        case .serverError:
            return "Server error. Please try again later."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        }
    }
} 