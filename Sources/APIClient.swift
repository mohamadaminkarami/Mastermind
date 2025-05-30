import Foundation

class APIClient {
    private let baseURL = "https://mastermind.darkube.app"
    private let session = URLSession.shared
    
    // Create a new game
    func createGame() async throws -> String {
        let url = URL(string: "\(baseURL)/game")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GameError.networkError("Invalid response")
        }
        
        if httpResponse.statusCode == 200 {
            let gameResponse = try JSONDecoder().decode(CreateGameResponse.self, from: data)
            return gameResponse.gameId
        } else if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            throw GameError.apiError(errorResponse.error)
        } else {
            throw GameError.apiError("Failed to create game")
        }
    }
    
    // Submit a guess
    func submitGuess(gameId: String, guess: String) async throws -> GuessResponse {
        let url = URL(string: "\(baseURL)/guess")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let guessRequest = GuessRequest(gameId: gameId, guess: guess)
        request.httpBody = try JSONEncoder().encode(guessRequest)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GameError.networkError("Invalid response")
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode(GuessResponse.self, from: data)
        } else if httpResponse.statusCode == 400 {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw GameError.apiError(errorResponse.error)
            }
            throw GameError.invalidInput
        } else if httpResponse.statusCode == 404 {
            throw GameError.apiError("Game not found")
        } else {
            throw GameError.apiError("Failed to submit guess")
        }
    }
    
    // Delete a game
    func deleteGame(gameId: String) async throws {
        let url = URL(string: "\(baseURL)/game/\(gameId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GameError.networkError("Invalid response")
        }
        
        if httpResponse.statusCode != 204 && httpResponse.statusCode != 200 {
            throw GameError.apiError("Failed to delete game")
        }
    }
} 