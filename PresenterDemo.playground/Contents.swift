//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


// ----------------------------------------------------------------------
// PRESENTER
// ----------------------------------------------------------------------

protocol ViewModelable {
    associatedtype VM
    func viewModel() -> VM
}


class Presenter<S: ViewModelable, VM>: StoreSubscriber  where S.VM == VM {
    
    typealias StoreSubscriberStateType = S
    typealias State = S
    typealias ViewModel = VM
    
    final internal var updateView: ((VM) -> ())?
    
    final func newState(state: S) {
        updateView!(state.viewModel())
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
        print("> ViewController: updateVM")

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

extension MatchCalendarState: ViewModelable {
    typealias VM = MatchCalendarViewModel
    func viewModel() -> MatchCalendarViewModel {
        return MatchCalendarViewModel(title: title)
    }
}

struct MatchCalendarViewModel {
    let title: String
}

class MatchCalendarViewController: UIViewController, ConfigurableView {

    typealias ViewModelType = MatchCalendarViewModel

    internal var viewModel: MatchCalendarViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("> ViewController: viewDidload")

        view.frame = CGRect(
            x: 0, y: 0, width: 320, height: 480)
        view.backgroundColor = .white
        
        configureView()
    }

    func configureView() {
        let title = viewModel?.title ?? "nil vm"
        print("> ViewController: configureView \(title)")
    }
}

class MatchCalendarFactory {

    typealias MatchCalendarModule = (
        presenter: Presenter<MatchCalendarState, MatchCalendarViewModel>,
        viewController: MatchCalendarViewController
    )

    static func create(with store: Store<AppState>) -> MatchCalendarModule {
        let presenter = Presenter<MatchCalendarState, MatchCalendarViewModel>()
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

func appReducer(action: Action, state: AppState?) -> AppState {
    var title = "DEFAULT"
    if let titleAction = action as? SetTitleAction {
        title = titleAction.title
    }
    
    print("> Reducer: \(title)")
    return AppState(calendar: MatchCalendarState(title: title))
}


let store = Store(reducer: appReducer, state: nil, middleware: [])


// View stuffs -----------------------
let module = MatchCalendarFactory.create(with: store)
PlaygroundPage.current.liveView = module.viewController

sleep(1)
store.dispatch(SetTitleAction(title: "NEW"))
