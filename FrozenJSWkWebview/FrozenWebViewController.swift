//
//  FrozenWebView.swift
//  FrozenJSWkWebview
//
//  Created by Andre Herculano on 21.10.19.
//

import UIKit
import WebKit

protocol MessageDelegate {
    func onMessageReady()
    func onConsentReady()
}

class FrozenWebViewController: UIViewController, WKScriptMessageHandler {
    static let MESSAGE_HANDLER_NAME = "JSReceiver"

    var messageDelegate: MessageDelegate?

    func inAppPage(consented: Bool) -> String {
        return """
            <html>
                <head>
                  <meta name="viewport" content="width=device-width, initial-scale=1, height=device-height, viewport-fit=cover, user-scalable=no">
                </head>
                <body style="padding: 50px">
                  <h1>Consent Message</h1>
                  <button onclick="JSReceiver.onConsentReady()">Accept</butto>
                  <script>
                    var counter = 0
                    setInterval(function() { JSReceiver.ping("Ping: " + counter++) }, 1000);

                    \(consented ?
                        "setTimeout(function() { JSReceiver.onConsentReady(); }, 5000);" :
                        "setTimeout(function() { JSReceiver.onMessageReady(); }, 5000);"
                   )
                  </script>
                </body>
            </html>
        """
    }

    let script = WKUserScript(source: """
        JSReceiver = {
            postMessage: function(message) { webkit.messageHandlers.JSReceiver.postMessage(message) },
            ping: function(message) { this.postMessage(message) },
            onMessageReady: function() { this.postMessage("onMessageReady") },
            onConsentReady: function() { this.postMessage("onConsentReady") }
        }
        """ ,injectionTime: .atDocumentStart, forMainFrameOnly: true)

    lazy var webView: WKWebView! = {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        userContentController.add(self, name: FrozenWebViewController.MESSAGE_HANDLER_NAME)
        config.userContentController = userContentController
        let webview = WKWebView(frame: .zero, configuration: config)
        return webview
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMove(toParent parent: UIViewController?) {
        if(parent == nil) {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: FrozenWebViewController.MESSAGE_HANDLER_NAME)
        }
    }

    func loadMessage() {
        webView.loadHTMLString(inAppPage(consented: false), baseURL: nil)
    }

    override func loadView() {
        view = webView
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let event = message.body as! String
        switch event {
        case "onMessageReady":
            messageDelegate?.onMessageReady()
        case "onConsentReady":
            messageDelegate?.onConsentReady()
        default:
            print(event)
        }
    }
}
