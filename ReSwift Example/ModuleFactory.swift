import Foundation
import ReSwift

enum ModuleFactory {
    static func greeting(store: Store<AppState>) -> GreetingModule {
        let viewController = GreetingViewController(store: store)
        let presenter = GreetingPresenter(view: viewController, store: store)
        // viewController.presenter = presenter // Uncomment me will solve the problem

        let module = GreetingModule(viewController: viewController)

        return module
    }
}
