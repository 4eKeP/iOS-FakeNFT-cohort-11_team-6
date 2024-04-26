//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Dinara on 23.03.2024.
//

import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func navigateToMyNFTScreen(with nftID: [String], and likedNFT: [String])
    func navigateToFavoriteNFTScreen(with nftID: [String], and likedNFT: [String])
    func navigateToEditProfileScreen(profile: UserProfile)
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewWillAppear()
    func didTapMyNFT()
    func didTapFavoriteNFT()
    func didTapEditProfile()
    func updateUserProfile(with profile: UserProfile)
}

// MARK: - ProfilePresenter Class
final class ProfilePresenter {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = UserProfileService.shared
    private let tokenKey = "6209b976-c7aa-4061-8574-573765a55e71"
    weak var delegate: ProfilePresenterDelegate?
    private var profile: UserProfile?
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func updateUserProfile(with profile: UserProfile) {
        DispatchQueue.main.async { [weak self] in
            self?.profile = profile
            self?.view?.updateProfileDetails(profile)
        }
    }

    func didTapEditProfile() {
        if let profile = profile {
            delegate?.navigateToEditProfileScreen(profile: profile)
        }
    }

    func didTapFavoriteNFT() {
        let nftID = profile?.nfts ?? []
        let likedNFT = profile?.likes ?? []
        delegate?.navigateToFavoriteNFTScreen(with: nftID, and: likedNFT)
    }

    func didTapMyNFT() {
        let nftID = profile?.nfts ?? []
        let likedNFT = profile?.likes ?? []
        delegate?.navigateToMyNFTScreen(with: nftID, and: likedNFT)
    }

    func viewWillAppear() {
            profileService.fetchProfile { [weak self] result in
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    self?.view?.updateProfileDetails(profile)
                case .failure(let error):
                    print("Failed to fetch profile: \(error)")
                }
            }

            return
    }
}

extension ProfilePresenter: EditProfilePresenterDelegate {
    func profileDidUpdate(_ profile: UserProfile, newAvatarURL: String?) {
        self.profile = profile
        view?.updateProfileDetails(profile)
    }
}
