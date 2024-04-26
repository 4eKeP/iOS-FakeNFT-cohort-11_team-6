import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void
typealias PaymentCompletion = (Result<PaymentConfirmation, Error>) -> Void
typealias CurrencyListCompletion = (Result<[Currency], Error>) -> Void

protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
    func paymentConfirmationRequest(completion: @escaping PaymentCompletion)
    func loadCurrencyList(completion: @escaping CurrencyListCompletion)
}

final class NftServiceImpl: NftService {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }

        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencyList(completion: @escaping CurrencyListCompletion) {
        networkClient.send(request: CurrencyRequest(), type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func paymentConfirmationRequest(completion: @escaping PaymentCompletion) {
        let request = PaymentConfirmationRequest()
        networkClient.send(request: request, type: PaymentConfirmation.self) { result in
            switch result {
            case .success(let paymentConfirmation):
                completion(.success(paymentConfirmation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
