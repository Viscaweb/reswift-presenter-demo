import Foundation
import ReSwift
import ReSwiftRouter

typealias DefaultStore = Store<AppState>

struct AppState: StateType {

    var alreadyGreeted: Bool
    var navigationState: NavigationState
    
    public init(
        alreadyGreeted: Bool,
        navigationState: NavigationState) {

        self.alreadyGreeted = alreadyGreeted
        self.navigationState = navigationState
    }
}
