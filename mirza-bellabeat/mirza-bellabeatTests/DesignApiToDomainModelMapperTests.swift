import XCTest
@testable import mirza_bellabeat

class DesignApiToDomainModelMapperTests: XCTestCase {
    func testConvertingHexToUI() throws {
        let colors = ColorsApiResponseModel(backgroundColors: ["000000"], textColors: ["ffffff"])
        let apiModel = DesignApiResponseModel(title: "Test", colors: colors)
        let mapper = DesignApiToDomainModelMapper()
        let domainModel = mapper.toDomain(apiModel: apiModel)
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        XCTAssert(domainModel.colors.backgroundColors[0] == blackColor)
        XCTAssert(domainModel.colors.textColors[0] == whiteColor)
    }
}
