import Foundation

struct NFTRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(NetworkConstants.baseURL)/api/v1/nft/\(id)")
    }
}
