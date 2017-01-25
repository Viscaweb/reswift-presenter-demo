import Foundation
import ReSwift
import ReSwiftRouter

struct AppReducer: Reducer {
    typealias ReducerStateType = AppState
    
    public func handleAction(action: Action, state: AppState?) -> AppState {
        
        var state = state ?? AppState(alreadyGreeted: false, navigationState: NavigationState())

        switch action {
        case _ as ViewDidLoadAction:
            state.alreadyGreeted = false
        case _ as ToggleGreetingAction:
            state.alreadyGreeted = !state.alreadyGreeted
        default: break
        }

        return state
    }
}
