//
//  FavoriteNFTService.swift
//  FakeNFT
//
//  Created by Dinara on 09.04.2024.
//

import Foundation

final class FavoriteNFTService {
    static let shared = FavoriteNFTService()
    private(set) var NFTs: [NFT]?
    private var urlSession = URLSession.shared
    private var id: String?
    private var urlSessionTask: URLSessionTask?

    private init(
        NFTs: [NFT]? = nil,
        id: String? = nil,
        urlSessionTask: URLSessionTask? = nil
    ) {
        self.NFTs = NFTs
        self.id = id
        self.urlSessionTask = urlSessionTask
    }

    func fetchNFTs(_ id: String, completion: @escaping (Result<NFT, Error>) -> Void) {
        guard let request = makeFetchNFTRequest(id: id) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        urlSessionTask = urlSession.objectTask(for: request) { [weak self] (response: Result<NFT, Error>) in
            switch response {
            case .success(let likes):
                self?.NFTs?.append(likes)
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension FavoriteNFTService {
    func makeFetchNFTRequest(id: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
//        urlComponents.host  = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
        urlComponents.host  = "64858e8ba795d24810b71189.mockapi.io"
        urlComponents.path = "/api/v1/nft/\(id)"

        guard let url = urlComponents.url else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("6209b976-c7aa-4061-8574-573765a55e71", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        return request
    }
}
