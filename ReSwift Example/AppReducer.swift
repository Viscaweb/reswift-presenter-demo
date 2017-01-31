import Foundation
import ReSwift
import ReSwiftRouter

func appReducer(action: Action, state: AppState?) -> AppState {

    var state = state ?? AppState(alreadyGreeted: false, navigationState: NavigationState())

    state.navigationState = NavigationReducer.handleAction(action, state: state.navigationState)

    switch action {
    case _ as ViewDidLoadAction:
        state.alreadyGreeted = false
    case _ as ToggleGreetingAction:
        state.alreadyGreeted = !state.alreadyGreeted
    default: break
    }

    return state
}
