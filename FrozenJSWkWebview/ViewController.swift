//
//  ViewController.swift
//  FrozenJSWkWebview
//
//  Created by Andre Herculano on 21.10.19.
//

import UIKit

class ViewController: UIViewController {
    lazy var controller: FrozenWebViewController = {
        return FrozenWebViewController()
    }()

    func present(_ controller: UIViewController, after deadline: DispatchTime) {
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            print("presenting controller...")
            self.present(controller, animated: false, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.loadMessage()
        present(controller, after: .now() + 10)
    }
}

