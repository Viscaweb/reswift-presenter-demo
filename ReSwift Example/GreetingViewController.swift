//
//  GreetingViewController.swift
//  ReSwift Example
//
//  Created by Lluís Gómez on 19/01/2017.
//  Copyright © 2017 Top Affiliate Publishing. All rights reserved.
//

import UIKit
import ReSwift

struct GreetingViewModel {
    let message: String
    let buttonTitle: String
    
    let toggleGreetingAction: ToggleGreetingAction
}

protocol GreetingView: class {
    func display(_ viewModel: GreetingViewModel)
}

class GreetingViewController: UIViewController {
    private let store: DefaultStore
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var greetingButton: UIButton!
    
    fileprivate var toggleGreetingAction: Action?
    
    init(store: DefaultStore) {
        self.store = store
        super.init(nibName: "GreetingViewController", bundle: Bundle(for: GreetingViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.dispatch(ViewDidLoadAction())
    }
    
    @IBAction func didTapGreetingButton(_ sender: UIButton) {
        guard let action = toggleGreetingAction else { return }
        store.dispatch(action)
    }
}

extension GreetingViewController: GreetingView {
    func display(_ viewModel: GreetingViewModel) {
        guard isViewLoaded else { return }
        
        messageLabel.text = viewModel.message
        greetingButton.setTitle(viewModel.buttonTitle, for: .normal)
        toggleGreetingAction = viewModel.toggleGreetingAction
    }
}


struct ViewDidLoadAction: Action {}
