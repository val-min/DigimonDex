//
//  NetworkManager.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

// MARK: - Errors
enum NetworkError: LocalizedError {
    case noInternet
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(underlying: Error)
    case unknown(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .noInternet:
            return "No internet connection. Please check your network and try again."
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse(let code):
            return "Server returned an error (code \(code))."
        case .decodingFailed:
            return "Failed to parse server response."
        case .unknown(let err):
            return err.localizedDescription
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .noInternet, .unknown: return true
        default: return false
        }
    }
}

// MARK: - Protocol
protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

// MARK: - Implementation
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = false
        session = URLSession(configuration: config)
        
        decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse(statusCode: -1)
            }
            guard (200..<300).contains(http.statusCode) else {
                throw NetworkError.invalidResponse(statusCode: http.statusCode)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                // Print the raw JSON and exact decode error to console
                if let json = String(data: data, encoding: .utf8),
                   let pretty = try? JSONSerialization.jsonObject(with: data),
                   let prettyData = try? JSONSerialization.data(withJSONObject: pretty, options: .prettyPrinted),
                   let prettyString = String(data: prettyData, encoding: .utf8) {
                    print("🟡 RAW JSON:\n\(prettyString)")
                }
                print("🔴 DECODE ERROR: \(error)")
                throw NetworkError.decodingFailed(underlying: error)
            }
            
        } catch let error as NetworkError {
            throw error
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut:
                throw NetworkError.noInternet
            default:
                throw NetworkError.unknown(underlying: urlError)
            }
        } catch {
            throw NetworkError.unknown(underlying: error)
        }
    }
}
