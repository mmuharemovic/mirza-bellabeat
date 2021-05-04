import UIKit

class ViewController: UIViewController {
    private enum Constants {
        static let pickerHeight: CGFloat = 244
        static let toolbarHeight: CGFloat = 44
        static let animationDuration: TimeInterval = 0.2
        static let pickerViewComponentHeight: CGFloat = 15
        static let pickerViewComponentWidth: CGFloat = 15
        static let pickerViewComponentRadius: CGFloat = 5
        static let pickerViewComponentsNumber = 1
    }

    private enum PickerType {
        case textColor
        case backgroundColor
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    private var viewModel: ViewModelProtocol = ViewModel()
    private var toolbar: UIToolbar?
    private var picker: UIPickerView?
    private var pickerType: PickerType = .textColor

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchDesign()
    }

    private func bind() {
        viewModel.setTitleText = { [weak self] title in
            DispatchQueue.main.async {
                self?.titleLabel.text = title
            }
        }

        viewModel.setTextColor = { [weak self] color in
            DispatchQueue.main.async {
                self?.titleLabel.textColor = color
            }
        }

        viewModel.setBackgroundColor = { [weak self] color in
            DispatchQueue.main.async {
                self?.view.backgroundColor = color
            }
        }

        viewModel.showError = { [weak self] error in
            DispatchQueue.main.async {
                let alertController = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self?.present(alertController, animated: true, completion: nil)
            }
        }

        viewModel.hideLoader = { [weak self] in
            DispatchQueue.main.async {
                self?.loaderView.isHidden = true
                self?.containerView.isHidden = false
            }
        }
    }

    @IBAction func backgroundColorButtonPressed(_ sender: Any) {
        pickerType = .backgroundColor
        showTimeoutPicker()
    }

    @IBAction func titleTextColorButtonPressed(_ sender: Any) {
        pickerType = .textColor
        showTimeoutPicker()
    }

    private func showTimeoutPicker() {
        if let picker = picker, view.subviews.contains(picker) {
            return
        }

        addDatePicker()
        addDatePickerToolbar()

        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            self?.picker?.transform = CGAffineTransform(translationX: .zero, y: -Constants.pickerHeight)
            self?.toolbar?.transform = CGAffineTransform(translationX: .zero, y: -Constants.pickerHeight)
        })
    }

    private func hideTimeoutPicker() {
        UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
            self?.picker?.transform = CGAffineTransform(translationX: .zero, y: .zero)
            self?.toolbar?.transform = CGAffineTransform(translationX: .zero, y: .zero)
        }, completion: { [weak self] _ in
            self?.toolbar?.removeFromSuperview()
            self?.picker?.removeFromSuperview()
        })
    }

    @objc
    private func onDoneButtonTapped() {
        guard let picker = picker else { return }
        let index = picker.selectedRow(inComponent: Constants.pickerViewComponentsNumber - 1)

        switch pickerType {
        case .textColor:
            viewModel.textColorChanged(colorIndex: index)
        case .backgroundColor:
            viewModel.backgroundColorChanged(colorIndex: index)
        }

        hideTimeoutPicker()
    }

    @objc
    private func onCancelButtonTapped() {
        hideTimeoutPicker()
    }

    private func addDatePicker() {
        picker = UIPickerView()
        picker?.delegate = self
        picker?.dataSource = self
        picker?.autoresizingMask = .flexibleWidth
        picker?.contentMode = .center
        picker?.frame = .init(
            x: .zero,
            y: UIScreen.main.bounds.size.height,
            width: UIScreen.main.bounds.size.width,
            height: Constants.pickerHeight
        )
        picker?.backgroundColor = .white

        if let picker = picker {
            view.addSubview(picker)
        }
    }

    private func addDatePickerToolbar() {
        toolbar = .init(
            frame: .init(
                x: .zero,
                y: UIScreen.main.bounds.size.height,
                width: UIScreen.main.bounds.size.width,
                height: Constants.toolbarHeight
            )
        )

        toolbar?.barStyle = .default

        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(onCancelButtonTapped)
        )

        let titleButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )

        let titleLabel = UILabel()
        titleLabel.text = "Color picker"
        titleLabel.sizeToFit()
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .center
        titleButton.customView = titleLabel

        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(onDoneButtonTapped)
        )

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar?.barTintColor = .white
        toolbar?.items = [cancelButton, flexSpace, titleButton, flexSpace, doneButton]

        if let toolbar = toolbar {
            view.addSubview(toolbar)
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Constants.pickerViewComponentsNumber
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case .textColor:
            return viewModel.textColors?.count ?? 0
        case .backgroundColor:
            return viewModel.backgroundColors?.count ?? 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let view = UIView(
            frame: .init(
                x: .zero,
                y: .zero,
                width: Constants.pickerViewComponentWidth,
                height: Constants.pickerViewComponentHeight
            )
        )
        view.layer.cornerRadius = Constants.pickerViewComponentRadius

        switch pickerType {
        case .textColor:
            view.backgroundColor = viewModel.textColors?[row]
        case .backgroundColor:
            view.backgroundColor = viewModel.backgroundColors?[row]
        }

        return view
    }
}
