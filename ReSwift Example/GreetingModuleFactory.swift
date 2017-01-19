
import Foundation
import ReSwift

class GreetingModuleFactory {
    func viewController(store: Store<AppState>) -> GreetingViewController {
        let viewController = GreetingViewController(store: store)
        let presenter = GreetingPresenter(view: viewController, store: store)
        viewController.presenter = presenter
        return viewController
    }
}
