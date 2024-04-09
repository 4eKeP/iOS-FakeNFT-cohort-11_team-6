//
//  PayNftViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 23.03.2024.
//

import UIKit
import WebKit

final class PayNftViewController: UIViewController {
    
    private let cryptoImage: [String] = ["Bitcoin (BTC)", "Dogecoin (DOGE)", "Tether (USDT)", "ApeCoin (APE)", "Solana (SOL)", "Ethereum (ETH)", "Cardano (ADA)", "Shiba Inu (SHIB)"]
    
    private let cryptoFullName: [String] = ["Bitcoin", "Dogecoin", "Tether", "Apecoin", "Solana", "Ethereum", "Cardano", "Shiba Inu"]
    
    private let cryptoShortName: [String] = ["BTC", "DOGE", "USDT", "APE", "SOL", "ETH", "ADA", "SHIB"]
    
    var back = false
    
    private lazy var selectedCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(CryptoWalletCell.self, forCellWithReuseIdentifier: "CryptoCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()

    //Отделение с кнопкой оплаты
    private lazy var bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.heightAnchor.constraint(equalToConstant: 186).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
       let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var webInfo: WKWebView?
    
    private lazy var infoWebButton: UIButton = {
       let button = UIButton()
        button.setTitle("Пользовательского соглашения", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(UIColor(named: "ypUniBlue"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.heightAnchor.constraint(equalToConstant: 26).isActive = true
        button.widthAnchor.constraint(equalToConstant: 202).isActive = true
        button.addTarget(self, action: #selector(showUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if back {
            dismissModal()
        }
    }
    
    private func configureVC() {
        view.backgroundColor = .white
        title = "Выберите способ оплаты"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(dismissModal))
        setupViews()
    }
    
    @objc func payButtonClicked() {
        let vc = CongratulationViewController()
        back = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        print("PAY PAY PAY")
    }
    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showUserInfo() {
        webInfo = WKWebView()
        guard let webInfo = webInfo else { return }
        webInfo.navigationDelegate = self
        view = webInfo
        let htmlString = "<html><body><iframe width=\"\(view.frame.width)\" height=\"\(view.frame.height)\" src=\"https://www.youtube.com/embed/gSMlVALgjEc\" frameborder=\"0\" allowfullscreen></iframe></body></html>"

        webInfo.loadHTMLString(htmlString, baseURL: nil)
    }
    
    private func setupViews() {
        view.addSubview(bottomView)
        view.addSubview(selectedCollection)
        [infoLabel, infoWebButton, payButton].forEach {
            bottomView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            selectedCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectedCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectedCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectedCollection.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            selectedCollection.heightAnchor.constraint(equalToConstant: 200),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            infoLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            infoWebButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            infoWebButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            infoWebButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
        
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)])
    }
}

extension PayNftViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.absoluteString != "about:blank" {
            // открыть ссылку в браузере
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            // отмена навигации внутри WKWebView
            decisionHandler(.cancel)
        } else {
            // разрешение навигации внутри WKWebView
            decisionHandler(.allow)
        }
    }
}

extension PayNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CryptoCell", for: indexPath) as? CryptoWalletCell else {
            return UICollectionViewCell()
        }
        
        let imageName = cryptoImage[indexPath.row]
        let image = UIImage(named: imageName)
        cell.cryptoImage.image = image
        
        let cryptoFullName = cryptoFullName[indexPath.row]
        cell.fullNameCrypto.text = cryptoFullName
        
        let cryptoShortName = cryptoShortName[indexPath.row]
        cell.shortNameCrypto.text = cryptoShortName
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12
        return cell
    }
}

extension PayNftViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 168
        let cellHeight: CGFloat = 46

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //отступы от краев секции
        return UIEdgeInsets(top: 20, left: 0, bottom: 7, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CryptoWalletCell {
            cell.layer.borderWidth = 1 // Устанавливаем толщину рамки
            cell.layer.borderColor = UIColor.black.cgColor // Устанавливаем цвет рамки
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CryptoWalletCell {
            cell.layer.borderWidth = 0 // Сбрасываем толщину рамки
        }
    }
}
