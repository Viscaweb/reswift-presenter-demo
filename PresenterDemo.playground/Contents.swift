//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


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
        print("> ViewController: updateVM")
        
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

protocol MapperType {
    associatedtype State
    associatedtype View: ViewType
    func viewModel(for state: State) -> View.ViewModel
}

class Presenter<M: MapperType>: StoreSubscriber  {
    typealias State = M.State
    typealias View  = M.View
    
    private let mapper: M
    private weak var view: View! //weak to avoid retain cycle
    
    init(mapper: M, view: View) {
        self.mapper = mapper
        self.view = view
    }
    
    final func newState(state: State) {
        print("> Presenter: newState")
        let viewModel = mapper.viewModel(for: state)
        view.update(with: viewModel)
    }
}



// ----------------------------------------------------------------------
// INTERACTOR
// ----------------------------------------------------------------------

class Interactor<M: MapperType, SelectedState: StateType> where M.State == SelectedState {
    private let presenter: Presenter<M>
    private let store: Store<AppState>
    private let stateSelector: ((AppState) -> SelectedState)?

    init(presenter: Presenter<M>, store: Store<AppState>, stateSelector: ((AppState) -> SelectedState)? = nil) {
        self.presenter = presenter
        self.store = store
        self.stateSelector = stateSelector
    }
    
    func subscribe() {
        store.subscribe(presenter, selector: stateSelector)
    }
    
    func unsubscribe() {
        store.unsubscribe(presenter)
    }
    
    func dispatch(_ action: Action) {
        store.dispatch(action)
    }
    
//    func dispatch(_ actionCreator: Store<AppState>.ActionCreator) {
//        store.dispatch(actionCreator)
//    }
}


// ----------------------------------------------------------------------
// IMPLEMENTATIONS: MatchCalendar Module
// ----------------------------------------------------------------------

struct MatchCalendarState: StateType {
    let title: String
}

struct MatchCalendarViewModel {
    let title: String
}

struct MatchCalendarMapper: MapperType {
    typealias State = MatchCalendarState
    typealias View = MatchCalendarViewController
    
    func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
        return MatchCalendarViewModel(title: state.title)
    }
}

class MatchCalendarViewController: UIViewController, ConfigurableView {

    typealias ViewModel = MatchCalendarViewModel

    internal var viewModel: MatchCalendarViewModel?

    var interactor: MatchCalendarInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("> ViewController: viewDidload")

        view.frame = CGRect(
            x: 0, y: 0, width: 320, height: 480)
        view.backgroundColor = .white
        
        interactor.subscribe()
    }

    func configureView() {
        let title = viewModel?.title ?? "nil vm"
        print("> ViewController: configureView \(title)\n")
    }
}

//protocol ModuleFactory {
//    associatedtype State: StateType
//    associatedtype View: ViewType
//    associatedtype Store: StoreType
//    
//    func createViewController(store: Store) -> UIViewController
//}

class ModuleFactory<State: StateType, View: ViewType, Store: StoreType> {
    func createViewController(view: View, store: Store) {
        
    }
}

typealias MatchCalendarInteractor = Interactor<MatchCalendarMapper, MatchCalendarState>

class MatchCalendarFactory {

    static func createViewController(with store: Store<AppState>) -> UIViewController {
        let mapper = MatchCalendarMapper()
        let viewController = MatchCalendarViewController()
        let presenter = Presenter(mapper: mapper, view: viewController)
        let interactor = Interactor(presenter: presenter, store: store) { $0.calendar }
        viewController.interactor = interactor
        return viewController
    }
}


// ----------------------------------------------------------------------
// DEMO
// ----------------------------------------------------------------------

// ReSwift stuff -----------------------
struct SetTitleAction: Action {
    let title: String
}

struct AppState: StateType {
    let calendar: MatchCalendarState
}

func appReducer(action: Action, state: AppState?) -> AppState {
    var title = "DEFAULT"
    if let titleAction = action as? SetTitleAction {
        title = titleAction.title
    }
    
    print("> Reducer: \(title)")
    return AppState(calendar: MatchCalendarState(title: title))
}


// Execution -----------------------
let store = Store(reducer: appReducer, state: nil, middleware: [])
let viewController = MatchCalendarFactory.createViewController(with: store)
PlaygroundPage.current.liveView = viewController

sleep(1)
store.dispatch(SetTitleAction(title: "NEW"))
