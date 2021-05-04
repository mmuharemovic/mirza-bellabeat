import Foundation

class FetchDesignUseCase {
    private let apiService: ApiService
    private let designApiToDomainModelMapper: DesignApiToDomainModelMapper

    init(
        apiService: ApiService,
        designApiToDomainModelMapper: DesignApiToDomainModelMapper
    ) {
        self.apiService = apiService
        self.designApiToDomainModelMapper = designApiToDomainModelMapper
    }

    func execute(completionHandler: @escaping (Result<Design, Error>) -> Void) {
        apiService.fetchDesign { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(apiModel):
                let domainModel = self.designApiToDomainModelMapper.toDomain(apiModel: apiModel)
                completionHandler(.success(domainModel))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
