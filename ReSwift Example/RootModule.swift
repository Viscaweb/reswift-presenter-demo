import UIKit
import ReSwiftRouter

class RootModule: Routable {

    let store: DefaultStore

    fileprivate let navigationController: UINavigationController
    fileprivate let rootViewController: RootViewController
    var viewController: UIViewController { return navigationController }

    init(store: DefaultStore,
         navigationController: UINavigationController, rootViewController: RootViewController) {

        self.store = store
        self.navigationController = navigationController
        self.rootViewController = rootViewController
    }
}
