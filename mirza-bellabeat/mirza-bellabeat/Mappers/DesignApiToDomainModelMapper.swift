import Foundation
import UIKit

struct DesignApiToDomainModelMapper {
    func toDomain(apiModel: DesignApiResponseModel) -> Design {
        let backgroundColors = apiModel.colors.backgroundColors.compactMap { hexColor in
            UIColor(hex: hexColor)
        }

        let textColors = apiModel.colors.textColors.compactMap { hexColor in
            UIColor(hex: hexColor)
        }

         return .init(
            title: apiModel.title,
            colors: .init(
                backgroundColors: backgroundColors,
                textColors: textColors
            )
        )
    }
}
