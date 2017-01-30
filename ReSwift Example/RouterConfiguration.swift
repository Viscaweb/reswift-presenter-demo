import class UIKit.UIWindow
import ReSwiftRouter

struct RouterConfiguration {

    let router: Router<AppState>
    let rootModule: RootModule

    init(store: DefaultStore) {

        let rootModule = ModuleFactory.root(store: store)
        let router = Router(store: store, rootRoutable: rootModule) { state in
            state.navigationState
        }

        self.init(router: router, rootModule: rootModule)
    }

    init(router: Router<AppState>, rootModule: RootModule) {

        self.router = router
        self.rootModule = rootModule
    }

    func setup(window: UIWindow) {
        window.rootViewController = rootModule.viewController
    }
}
