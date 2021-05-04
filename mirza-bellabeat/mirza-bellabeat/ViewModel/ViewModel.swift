import Foundation

protocol ViewModelProtocol {
    func fetchDesign()
}

class ViewModel: ViewModelProtocol {
    private let fetchDesignUseCase: FetchDesignUseCase

    convenience init() {
        let fetchDesignUseCase = FetchDesignUseCase(
            apiService: ApiDataService(),
            designApiToDomainModelMapper: .init()
        )

        self.init(fetchDesignUseCase: fetchDesignUseCase)
    }

    init(fetchDesignUseCase: FetchDesignUseCase) {
        self.fetchDesignUseCase = fetchDesignUseCase
    }

    func fetchDesign() {
        fetchDesignUseCase.execute { result in
            switch result {
            case let .success(design):
                break
            case let .failure(error):
                //SHOW ERROR
                break
            }
        }
    }
}
