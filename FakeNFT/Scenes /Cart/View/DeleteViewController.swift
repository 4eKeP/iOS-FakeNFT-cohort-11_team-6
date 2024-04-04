//
//  DeleteViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

protocol NftDeleteDelegate: AnyObject {
    func deleteNFT(at index: IndexPath)
}

class DeleteViewController: UIViewController {
    
    weak var delegate: NftDeleteDelegate?
    
    var index: IndexPath? = nil
    var image: UIImage?
    
    lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        let image = image
        imageView.image = image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
       let label = UILabel()
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.widthAnchor.constraint(equalToConstant: 180).isActive = true
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var removeNftButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor(named: "ypUniRed"), for: .normal)
        button.setTitle("Удалить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 127).isActive = true
        button.addTarget(self, action: #selector(removeNftButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backNftButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.textColor = .red
        button.setTitle("Вернуться", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 127).isActive = true
        button.addTarget(self, action: #selector(backNftButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBlurEffect()
    }
    
    // метод удаления блюра
    private func removeBlurEffect() {
        guard let window = UIApplication.shared.windows.first else { return }
        for subview in window.subviews {
            if let blurView = subview as? UIVisualEffectView {
                blurView.removeFromSuperview()
            }
        }
    }
    
    @objc private func removeNftButtonClicked() {
        print("Удалить")
        guard let index = index else { return }
        delegate?.deleteNFT(at: index)
        dismiss(animated: true)
    }
    
    @objc private func backNftButtonClicked() {
        print("Назад")
        dismiss(animated: true)
    }
    
    private func setupViews() {
        view.addSubview(textLabel)
        view.addSubview(buttonStackView)
        view.addSubview(nftImage)
        buttonStackView.addArrangedSubview(removeNftButton)
        buttonStackView.addArrangedSubview(backNftButton)
        
        NSLayoutConstraint.activate([
            nftImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImage.bottomAnchor.constraint(equalTo: textLabel.topAnchor, constant: -12),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}


