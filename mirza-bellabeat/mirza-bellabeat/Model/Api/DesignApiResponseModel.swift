import Foundation

struct DesignApiResponseModel: Codable {
    let title: String
    let colors: ColorsApiResponseModel
}

struct ColorsApiResponseModel: Codable {
    let backgroundColors: [String]
    let textColors: [String]

    enum CodingKeys: String, CodingKey {
        case backgroundColors = "background_colors"
        case textColors = "text_colors"
    }
}
