
import Foundation
import ReSwift

class GreetingPresenter {
    fileprivate weak var view: GreetingView!
    private let store: DefaultStore
    
    init(view: GreetingView, store: DefaultStore) {
        self.view = view
        self.store = store
        
        store.subscribe(self)
    }

    deinit {
        print("Presenter deallocated")
        store.unsubscribe(self)
    }
    
}

extension GreetingPresenter: StoreSubscriber {
    func newState(state: AppState) {
        view.display(GreetingViewModel(state: state))
    }
}

private extension GreetingViewModel {
    init(state: AppState) {
        if state.alreadyGreeted {
            message = "Bye!"
            buttonTitle = "Say hi!"
        } else {
            message = "Hi!"
            buttonTitle = "Say bye!"
        }

        toggleGreetingAction = ToggleGreetingAction()
    }
    
}

struct ToggleGreetingAction: Action {}
