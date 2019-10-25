//
//  ViewController.swift
//  FrozenJSWkWebview
//
//  Created by Andre Herculano on 21.10.19.
//

import UIKit

class ViewController: UIViewController, MessageDelegate {

    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        startSpinner()
        setupConsentController()
    }

    var consentController: FrozenWebViewController?

    var spinnerController: SpinnerViewController?

    func setupConsentController() {
        consentController = FrozenWebViewController()
        consentController?.messageDelegate = self
        consentController?.loadMessage()
        add(childController: consentController!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConsentController()
    }

    // Boilerplate code for managing the attaching/removing
    // the webview without showing it to the user

    private func showConsentView(_ controller: UIViewController?) {
        controller?.view.frame = view.bounds
        controller?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func add(childController controller: UIViewController) {
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }

    private func remove(childController controller: UIViewController?) {
        controller?.willMove(toParent: nil)
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
    }

    //  Boilerplate code for handling spinner view controller -------------

    func startSpinner() {
        let spinner = SpinnerViewController()
        add(childController: spinner)
        spinner.view.frame = view.bounds
        spinnerController = spinner
    }

    func stopSpinner() {
        remove(childController: spinnerController)
    }

    // MessageDelegate ---------------------------------------------------

    func onMessageReady() {
        stopSpinner()
        showConsentView(consentController)
    }

    func onConsentReady() {
        stopSpinner()
        remove(childController: consentController)
    }
}

