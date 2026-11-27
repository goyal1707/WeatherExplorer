//
//  APIError.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Network layer ke saare errors ek jagah. ViewModel isse user-friendly message banayega.
enum APIError: LocalizedError {
    case invalidURL
    case badStatus(Int)        // 404, 500 etc.
    case decoding(Error)       // JSON expected shape se match nahi hua
    case network(Error)        // internet nahi hai, timeout etc.
    case invalidData

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL."
        case .badStatus(let code): return "Server error (\(code)). Please try again."
        case .decoding: return "Could not read the server response."
        case .network: return "Network problem. Check your internet connection."
        case .invalidData: return "Unexpected data from the server."
        }
    }
}
