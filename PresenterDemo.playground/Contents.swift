//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift
import ReSwiftRouter





/*
 ██████╗ ██╗      █████╗ ██╗   ██╗ ██████╗ ██████╗  ██████╗ ██╗   ██╗███╗   ██╗██████╗
 ██╔══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔════╝ ██╔══██╗██╔═══██╗██║   ██║████╗  ██║██╔══██╗
 ██████╔╝██║     ███████║ ╚████╔╝ ██║  ███╗██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ██║
 ██╔═══╝ ██║     ██╔══██║  ╚██╔╝  ██║   ██║██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║  ██║
 ██║     ███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝
 ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝
 */

PlaygroundPage.current.needsIndefiniteExecution = true // Because Router dispatch async on Main queue

class Logger {
    private static let startTime = Date()

    static func log(_ text: String) {
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(startTime)
        let elapsedMS = String(format: "%.2f", abs(elapsedTime))

        print("+\(elapsedMS) - \(text)")
    }
}






/*
 ███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
 ██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
 █████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝
 ██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗
 ██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
 ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

*/

// ----------------------------------------------------------------------
// VIEW
// ----------------------------------------------------------------------

/// what the presenter knows about
protocol ViewType: class {
    associatedtype ViewModel
    func update(with viewModel: ViewModel)
}

/// what the view controller conforms to
protocol ConfigurableView: ViewType {
    var viewModel: ViewModel? {get set}
    
    func configureView()
}

extension ConfigurableView where Self: UIViewController {
    
    func update(with viewModel: ViewModel) {
        Logger.log("ViewController: update(with:)")
        
        self.viewModel = viewModel
        
        guard isViewLoaded else {
            return
        }
        
        configureView()
    }
}


// ----------------------------------------------------------------------
// PRESENTER
// ----------------------------------------------------------------------

protocol ViewAdapter {
    associatedtype State
    associatedtype View: ViewType
    func viewModel(for state: State) -> View.ViewModel
}

class Presenter<Adapter: ViewAdapter>: StoreSubscriber  {
    typealias State = Adapter.State
    typealias View  = Adapter.View
    
    private let mapper: Adapter
    private weak var view: View! //weak to avoid retain cycle
    
    init(mapper: Adapter, view: View) {
        self.mapper = mapper
        self.view = view
    }
    
    final func newState(state: State) {
        Logger.log("Presenter: newState : \(state)")
        let viewModel = mapper.viewModel(for: state)
        view.update(with: viewModel)
    }
}



// ----------------------------------------------------------------------
// INTERACTOR
// ----------------------------------------------------------------------

class Interactor<Adapter: ViewAdapter> {
    typealias SelectedState = Adapter.State
    
    private let presenter: Presenter<Adapter>
    private let store: Store<AppState>
    private let stateSelector: ((AppState) -> SelectedState)?

    init(presenter: Presenter<Adapter>, store: Store<AppState>, stateSelector: ((AppState) -> SelectedState)? = nil) {
        self.presenter = presenter
        self.store = store
        self.stateSelector = stateSelector
    }
    
    func subscribe() {
        Logger.log("Interactor: subscribe")
        store.subscribe(presenter, selector: stateSelector)
    }
    
    func unsubscribe() {
        Logger.log("Interactor: unsubscribe")
        store.unsubscribe(presenter)
    }
    
    func dispatch(_ action: Action) {
        Logger.log("Interactor: dispatch(action)")
        store.dispatch(action)
    }
    
    func dispatch(_ actionCreator: @escaping Store<AppState>.ActionCreator) {
        Logger.log("Interactor: dispatch(actionCreator)")
        store.dispatch(actionCreator)
    }
}








/*
 ██╗  ██╗ ██████╗ ███╗   ███╗███████╗    ███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗██╗     ███████╗
 ██║  ██║██╔═══██╗████╗ ████║██╔════╝    ████╗ ████║██╔═══██╗██╔══██╗██║   ██║██║     ██╔════╝
 ███████║██║   ██║██╔████╔██║█████╗      ██╔████╔██║██║   ██║██║  ██║██║   ██║██║     █████╗
 ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝      ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██║     ██╔══╝
 ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝███████╗███████╗
 ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
 */

typealias HomeInteractor = Interactor<HomeAdapter>

struct HomeState: StateType {
    let title: String
}

struct SetTitleAction: Action {
    let title: String
}

struct HomeViewModel {
    let title: String
}

struct HomeAdapter: ViewAdapter {
    typealias State = HomeState
    typealias View = HomeViewController
    
    func viewModel(for state: HomeState) -> HomeViewModel {
        return HomeViewModel(title: state.title)
    }
}

class HomeViewController: UIViewController, ConfigurableView {
    typealias ViewModel = HomeViewModel

