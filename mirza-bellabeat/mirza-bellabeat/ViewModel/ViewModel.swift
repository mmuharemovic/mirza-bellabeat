import Foundation
import UIKit

protocol ViewModelProtocol {
    func fetchDesign()
    func backgroundColorChanged(colorIndex: Int)
    func textColorChanged(colorIndex: Int)
    var hideLoader: (() -> Void)? { get set }
    var setTitleText: ((String?) -> Void)? { get set }
    var setTextColor: ((UIColor) -> Void)? { get set }
    var setBackgroundColor: ((UIColor) -> Void)? { get set }
    var showError: ((Error) -> Void)? { get set }
    var textColors: [UIColor]? { get }
    var backgroundColors: [UIColor]? { get }
}

class ViewModel: ViewModelProtocol {
    private let fetchDesignUseCase: FetchDesignUseCase
    private var design: Design? {
        didSet {
            setTitleText?(design?.title)
        }
    }

    private var textColor: UIColor = .clear {
        didSet {
            setTextColor?(textColor)
        }
    }

    private var backgroundColor: UIColor = .clear {
        didSet {
            setBackgroundColor?(backgroundColor)
        }
    }

    var textColors: [UIColor]? {
        design?.colors.textColors.filter { color in
            color != backgroundColor
        }
    }

    var backgroundColors: [UIColor]? {
        design?.colors.backgroundColors.filter { color in
            color != textColor
        }
    }

    var hideLoader: (() -> Void)?
    var setTitleText: ((String?) -> Void)?
    var setTextColor: ((UIColor) -> Void)?
    var setBackgroundColor: ((UIColor) -> Void)?
    var showError: ((Error) -> Void)?

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
        fetchDesignUseCase.execute { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(design):
                self.design = design
                self.textColor = design.colors.textColors.randomElement() ?? .clear
                self.backgroundColor = design.colors.backgroundColors.filter { color in
                    color != self.textColor
                }.randomElement() ?? .clear
                self.hideLoader?()
            case let .failure(error):
                self.showError?(error)
            }
        }
    }

    func backgroundColorChanged(colorIndex: Int) {
        if let color = backgroundColors?[colorIndex] {
            backgroundColor = color
        }
    }

    func textColorChanged(colorIndex: Int) {
        if let color = textColors?[colorIndex] {
            textColor = color
        }
    }
}
