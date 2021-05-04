import UIKit

class ViewController: UIViewController {
    private let viewModel: ViewModelProtocol = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchDesign()
    }
}

