//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


// ----------------------------------------------------------------------
// PRESENTER
// ----------------------------------------------------------------------

protocol Mapper {
    associatedtype State
    associatedtype ViewModel
    func viewModel(for state: State) -> ViewModel
}


class Presenter<M: Mapper>: StoreSubscriber {
    
    typealias StoreSubscriberStateType = M.State
    typealias State = M.State
    typealias ViewModel = M.ViewModel
    
    final internal var updateView: ((ViewModel) -> ())?
    
    private let mapper: M
    init(mapper: M) {
        self.mapper = mapper
    }
    final func newState(state: State) {
        updateView!(mapper.viewModel(for: state))
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

//extension MatchCalendarState: ViewModelable {
//    typealias VM = MatchCalendarViewModel
//    func viewModel() -> MatchCalendarViewModel {
//        return MatchCalendarViewModel(title: title)
//    }
//}


struct MatchCalendarViewModel {
    let title: String
}

struct MatchCalendarMapper: Mapper {
    typealias State = MatchCalendarState
    typealias ViewModel = MatchCalendarViewModel
    
    func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
        return MatchCalendarViewModel(title: state.title)
    }
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
        print("> ViewController: configureView \(title)\n")
    }
}

class MatchCalendarFactory {

    typealias MatchCalendarModule = (
        presenter: Presenter<MatchCalendarMapper>,
        viewController: MatchCalendarViewController
    )

    static func create(with store: Store<AppState>) -> MatchCalendarModule {
        let presenter = Presenter<MatchCalendarMapper>(mapper: MatchCalendarMapper())
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
