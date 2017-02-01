//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import ReSwift


struct MatchCalendarState: StateType {
    let title: String
}
struct MatchCalendarViewModel {
    let title: String
}

class MatchCalendarPresenter: Presenter {
    typealias StoreSubscriberStateType = MatchCalendarState
    typealias ViewModel = MatchCalendarViewModel
    
    internal var updateView: ((MatchCalendarViewModel) -> ())?

    internal func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
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
        print("> ViewController: configureView \(title)")
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
