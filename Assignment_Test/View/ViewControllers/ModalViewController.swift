//  ModalViewController.swift
//
//  This class represents a view controller that displays a web view modally. It includes functionality for dismissing the view controller, as well as a pan gesture recognizer for interactive dismissal.

import UIKit
import WebKit

class ModalViewController: UIViewController {

    // Interactor object for handling interactive dismissal
    var interactor:Interactor? = nil
    
    // Weak outlet for the web view
    @IBOutlet weak var webView: WKWebView!
    
    // The URL string to be loaded in the web view
    var strURL = ""
    
    override func viewDidLoad() {
        // Load the URL in the web view
        let url = URL(string: strURL)
        webView.load(URLRequest(url: url!))
    }
    
    // Action for the close button that dismisses the view controller
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Gesture recognizer for interactive dismissal of the view controller
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        // Constants for the pan gesture threshold and calculations
        let percentThreshold:CGFloat = 0.3
        ...
    }
}

// Protocol for handling interactive dismissal of the view controller
protocol Interactor {
    var hasStarted: Bool { get set }
    var shouldFinish: Bool { get set }
    func update(_ progress: CGFloat)
    func cancel()
    func finish()
}
