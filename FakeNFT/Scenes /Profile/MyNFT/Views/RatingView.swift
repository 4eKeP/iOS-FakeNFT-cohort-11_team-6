//
//  RatingView.swift
//  FakeNFT
//
//  Created by Dinara on 30.03.2024.
//

import SnapKit
import UIKit

// MARK: - RatingView
final class RatingView: UIStackView {

    private lazy var starImageViewArray: [UIImageView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStarViewStackUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRating(_ rating: Int) {
        for (index, imageView) in starImageViewArray.enumerated() {
            if index < rating {
                imageView.tintColor = UIColor(named: "ypUniYellow")
            } else {
                imageView.tintColor = .segmentInactive
            }
        }
    }
}

private extension RatingView {
    // MARK: - Setup StarView UI
    func setupStarViewUI() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    // MARK: - Setup StarView Stack UI
    func setupStarViewStackUI() {
        for _ in 1...5 {
            let starView = setupStarViewUI()
            starImageViewArray.append(starView)
            addArrangedSubview(starView)
        }

        axis = .horizontal
        spacing = 2
        distribution = .fillEqually
    }
}
