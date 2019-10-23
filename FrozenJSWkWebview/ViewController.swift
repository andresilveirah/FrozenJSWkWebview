//
//  ViewController.swift
//  FrozenJSWkWebview
//
//  Created by Andre Herculano on 21.10.19.
//

import UIKit

class ViewController: UIViewController, MessageDelegate {
    @IBOutlet weak var consentContainerView: UIView!

    var consentController: FrozenWebViewController?

    func showConsentContainer() {
        consentContainerView.isHidden = false
        view.bringSubviewToFront(consentContainerView)
    }

    func removeConsentController() {
        consentContainerView.removeFromSuperview()
        consentController?.willMove(toParent: nil)
        consentController?.view.removeFromSuperview()
        consentController?.removeFromParent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controller = children.first as? FrozenWebViewController else  {
            fatalError("Check storyboard for missing FrozenWebViewController")
        }
        consentController = controller
        consentController?.messageDelegate = self
        consentController?.loadMessage()
    }

    // MessageDelegate

    func onMessageReady() {
        showConsentContainer()
    }

    func onConsentReady() {
        removeConsentController()
    }
}

