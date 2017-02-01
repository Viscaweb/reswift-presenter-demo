import Foundation
import ReSwift

public protocol Presenter: StoreSubscriber {
    associatedtype ViewModel
    
    var updateView: ((ViewModel) -> ())? {get set}
    
    func viewModel(for state: StoreSubscriberStateType) -> ViewModel
}

public extension Presenter {
    func newState(state: Self.StoreSubscriberStateType) {
        print("> Presenter: newState")
        
        updateView!(viewModel(for: state))
    }
}