    internal var viewModel: HomeViewModel?
    var interactor: HomeInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("ViewController: viewDidload")

        view.frame = CGRect(
            x: 0, y: 0, width: 320, height: 480)
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.subscribe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.unsubscribe()
    }

    func configureView() {
        Logger.log("ViewController: configureView, viewModel = \(viewModel)")
    }
}

class HomeFactory {

    static func createViewController() -> HomeViewController {
        guard let store = Container.store else {
            fatalError("Not store available")
        }

        let mapper = HomeAdapter()
        let viewController = HomeViewController()
        let presenter = Presenter(mapper: mapper, view: viewController)
        let interactor = Interactor(presenter: presenter, store: store) { $0.home }
        viewController.interactor = interactor

        return viewController
    }
}








/*
 ██████╗ ███████╗███╗   ███╗ ██████╗
 ██╔══██╗██╔════╝████╗ ████║██╔═══██╗
 ██║  ██║█████╗  ██╔████╔██║██║   ██║
 ██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║
 ██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝
 ╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝
 */


// ----------------------------------------------------------------------
// MODULE FACTORY
// ----------------------------------------------------------------------

class ViewControllersFactory {
    static func create(for name: String) -> UIViewController {
        switch name {
        case "home":
            return HomeFactory.createViewController()
        default:
            fatalError("Unsported \(name) controller")
        }
    }
}


// ----------------------------------------------------------------------
// ROUTING
// ----------------------------------------------------------------------

extension UIViewController: Routable {
    public func pushRouteSegment(_ routeElementIdentifier: RouteElementIdentifier,
                                 animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        Logger.log("ViewController: pushRouteSegment: Push \"\(routeElementIdentifier)\" from \(self)")

        let nextViewController = ViewControllersFactory.create(for: routeElementIdentifier)

        if let selfAsNavVC = self as? UINavigationController {
            selfAsNavVC.pushViewController(nextViewController, animated: animated)
        } else {
            self.navigationController!.pushViewController(nextViewController, animated: animated)
        }

        completionHandler()

        return nextViewController
    }

    public func popRouteSegment(_ routeElementIdentifier: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) {

        Logger.log("ViewController: popRouteSegment")

        if let selfAsNavVC = self as? UINavigationController {
            selfAsNavVC.popViewController(animated: animated)
        } else {
            self.navigationController!.popViewController(animated: animated)
        }

        completionHandler()
    }

    public func changeRouteSegment(_ from: RouteElementIdentifier, to: RouteElementIdentifier, animated: Bool, completionHandler: @escaping RoutingCompletionHandler) -> Routable {

        Logger.log("ViewController: changeRouteSegment")

        let nextViewController = ViewControllersFactory.create(for: to)

        if let selfAsNavVC = self as? UINavigationController {
            selfAsNavVC.viewControllers.removeLast()
            selfAsNavVC.viewControllers.append(nextViewController)
        } else {
            self.navigationController!.viewControllers.removeLast()
            self.navigationController!.viewControllers.append(nextViewController)
        }
        
        return nextViewController
        
    }
}



// ----------------------------------------------------------------------
// APPLICATION
// ----------------------------------------------------------------------

/// Just to share an instance
class Container {
    static var store: Store<AppState>?
}

struct AppState: StateType {
    let navigationState: NavigationState
    let home: HomeState
}

func appReducer(action: Action, state: AppState?) -> AppState {

    Logger.log("Reducer: state = \(state)")
    Logger.log("Reducer: action = \(action)")

    var title = "DEFAULT"
    if let titleAction = action as? SetTitleAction {
        title = titleAction.title
    }

    let navState = NavigationReducer.handleAction(action, state: state?.navigationState)
    Logger.log("Reducer: navState = \(navState)")

    let newState = AppState(
        navigationState: navState,
        home: HomeState(title: title)
    )

    Logger.log("Reducer: newState = \(newState)")

    return newState
}


// ----------------------------------------------------------------------
// SETUP AND RUN
// ----------------------------------------------------------------------

let defaultRoute = ["home"]
let initialState = AppState(
    navigationState: NavigationState(),
    home: HomeState(title: "DEFAULT")
)
let store = Store(reducer: appReducer, state: initialState)
Container.store = store

let rootViewController = UINavigationController()
let router = Router(store: store, rootRoutable: rootViewController) { $0.navigationState}

PlaygroundPage.current.liveView = rootViewController

_ = store.dispatch { state, _ in
    if state.navigationState.route.isEmpty {
        return SetRouteAction(defaultRoute)
    } else {
        return nil
    }
}

// Dispatch another routing action 2s later
DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
    store.dispatch(SetRouteAction(["home", "home"], animated: true))
    Logger.log("DONE")
}
