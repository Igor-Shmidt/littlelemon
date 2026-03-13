import Foundation

struct MenuItem: Codable {
    let title: String
    let image: String?
    let price: String
    let category: String?
    let text: String?
}

extension MenuItem {
    enum CodingKeys: String, CodingKey {
        case title, image, price, category, text = "description"
    }
}
