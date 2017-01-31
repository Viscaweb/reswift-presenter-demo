//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


// ----------------------------------------------------------------------
// PRESENTER
// ----------------------------------------------------------------------

protocol Presenter {

    associatedtype State
    associatedtype ViewModel

    func viewModel(for state: State) -> ViewModel
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
        print("> ConfigurableView: update")

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

struct MatchCalendarState {}
struct MatchCalendarViewModel {}

class MatchCalendarPresenter: Presenter, StoreSubscriber {

    var view: ((MatchCalendarViewModel) -> ())?

    func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
        return MatchCalendarViewModel()
    }

    func newState(state: AppState) {
        print("> Presenter: newState")

        let viewModel = MatchCalendarViewModel()
        view!(viewModel)
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
    }

    func configureView() {
        print("> ViewController: configureView")

        // Pending implementation ...
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

        presenter.view = viewController.update(with:)
        store.subscribe(presenter)

        return (presenter, viewController)
    }
}


// ----------------------------------------------------------------------
// DEMO
// ----------------------------------------------------------------------

// ReSwift stuffs -----------------------
struct DummyAction: Action {}

struct AppState: StateType {
    let calendar: MatchCalendarState
}

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(calendar: MatchCalendarState())
}

let initialState = AppState(calendar: MatchCalendarState())

let store = Store(reducer: appReducer, state: initialState, middleware: [])


// View stuffs -----------------------
let module = MatchCalendarFactory.create(with: store)


PlaygroundPage.current.liveView = module.viewController


