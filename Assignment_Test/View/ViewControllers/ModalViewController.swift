//
//  ModalViewController.swift
//

import UIKit
import WebKit

class ModalViewController: UIViewController {

    var interactor:Interactor? = nil
    @IBOutlet weak var webView: WKWebView!
    var strURL = ""
    override func viewDidLoad() {
        let url = URL(string: strURL)
        webView.load(URLRequest(url: url!))
    }
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {

        let percentThreshold:CGFloat = 0.3

        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
  
}
