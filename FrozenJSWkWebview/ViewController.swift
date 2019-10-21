//
//  ViewController.swift
//  FrozenJSWkWebview
//
//  Created by Andre Herculano on 21.10.19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = FrozenWebViewController()
        controller.loadMessage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("presenting controller...")
            self.present(controller, animated: false, completion: nil)
        }
    }
}

