import UIKit
import ReSwiftRouter

class RootModule: Routable {

    let store: DefaultStore

    fileprivate let navigationController: UINavigationController
    fileprivate let rootViewController: RootViewController
    var viewController: UIViewController { return navigationController }

    init(store: DefaultStore,
         navigationController: UINavigationController,
         rootViewController: RootViewController) {

        self.store = store
        self.navigationController = navigationController
        self.rootViewController = rootViewController
    }

    // Maybe owning sub-routes will not scale, or maybe
    // it will work even better than a central route
    // setup (like you do in Rails) ¯\_(ツ)_/¯
    lazy var greetingModule: GreetingModule = ModuleFactory.greeting(store: self.store)

    func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        guard routeElementIdentifier == "Greeting"
            else { preconditionFailure("unsupported route") }

        let greetingModule = self.greetingModule
        let greetingVC = greetingModule.viewController

//        navigationController.pushViewController(greetingVC, animated: true)
//        completionHandler()
        rootViewController.present(greetingVC, animated: true, completion: completionHandler)

        return greetingModule
    }
}
