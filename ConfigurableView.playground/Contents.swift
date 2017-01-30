
import UIKit
import PlaygroundSupport

// What the Presenter knows about the VC. The Presenter holds a reference to a ViewType conforming instance
protocol ViewType {
    associatedtype ViewModelType
    mutating func update(with viewModel: ViewModelType)
}

// What the VC implements. This makes the following extension possible.
protocol ConfigurableView: ViewType {
    var viewModel: ViewModelType? {get set}
    func configureView()
}

// This extension works as a template pattern without the need of subclassing.
// configureView is the customizable/overridable point of the template.
extension ConfigurableView where Self: UIViewController {
    mutating func update(with viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        guard isViewLoaded else {
            return
        }
        
        configureView()
    }
}



// ---------------- DEMO ----------------


struct BasicViewModel {
    let title: String
    let backgroundColor: UIColor
}


class BasicViewController: UIViewController, ConfigurableView {
    typealias ViewModelType = BasicViewModel
    internal var viewModel: BasicViewModel?
    
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeViewAppearance()
        configureView()
    }
    
    private func customizeViewAppearance() {
        view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleLabel.textColor = .white
    }
    
    // This, together with the viewModel property, comes for free with the ConfigurableView protocol conformance.
    // Therefore it provides an easy to reason about class template.
    internal func configureView() {
        guard let viewModel = self.viewModel else { return }
        
        print("title: \(viewModel.title)")
        
        view.backgroundColor = viewModel.backgroundColor
        titleLabel.text = viewModel.title
    }
}



// Run

var viewController = BasicViewController()
PlaygroundPage.current.liveView = viewController.view

viewController.update(with: BasicViewModel(title: "blue", backgroundColor: .blue))
viewController.update(with: BasicViewModel(title: "red", backgroundColor: .red))
viewController.update(with: BasicViewModel(title: "green", backgroundColor: .green))


