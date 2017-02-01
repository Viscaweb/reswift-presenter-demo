import Foundation
import UIKit

public protocol ViewType: class {
    associatedtype ViewModelType
    
    func update(with viewModel: ViewModelType)
}

public protocol ConfigurableView: ViewType {
    var viewModel: ViewModelType? {get set}
    
    func configureView()
}

public extension ConfigurableView where Self: UIViewController {
    
    func update(with viewModel: ViewModelType) {
        print("> ViewController: updateVM")
        
        self.viewModel = viewModel
        
        guard isViewLoaded else {
            return
        }
        
        configureView()
    }
}
