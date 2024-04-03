//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Марат Хасанов on 22.03.2024.
//

import UIKit

final class CartViewController: UIViewController {
    
    private var cellCount: Double = 0
    private var mockID: [String] = []
    private var loadImages = LoadNftImages()
    
    private let cartService: CartService = CartServiceImpl(networkClient: DefaultNetworkClient())
    private let nftService: NftService = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    private var idAddedToCart: Set<String> = []
    private var arrOfNFT: [Nft] = []
    
    private lazy var emptyCart: UILabel = {
       let label = UILabel()
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
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //Отделение с кнопкой оплаты
    private lazy var bottomView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ypLightGray")
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftPrice: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.text = "0,0 ETH"
        label.textColor = UIColor(named: "ypUniGreen")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonPay: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 240).isActive = true
        button.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: активировать пустой экран
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureVC()
        loadCart(httpMethod: .get) {[weak self] error in
            self?.processNFTsLoading()
        }
    }
    
    private func configureVC() {
        tableView.delegate = self
        tableView.dataSource = self
        //setupEmptyOrNftViews()
        setupAllViews()
    }
    
    private func setupEmptyOrNftViews() {
        if arrOfNFT.isEmpty {
            setupEmptyViews()
            nftCount.text = "0 NFT"
            nftPrice.text = "0,0 ETH"
        } else {
            setupAllViews()
        }
    }
    
    //MARK: NETWORK CLIENT
    private func loadCart(httpMethod: HttpMethod, id: String? = nil, completion: @escaping (Error?) -> Void ) {
        cartService.loadCart(httpMethod: httpMethod, model: nil) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cart):
                idAddedToCart = Set(cart.nfts)
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error)
            }
        }
    }
    
    private func processNFTsLoading() {
        for id in idAddedToCart {
            loadNft(id: id)
        }
    }
    
    private func loadNft(id: String) {
        nftService.loadNft(id: id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nft):
                arrOfNFT.append(nft)
                tableView.reloadData()
            case .failure(let error):
               print(error)
            }
        }
    }
    
    //MARK: View
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        // Добавляем действия для каждой опции сортировки
        alertController.addAction(UIAlertAction(title: "По цене", style: .default) { _ in
            self.arrOfNFT.sort { nftItem1, nftItem2 in
                nftItem1.price < nftItem2.price
            }
            self.tableView.reloadData()
            print("Сортировка по цене")
        })
    
        alertController.addAction(UIAlertAction(title: "По рейтингу", style: .default) { _ in
            self.arrOfNFT.sort { nftItem1, nftItem2 in
                nftItem1.rating > nftItem2.rating
            }
            self.tableView.reloadData()
            print("Сортировка по рейтингу")
        })
        
        alertController.addAction(UIAlertAction(title: "По названию", style: .default) { _ in
            self.arrOfNFT.sort { nftItem1, nftItem2 in
                nftItem1.name < nftItem2.name
            }
            self.tableView.reloadData()
            print("Сортировка по названию")
        })
        
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        
        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }
        
    @objc func payButtonClicked() {
        let viewController = UINavigationController(rootViewController:  PayNftViewController())
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated:  true)
        print("Оплатить!")
    }
    
    private func viewDeleteController(index: IndexPath, image: UIImage) {
        applyBlurEffect()
        let vc = DeleteViewController()
        vc.delegate = self
        vc.image = image
        vc.index = index
        present(vc, animated: true)
    }
    
    //применяем блюр
    private func applyBlurEffect() {
        guard let window = UIApplication.shared.windows.first else { return }
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.bounds
        window.addSubview(blurEffectView)
    }
    
    // Находим размытое представление и удаляем его
    func removeBlurEffect() {
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
        let addButton = UIBarButtonItem(image: UIImage(named: "filterIcon")!, style: .plain, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
        view.addSubview(tableView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(nftCount)
        bottomView.addSubview(nftPrice)
        bottomView.addSubview(buttonPay)
        
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

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrOfNFT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CartCustomCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.nftName.text = arrOfNFT[indexPath.row].name
        cell.nftPrice.text = String(arrOfNFT[indexPath.row].price)
        //Цена всех NFT
        var cellCount = 0.0
        for count in self.arrOfNFT {
            cellCount += count.price
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        if let formattedString = formatter.string(from: NSNumber(value: cellCount)) {
            nftPrice.text = String(formattedString)
        }
        nftCount.text = "\(arrOfNFT.count) NFT"
        cell.starsCount = arrOfNFT[indexPath.row].rating
        
        //Картинка
        let imagesURL = arrOfNFT[indexPath.row].images[0]
        loadImage(imageUrl: imagesURL, indexPath: indexPath)
        cell.indexPath = indexPath
        return cell
    }
}

extension CartViewController {
    func loadImage(imageUrl: URL, indexPath: IndexPath) {
        // Загрузка данных изображения асинхронно
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            // Проверка наличия ошибок
            guard let imageData = data, error == nil else {
                print("Ошибка при загрузке изображения: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // Инициализация UIImage с использованием данных изображения
            if let image = UIImage(data: imageData) {
                // Обновление UI в основном потоке
                DispatchQueue.main.async {
                    if let updatedCell = self.tableView.cellForRow(at: indexPath) as? CartCustomCell {
                        updatedCell.nftImage.image = image
                    }
                }
            } else {
                print("Не удалось создать изображение из загруженных данных")
            }
        }
        .resume()
    }
}

extension CartViewController: CartCellDelegate {
    func deleteButtonTapped(at indexPath: IndexPath, image: UIImage) {
        viewDeleteController(index: indexPath, image: image)
    }
}

extension CartViewController: NftDeleteDelegate {
    func deleteNFT(at index: IndexPath) {
        arrOfNFT.remove(at: index.row)
        setupEmptyOrNftViews()
        tableView.reloadData()
    }
}
