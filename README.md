# FrozenJSWkWebview
A POC to investigate WKWebView pausing Javascript evaluation and timers.

TL;DR; - if a `WKWebView` is instantiated but not attached to a controller in the foreground (presented to the user), iOS _pauses_ the webview preventing it from evaluating javascript. This issue is only reproducedable on real physical devices.

For more context check this StackOverflow question - [iOS - Present/Show ViewController while content underneath remains interactive](
https://stackoverflow.com/questions/58490516/ios-present-show-viewcontroller-while-content-underneath-remains-interactive)
