import Foundation
import ReSwift

struct AppState: StateType {
    let alreadyGreeted: Bool
    
    public init(alreadyGreeted: Bool) {
        self.alreadyGreeted = alreadyGreeted
    }
}
