//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

protocol CartView: AnyObject {
    func showLoader()
    func hideLoader()
    func displayEmptyCart()
    func displayNFTs(_ nfts: [Nft])
    func displayError(_ message: String)
    func reloadTableView(nft: [Nft])
}

final class CartViewController: UIViewController {
    
    //MARK: - Private properies
    private let servicesAssembly: ServicesAssembly
    
    private var viewArrOfNFT: [Nft] = []
    
    private var presenter: CartPresenter?
    
    private let cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private var idAddedToCart: Set<String> = []
    
    private lazy var loaderIndicator: UIImageView = {
        let image = UIImage(named: "Loader")
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyCart: UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Корзина пуста"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.widthAnchor.constraint(equalToConstant: 343).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CartCustomCell.self, forCellReuseIdentifier: "customCell")
        table.separatorStyle = .none
        table.backgroundColor = Asset.Colors.ypWhite.color
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
        view.isHidden = true
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 12
        view.heightAnchor.constraint(equalToConstant: 76).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "0 NFT"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "0,0 ETH"
        label.isHidden = true
        label.textColor = UIColor(named: "ypUniGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonPay: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("К оплате", for: .normal)
        button.isHidden = true
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = UIColor(named: "ypBlack")
        button.setTitleColor(UIColor(named: "ypWhite"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 240).isActive = true
        button.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.ypWhite.color
        updatesAllSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatesAllSetups()
    }
    
    // MARK: - Private Methods
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Произошла ошибка", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func setupNetwork() {
        guard let presenter = presenter else { return }
        presenter.loadCart(httpMethod: .get) {[weak self] error in
            self?.showLoader()
            presenter.processNFTsLoading()
            self?.reloadTableView(nft: presenter.arrOfNFT)
        }
    }
    
    private func updatesAllSetups() {
        configureVC()
        setupNetwork()
    }
    
    private func configureVC() {
        presenter = CartPresenter(
            view: self,
            cartService: cartService,
            nftService: nftService)
        guard let presenter = presenter else { return }
        presenter.viewDidLoad()
        setupTableView()
        setupIndicator()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupIndicator() {
        view.addSubview(loaderIndicator)
        NSLayoutConstraint.activate([
            loaderIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupEmptyOrNftViews() {
        if viewArrOfNFT.isEmpty {
            loaderIndicator.isHidden = true
            setupEmptyViews()
            emptyCart.isHidden = false
            nftCount.isHidden = true
            nftPrice.isHidden = true
            bottomView.isHidden = true
            buttonPay.isHidden = true
            navigationItem.rightBarButtonItem = nil
        } else {
            setupAllViews()
            buttonPay.isHidden = false
            nftPrice.isHidden = false
            nftCount.isHidden = false
            bottomView.isHidden = false
            emptyCart.isHidden = false
        }
    }
    
    @objc private func addButtonTapped() {
        guard let presenter = presenter else { return }
        let sortedAlert = presenter.sortedNft()
        present(sortedAlert, animated: true)
    }
        
    @objc private func payButtonClicked() {
        let vc = PayNftViewController(servicesAssembly: servicesAssembly)
        vc.paymentID = ""
        let viewController = UINavigationController(rootViewController:  vc)
        vc.allPaymentNft = viewArrOfNFT
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated:  true)
    }
    
    private func viewDeleteController(index: IndexPath, 
                                      image: UIImage,
                                      id: String) {
        applyBlurEffect()
        let vc = DeleteViewController()
        vc.delegate = self
        vc.image = image
        vc.index = index
        vc.idDeleteNft = id
        present(vc, animated: true)
    }
    
    private func applyBlurEffect() {
        guard let window = UIApplication.shared.windows.first else { return }
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.bounds
        window.addSubview(blurEffectView)
    }

    private func removeBlurEffect() {
        guard let window = UIApplication.shared.windows.first else { return }
        for subview in window.subviews {
            if let blurView = subview as? UIVisualEffectView {
                blurView.removeFromSuperview()
            }
        }
    }
    
    private func setupEmptyViews() {
        view.addSubview(emptyCart)
        NSLayoutConstraint.activate([
            emptyCart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCart.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    private func setupAllViews() {
        let addButton = UIBarButtonItem(image: Asset.CatalogImages.filterIcon.image,
                                     style: .plain,
                                     target: self,
                                        action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
        view.addSubview(tableView)
        view.addSubview(bottomView)
        [nftCount, nftPrice, buttonPay].forEach {
            bottomView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nftCount.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            nftCount.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            
            nftPrice.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            nftPrice.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
            
            buttonPay.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonPay.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16),
        ])
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CartCustomCell else { return }
        cell.indexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewArrOfNFT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CartCustomCell else {
            return UITableViewCell()
        }
        if let presenter = presenter {
            cell.delegate = self
            cell.update(
                name: viewArrOfNFT[indexPath.row].name,
                price: "\(viewArrOfNFT[indexPath.row].price) ETH",
                starsCount: viewArrOfNFT[indexPath.row].rating,
                indexPath: indexPath
            )

            var cellCount = 0.0
            cell.selectionStyle = .none
            for count in viewArrOfNFT {
                cellCount += count.price
            }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.numberStyle = .decimal
            if let formattedString = formatter.string(from: NSNumber(value: cellCount)) {
                nftPrice.text = "\(String(formattedString)) ETH"
            }
            nftCount.text = "\(viewArrOfNFT.count) NFT"
            
            let imagesURL = viewArrOfNFT[indexPath.row].images[0]
            if let cachedImage = presenter.imageCache.object(forKey: imagesURL.absoluteString as NSString) {
                cell.nftImage.image = cachedImage
            } else {
                cell.nftImage.image = UIImage(named: "placeholder")
                loadImage(imageUrl: imagesURL, indexPath: indexPath)
            }
            cell.deleteNftId = viewArrOfNFT[indexPath.row].id
        }
        return cell
    }
    
    private func loadImage(imageUrl: URL, indexPath: IndexPath) {
        presenter?.loadImage(from: imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self,
                        let image = image,
                        let cell = self.tableView.cellForRow(at: indexPath) as? CartCustomCell else {
                    return
                }
                cell.nftImage.image = image
                self.presenter?.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString)
            }
        }
    }
}

// MARK: - CartCellDelegate
extension CartViewController: CartCellDelegate {
    func deleteButtonTapped(at indexPath: IndexPath, image: UIImage, id: String) {
        viewDeleteController(index: indexPath, image: image, id: id)
    }
}

// MARK: - NftDeleteDelegate
extension CartViewController: NftDeleteDelegate {
    func deleteNFT(at id: String) {
        presenter?.deleteNFT(at: id) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.setupEmptyOrNftViews()
            }
        }
    }
}

// MARK: - CartView
extension CartViewController: CartView {
    func reloadTableView(nft: [Nft]) {
        viewArrOfNFT = nft
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            self.setupEmptyOrNftViews()
        }
        tableView.reloadData()
    }
    
    func showLoader() {
        loaderIndicator.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.loaderIndicator.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
    }
    
    func hideLoader() {
        loaderIndicator.isHidden = true
        loaderIndicator.layer.removeAllAnimations()
    }
    
    func displayEmptyCart() {
        emptyCart.isHidden = false
    }
    
    func displayNFTs(_ nfts: [Nft]) {
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        showErrorAlert()
    }
}
