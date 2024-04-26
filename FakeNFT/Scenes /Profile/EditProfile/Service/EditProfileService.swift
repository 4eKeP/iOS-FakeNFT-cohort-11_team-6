//
//  EditProfileService.swift
//  FakeNFT
//
//  Created by Dinara on 11.04.2024.
//

import Foundation

// MARK: - EditProfileService
final class EditProfileService {
    private weak var view: EditProfileViewControllerProtocol?
    static let shared = EditProfileService()
    private var urlSession = URLSession.shared
    private var urlSessionTask: URLSessionTask?
    private let profileService = UserProfileService.shared

    private init() {}

    func setView(_ view: EditProfileViewControllerProtocol) {
        self.view = view
    }

    func updateProfile(with model: EditProfileModel, completion: @escaping (Result<UserProfile, Error>) -> Void) {

        guard let request = makePutRequest(with: model) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        urlSessionTask = urlSession.objectTask(for: request) { (response: Result<UserProfile, Error>) in
            switch response {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension EditProfileService {
    func makePutRequest(with profile: EditProfileModel) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host  = "d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net"
        urlComponents.path = "/api/v1/profile/1"

        guard let url = urlComponents.url else {
            fatalError("Failed to create URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("6209b976-c7aa-4061-8574-573765a55e71", forHTTPHeaderField: "X-Practicum-Mobile-Token")

        var profileData: String = ""
        for like in profile.likes ?? [] {
            profileData += "&likes=\(like)"
        }

        if let name = profile.name {
            profileData += "&name=\(name)"
        }

        if let avatar = profile.avatar {
            profileData += "&avatar=\(avatar)"
        }

        if let description = profile.description {
            profileData += "&description=\(description)"
        }

        if let website = profile.website {
            profileData += "&website=\(website)"
        }

        request.httpBody = profileData.data(using: .utf8)

        return request

    }
}
