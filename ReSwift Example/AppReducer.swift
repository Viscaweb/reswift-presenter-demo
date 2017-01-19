
import Foundation
import ReSwift

struct AppReducer: Reducer {
    typealias ReducerStateType = AppState
    
    public func handleAction(action: Action, state: AppState?) -> AppState {
        
        guard let state = state else {
            return AppState(alreadyGreeted: false)
        }

        switch action {
        case _ as ViewDidLoadAction:
            return AppState(alreadyGreeted: false)
        case _ as ToggleGreetingAction:
            return AppState(alreadyGreeted: !state.alreadyGreeted)
        default:
            return state
        }
    }
}
