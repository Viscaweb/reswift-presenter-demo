import Foundation
import UIKit
import ReSwift

enum ModuleFactory {

    static func root(store: DefaultStore) -> RootModule {

        let rootViewController = RootViewController(store: store)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        let module = RootModule(
            store: store,
            navigationController: navigationController,
            rootViewController: rootViewController)
        return module
    }

    static func greeting(store: DefaultStore) -> GreetingModule {
        let viewController = GreetingViewController(store: store)
        let presenter = GreetingPresenter(view: viewController, store: store)
        // viewController.presenter = presenter // Uncomment me will solve the problem

        let module = GreetingModule(viewController: viewController)

        return module
    }
}
