import Foundation

class NetworkReachability {
    
    static func retryWithBackoff<T>(
        maxAttempts: Int = 3,
        initialDelay: TimeInterval = 1.0,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 0..<maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                
                // Only retry on network errors
                if let gameError = error as? GameError, isNetworkError(gameError) {
                    // Don't retry on the last attempt
                    if attempt < maxAttempts - 1 {
                        let delay = initialDelay * pow(2.0, Double(attempt))
                        print("⏳ Network error. Retrying in \(Int(delay)) seconds... (Attempt \(attempt + 2)/\(maxAttempts))")
                        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                        continue
                    }
                }
                // For non-network errors, throw immediately
                throw error
            }
        }
        throw lastError ?? GameError.unknownError
    }
    
    static func isNetworkError(_ error: Error) -> Bool {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                return true
            default:
                return false
            }
        }
        if let gameError = error as? GameError {
            if case .networkError = gameError {
                return true
            }
        }
        return false
    }
} 