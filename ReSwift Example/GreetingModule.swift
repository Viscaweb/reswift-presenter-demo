import Foundation
import ReSwiftRouter

class GreetingModule: Routable {
    let viewController: GreetingViewController
    let presenter: GreetingPresenter

    convenience init(store: DefaultStore) {
        let viewController = GreetingViewController(store: store)
        let presenter = GreetingPresenter(view: viewController, store: store)

        self.init(viewController: viewController, presenter: presenter)
    }

    init(
        viewController: GreetingViewController,
        presenter: GreetingPresenter) {

        self.viewController = viewController
        self.presenter = presenter
    }
}
