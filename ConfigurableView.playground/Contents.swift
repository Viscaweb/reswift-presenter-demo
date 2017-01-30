//: Playground - noun: a place where people can play

import UIKit

protocol ViewType {
    associatedtype ViewModelType
    mutating func set(viewModel: ViewModelType)
}

protocol ConfigurableView: ViewType {
    var viewModel: ViewModelType {get set}
    func configure(for viewModel: ViewModelType)
}

extension ConfigurableView where Self: UIViewController {
    mutating func set(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        guard isViewLoaded else {
            return
        }
        
        configure(for: viewModel)
    }
}

//struct BasicViewModel {
//    let title: String
//}
//
//
//class BasicViewController: UIViewController, ConfigurableView {
//    typealias ViewModelType = BasicViewModel
//    internal var viewModel: BasicViewModel
//    internal func configure(for viewModel: BasicViewModel) {
//        
//    }
//
//    init() {
//        super.init()
//    }
//    
//}
//
//let viewController = BasicViewController()
//viewController.dis
