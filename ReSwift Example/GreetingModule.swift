import Foundation
import ReSwiftRouter

class GreetingModule: Routable {
    let viewController: GreetingViewController

    init(viewController: GreetingViewController) {

        self.viewController = viewController
    }
}
