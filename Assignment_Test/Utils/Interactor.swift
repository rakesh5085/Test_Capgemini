// Interactor.swift
//
// This file contains the implementation of the Interactor class, which is used to manage custom interactive transitions for UIViewController animations.

import UIKit

/// The Interactor class conforms to the UIPercentDrivenInteractiveTransition protocol, which allows it to manage interactive transitions for UIViewController animations.
class Interactor: UIPercentDrivenInteractiveTransition {
    /// A boolean value that indicates whether the interactive transition has started.
    var hasStarted = false
    
    /// A boolean value that indicates whether the interactive transition should finish.
    var shouldFinish = false
}
