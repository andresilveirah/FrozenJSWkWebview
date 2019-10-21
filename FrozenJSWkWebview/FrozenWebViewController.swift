//
//  FrozenWebView.swift
//  FrozenJSWkWebview
//
//  Created by Andre Herculano on 21.10.19.
//

import UIKit
import WebKit

class FrozenWebViewController: UIViewController, WKScriptMessageHandler {
    let blankPage = """
        <html>
            <head></head>
            <body>
              <h1>Hello World</h1>
              <script>
                var counter = 0
                setInterval(function() {
                  JSReceiver.greet("Ping: " + counter++)
                }, 1000);
                setTimeout(function() {
                  JSReceiver.greet("I'm a sneaky one!")
                }, 5000);
              </script>
            </body>
        </html>
    """
    let script = WKUserScript(source: """
        JSReceiver = {
            greet: function (message) {
                webkit.messageHandlers.JSReceiver.postMessage(message)
            }
        }
    """, injectionTime: .atDocumentStart, forMainFrameOnly: true)

    lazy var webView: WKWebView! = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        userContentController.add(self, name: "JSReceiver")
        config.userContentController = userContentController
        return WKWebView(frame: .zero, configuration: config)
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadMessage() {
        webView.loadHTMLString(blankPage, baseURL: nil)
    }

    override func loadView() {
        view = webView
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body as! String)
    }
}
