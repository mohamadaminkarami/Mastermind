import Foundation

class APIClient {
    private let baseURL = "https://mastermind.darkube.app"
    private let session = URLSession.shared
    
    func createGame() async throws -> String {
        let url = URL(string: "\(baseURL)/game")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GameError.networkError("Invalid response")
        }
        
        switch httpResponse.statusCode {
        case 200:
            let gameResponse = try JSONDecoder().decode(CreateGameResponse.self, from: data)
            return gameResponse.gameId
        case 500:
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw GameError.apiError(errorResponse.error)
            }
            throw GameError.serverError
        default:
            throw GameError.unknownError
        }
    }
    
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
        
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(GuessResponse.self, from: data)
        case 400:
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw GameError.apiError(errorResponse.error)
            }
            throw GameError.invalidInput
        case 404:
            throw GameError.gameNotFound
        default:
            throw GameError.unknownError
        }
    }
    
    func deleteGame(gameId: String) async throws {
        let url = URL(string: "\(baseURL)/game/\(gameId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GameError.networkError("Invalid response")
        }
        
        switch httpResponse.statusCode {
        case 204, 200, 404:  // 404 means game is already deleted, which is fine
            return
        case 500:
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw GameError.apiError(errorResponse.error)
            }
            throw GameError.serverError
        default:
            throw GameError.unknownError
        }
    }
} 