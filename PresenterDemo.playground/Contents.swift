//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


// ----------------------------------------------------------------------
// PRESENTER
// ----------------------------------------------------------------------

protocol ViewUpdater {
    associatedtype State
    associatedtype ViewModel
    
    var updateView: ((ViewModel) -> ())? {get set}
    
    func viewModel(for state: State) -> ViewModel
}

class Presenter<S, VM>: StoreSubscriber, ViewUpdater {

    typealias StoreSubscriberStateType = S
    typealias State = S
    typealias ViewModel = VM
    
    final internal var updateView: ((VM) -> ())?
    
    func viewModel(for state: State) -> ViewModel {
        fatalError("must override")
    }
    
    final func newState(state: State) {
        updateView!(viewModel(for: state))
    }
}


// ----------------------------------------------------------------------
// VIEW CONTROLLER
// ----------------------------------------------------------------------

protocol ViewType: class {
    associatedtype ViewModelType

    func update(with viewModel: ViewModelType)
}

protocol ConfigurableView: ViewType {
    var viewModel: ViewModelType? {get set}

    func configureView()
}

extension ConfigurableView where Self: UIViewController {

    func update(with viewModel: ViewModelType) {
        print("> ViewController: update(with: VM) - ConfigurableView Extension")

        self.viewModel = viewModel

        guard isViewLoaded else {
            return
        }

        configureView()
    }
}


// ----------------------------------------------------------------------
// IMPLEMENTATIONS
// ----------------------------------------------------------------------

struct MatchCalendarState: StateType {
    let title: String
}
struct MatchCalendarViewModel {
    let title: String
}

class MatchCalendarPresenter: Presenter<MatchCalendarState, MatchCalendarViewModel> {

    override func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
        return MatchCalendarViewModel(title: state.title)
    }
}

class MatchCalendarViewController: UIViewController, ConfigurableView {

    typealias ViewModelType = MatchCalendarViewModel

    internal var viewModel: MatchCalendarViewModel?

    override func viewDidLoad() {
        print("> ViewController: viewDidload")

        super.viewDidLoad()

        view.frame = CGRect(
            x: 0, y: 0, width: 320, height: 480)
        view.backgroundColor = .white
        
        configureView()
    }

    func configureView() {
        let title = viewModel?.title ?? "nil vm"
        print("> ViewController: configureView title \(title)")
    }
}

class MatchCalendarFactory {

    typealias MatchCalendarModule = (
        presenter: MatchCalendarPresenter,
        viewController: MatchCalendarViewController
    )

    static func create(with store: Store<AppState>) -> MatchCalendarModule {
        let presenter = MatchCalendarPresenter()
        let viewController = MatchCalendarViewController()

        presenter.updateView = viewController.update(with:)
        store.subscribe(presenter) { $0.calendar }
        
        return (presenter, viewController)
    }
}


// ----------------------------------------------------------------------
// DEMO
// ----------------------------------------------------------------------

// ReSwift stuffs -----------------------
struct SetTitleAction: Action {
    let title: String
}

struct AppState: StateType {
    let calendar: MatchCalendarState
}

let initialState = AppState(calendar: MatchCalendarState(title: "bla"))
func appReducer(action: Action, state: AppState?) -> AppState {
    if let titleAction = action as? SetTitleAction {
        return AppState(calendar: MatchCalendarState(title: titleAction.title))
    }
    
    return initialState
}


let store = Store(reducer: appReducer, state: initialState, middleware: [])


// View stuffs -----------------------
let module = MatchCalendarFactory.create(with: store)
PlaygroundPage.current.liveView = module.viewController

sleep(1)
store.dispatch(SetTitleAction(title: "NEW"))
