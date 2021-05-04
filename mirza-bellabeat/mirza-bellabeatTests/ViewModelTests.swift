import XCTest
@testable import mirza_bellabeat

class ViewModelTests: XCTestCase {
    func testFetchingDesign() throws {
        let useCase = FetchDesignUseCase(
            apiService: MockedApiService(),
            designApiToDomainModelMapper: .init()
        )
        let vm = ViewModel(fetchDesignUseCase: useCase)
        var textColor: UIColor = .clear
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let expectation = self.expectation(description: "Fetching design")

        vm.setTextColor = { color in
            textColor = color
            expectation.fulfill()
        }
        vm.fetchDesign()

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(textColor == whiteColor)
    }

    func testErrorHandling() throws {
        let useCase = FetchDesignUseCase(
            apiService: MockedApiServiceError(),
            designApiToDomainModelMapper: .init()
        )
        let vm = ViewModel(fetchDesignUseCase: useCase)
        let expectation = self.expectation(description: "Fetching design")

        vm.showError = { _ in
            expectation.fulfill()
        }
        vm.fetchDesign()

        waitForExpectations(timeout: 5, handler: nil)
    }

    class MockedApiService: ApiService {
        func fetchDesign(completionHandler: @escaping (Result<DesignApiResponseModel, Error>) -> Void) {
            let colors = ColorsApiResponseModel(backgroundColors: ["000000"], textColors: ["ffffff"])
            let apiModel = DesignApiResponseModel(title: "Test", colors: colors)
            completionHandler(.success(apiModel))
        }
    }

    class MockedApiServiceError: ApiService {
        func fetchDesign(completionHandler: @escaping (Result<DesignApiResponseModel, Error>) -> Void) {
            completionHandler(.failure(NSError()))
        }
    }
}
