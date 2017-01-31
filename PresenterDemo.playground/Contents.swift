//: Playground - noun: a place where people can play

import UIKit
import ReSwift


// ----------------------------------------------------------------------
// PRESENTER
// ----------------------------------------------------------------------

protocol Presenter {

    associatedtype State
    associatedtype ViewModel

    func viewModel(for state: State) -> ViewModel
}


// ----------------------------------------------------------------------
// VIEW CONTROLLER
// ----------------------------------------------------------------------

protocol ViewType {
    associatedtype ViewModelType

    mutating func update(with viewModel: ViewModelType) // Presenter call this one
}

protocol ConfigurableView: ViewType {
    var viewModel: ViewModelType? {get set}

    func configureView()
}

extension ConfigurableView where Self: UIViewController {
    mutating func update(with viewModel: ViewModelType) { // Implement ViewType
        self.viewModel = viewModel

        guard isViewLoaded else {
            return
        }

        configureView()
    }
}


// ----------------------------------------------------------------------
// IMPLEMENTATIONS
// ----------------------------------------------------------------------

struct MatchCalendarState {}
struct MatchCalendarViewModel {}

class MatchCalendarPresenter: Presenter {

    var view: ((MatchCalendarViewModel) -> ())?

    func viewModel(for state: MatchCalendarState) -> MatchCalendarViewModel {
        return MatchCalendarViewModel()
    }
}

class MatchCalendarViewController: UIViewController, ConfigurableView {

    typealias ViewModelType = MatchCalendarViewModel

    internal var viewModel: MatchCalendarViewModel?

    func configureView() {
        // Pending implementation ...
    }
}


// ----------------------------------------------------------------------
// DEMO
// ----------------------------------------------------------------------

var p = MatchCalendarPresenter()
var vc = MatchCalendarViewController()

// This is incomplete

