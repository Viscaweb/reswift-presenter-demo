//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


// ----------------------------------------------------------------------
// VIEW
// ----------------------------------------------------------------------

protocol ViewType: class {
    associatedtype ViewModel
    
    func update(with viewModel: ViewModel)
}

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
    associatedtype ViewModel
    func viewModel(for state: State) -> ViewModel
}


class Presenter<M: MapperType, V: ViewType>: StoreSubscriber where M.ViewModel == V.ViewModel {
    typealias StoreSubscriberStateType = M.State
    typealias State = M.State
    typealias ViewModel = M.ViewModel
    
    private let mapper: M
    private let view: V
    
    init(mapper: M, view: V) {
        self.mapper = mapper
        self.view = view
    }
    
    final func newState(state: State) {
        let viewModel = mapper.viewModel(for: state)
        view.update(with: viewModel)
    }
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
    typealias ViewModel = MatchCalendarViewModel
    
    func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
        return MatchCalendarViewModel(title: state.title)
    }
}

class MatchCalendarViewController: UIViewController, ConfigurableView {

    typealias ViewModel = MatchCalendarViewModel

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
        presenter: Presenter<MatchCalendarMapper, MatchCalendarViewController>,
        viewController: MatchCalendarViewController
    )

    static func create(with store: Store<AppState>) -> MatchCalendarModule {
        let mapper = MatchCalendarMapper()
        let viewController = MatchCalendarViewController()
        let presenter = Presenter(mapper: mapper, view: viewController)
        
        store.subscribe(presenter) { $0.calendar }
        
        return (presenter, viewController)
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
let module = MatchCalendarFactory.create(with: store)
PlaygroundPage.current.liveView = module.viewController

sleep(1)
store.dispatch(SetTitleAction(title: "NEW"))
