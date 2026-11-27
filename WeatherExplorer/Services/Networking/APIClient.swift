//
//  APIClient.swift
//  WeatherExplorer
//
//  Created by Saurabh Goyal on 27/11/26.
//

import Foundation

/// Protocol = contract. Real app mein URLSession wala client chalega,
/// tests mein fake client (mock) inject karenge. Isse network ke bina test ho sakta hai.
protocol APIClientProtocol {
    func get<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

struct APIClient: APIClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch let error as URLError where error.code == .cancelled {
            // Search-as-you-type mein purani request cancel hoti hai. Ye error nahi, normal baat hai.
            throw CancellationError()
        } catch {
            throw APIError.network(error)
        }

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus((response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}
