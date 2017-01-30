import UIKit
import ReSwift
import ReSwiftRouter

class RootViewController: UIViewController {

    private let store: DefaultStore
    @IBOutlet weak var onwardButton: UIButton!

    init(store: DefaultStore) {
        self.store = store
        super.init(nibName: "RootViewController", bundle: Bundle(for: RootViewController.self))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func goOnward(_ sender: Any) {

        store.dispatch(SetRouteAction(["Greeting"]))
    }

}
