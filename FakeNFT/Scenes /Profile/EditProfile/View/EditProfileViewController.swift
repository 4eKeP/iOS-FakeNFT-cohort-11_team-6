//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import Kingfisher
import SnapKit
import ProgressHUD
import UIKit

protocol EditProfileViewControllerProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayError(_ error: Error)
    func profileUpdateSuccessful()
    func setProfile(profile: UserProfile)
    func updateAvatar(url: URL, options: Kingfisher.KingfisherOptionsInfo?)
}

// MARK: - EditProfileViewController Class
final class EditProfileViewController: UIViewController {
    var presenter: EditProfilePresenter?
    weak var editProfilePresenterDelegate: EditProfilePresenterDelegate?
    private var newAvatarURL: String?

    init(
        presenter: EditProfilePresenter?
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "ypUniBlack")
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var changeImageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor(named: "ypUniWhite")
        label.text = L10n.Profile.changeImage
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        let action = UITapGestureRecognizer(
            target: self,
            action: #selector(changeImageDidTap(_:))
        )
        label.addGestureRecognizer(action)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var loadAvatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor(named: "ypUniBlack")
        label.text = L10n.Profile.loadAvatar
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private lazy var avatarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.name
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor(named: "ypUniBlack")
        textField.backgroundColor = UIColor(named: "ypLightGray")
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 16,
                height: textField.frame.height
            )
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.description
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.textColor = UIColor(named: "ypUniBlack")
        textView.backgroundColor = UIColor(named: "ypLightGray")
        textView.layer.cornerRadius = 12
        textView.layer.masksToBounds = true
        textView.textContainerInset = UIEdgeInsets(
            top: 11,
            left: 16,
            bottom: 11,
            right: 16
        )
        textView.delegate = self
        return textView
    }()

    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var siteLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Profile.site
        label.textColor = UIColor(named: "ypUniBlack")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private lazy var siteTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = UIColor(named: "ypUniBlack")
        textField.backgroundColor = UIColor(named: "ypLightGray")
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        let leftView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 16,
                height: textField.frame.height
            )
        )
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var siteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var generalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter?.viewDidLoad()
    }
}

private extension EditProfileViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground

        [nameLabel,
         nameTextField
        ].forEach {
            nameStackView.addArrangedSubview($0)
        }

        [descriptionLabel,
         descriptionTextView
        ].forEach {
            descriptionStackView.addArrangedSubview($0)
        }

        [siteLabel,
         siteTextField
        ].forEach {
            siteStackView.addArrangedSubview($0)
        }

        [nameStackView,
         descriptionStackView,
         siteStackView
        ].forEach {
            generalStackView.addArrangedSubview($0)
        }

        [closeButton,
         avatarImageView,
         changeImageLabel,
         loadAvatarLabel,
         generalStackView
        ].forEach {
            view.addSubview($0)
        }

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        )
        view.addGestureRecognizer(tapGesture)
    }

    func setupConstraints() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.trailing.equalToSuperview().offset(-23)
            make.size.equalTo(19)
        }

        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }

        changeImageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(avatarImageView.snp.centerY)
            make.centerX.equalTo(avatarImageView.snp.centerX)
        }

        loadAvatarLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(15)
            make.centerX.equalTo(avatarImageView.snp.centerX)
            make.bottom.equalTo(generalStackView.snp.top).offset(-11)
        }

        nameTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(46)
        }

        siteTextField.snp.makeConstraints { make in
            make.width.equalTo(343)
            make.height.equalTo(46)
        }

        generalStackView.snp.makeConstraints { make in
            make.top.equalTo(loadAvatarLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-196)
        }
    }

    // MARK: - Actions
    @objc func closeButtonDidTap() {
        let name = nameTextField.text
        let description = descriptionTextView.text
        let website = siteTextField.text
        presenter?.updateProfile(
            name: name,
            description: description,
            website: website,
            newAvatarURL: newAvatarURL
        )

        self.dismiss(animated: true, completion: nil)
    }

    @objc func changeImageDidTap(_ sender: UITapGestureRecognizer) {
        loadAvatarLabel.isHidden = false

        let alert = UIAlertController(
            title: L10n.Profile.loadImage,
            message: L10n.Profile.linkToImage,
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = L10n.Profile.placeLink
        }

        alert.addAction(
            UIAlertAction(
                title: "ОK",
                style: .default) { [weak self] _ in
                    guard
                    let self = self,
                    let textField = alert.textFields?[0],
                    let URL = textField.text
                else { return }

                if validateURLFormat(urlString: URL) {
                    self.loadAvatarLabel.text = URL
                    self.newAvatarURL = URL
                } else {
                    let wrongURL = UIAlertController(
                        title: L10n.Profile.invalidLink,
                        message: L10n.Profile.checkLink,
                        preferredStyle: .alert)
                    wrongURL.addAction(
                        UIAlertAction(
                            title: "ОK",
                            style: .cancel
                        ) { _ in
                            wrongURL.dismiss(animated: true)
                        }
                    )
                    self.present(wrongURL, animated: true)
                }
                alert.dismiss(animated: true)
            }
        )
        self.present(alert, animated: true)
    }

    private func validateURLFormat(urlString: String?) -> Bool {
        guard
            let urlString = urlString,
            let url = NSURL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url as URL)
    }

    @objc func handleTapGesture() {
        nameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        siteTextField.resignFirstResponder()
    }
}

extension EditProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController: EditProfileViewControllerProtocol {
    func setProfile(profile: UserProfile) {
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        siteTextField.text = profile.website
        if let avatarURLString = profile.avatar {
            let avatarURL = URL(string: avatarURLString)
            if let url = avatarURL {
                updateAvatar(url: url, options: nil)
            } else {
                print("Avatar is nil")
            }
        }
    }

    func updateAvatar(url: URL, options: Kingfisher.KingfisherOptionsInfo?) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            options: options)
    }

    func showLoading() {
        ProgressHUD.show()
    }

    func hideLoading() {
        ProgressHUD.dismiss()
    }

    func displayError(_ error: Error) {
        ProgressHUD.showError("\(error.localizedDescription)")
    }

    func profileUpdateSuccessful() {
        ProgressHUD.showSucceed("Профиль успешно обновлен", delay: 2.0)
    }
}
