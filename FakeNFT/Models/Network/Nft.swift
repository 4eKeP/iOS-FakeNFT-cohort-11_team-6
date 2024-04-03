import Foundation

struct Nft: Decodable {
    let createdAt, name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
}
