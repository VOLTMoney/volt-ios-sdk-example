//
//  WebViewLocalViewController.swift
//  VoltDemo
//
//  Created by R.P.Kumar.Mishra on 06/02/23.
//

import UIKit
import WebKit

class WebViewLocalViewController: BaseViewController {

    @IBOutlet weak var voltWebView: WKWebView!

    let platform: String = "SDK_INVESTWELL"
    let baseURL: String = "https://api.staging.voltmoney.in"
    let webBaseURL: String = "https://app.staging.voltmoney.in"

    var webViewURLObserver: NSKeyValueObservation?
    var voltSDKInstance: VoltSDKContainer?

    public override func viewDidLoad() {
        super.viewDidLoad()

        voltWebView?.navigationDelegate = self
        voltWebView?.uiDelegate = self
        voltWebView?.allowsBackForwardNavigationGestures = true
        loadWebView()

        webViewURLObserver = voltWebView.observe(\.url, options: .new) { webview, change in
            print("URL: \(String(describing: change.newValue))")
            // The webview parameter is the webview whose url changed
            // The change parameter is a NSKeyvalueObservedChange
            // n.b.: you don't have to deregister the observation;
            // this is handled automatically when webViewURLObserver is dealloced.
          }
    }

    func createInstance() {
        let appKey = "volt-sdk-staging@voltmoney.in"
        let appSecret = "e10b6eaf2e334d1b955434e25fcfe2d8"
        let ref =  ""
        let primaryColor =  ""
        let secondaryColor = ""
        let partnerPlatform = ""

        let voltInstance = VoltInstance(voltEnv: .PRODUCTION ,app_key: appKey, app_secret: appSecret, partner_platform: partnerPlatform, primary_color: primaryColor, secondary_color: secondaryColor, ref: ref)
        voltSDKInstance = VoltSDKContainer(voltInstance: voltInstance)
    }

    private func loadWebView() {
        createInstance()
        showProgressBar()
        let webURL = VoltSDKContainer.initVoltSDK(mobileNumber: "")
        //let webURL = URL(string: VoltSDKContainer.initVoltSDK(mobileNumber: ""))
        //let webURL = URL(string: "https://app.staging.voltmoney.in/partnerplatform?platform=SDK_INVESTWELL&ref=4CCLRP&primaryColor=FFA500&user=8447463946")
        //let webURL = URL(string: "https://app.staging.voltmoney.in/?partnerPlatform=SDK_INVESTWELL&user=8376023408")
        //let webURL = URL(string: "https://purple.telstra.com/blog/swiftui---state-vs--stateobject-vs--observedobject-vs--environme")
        voltWebView.load(NSURLRequest(url: webURL ?? URL(fileURLWithPath: "")) as URLRequest)
//        voltWebView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
//        voltWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

    }
}

extension WebViewLocalViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        UIApplication.shared.open(navigationAction.request.url ?? URL(fileURLWithPath: ""))
        return nil
    }
}

extension WebViewLocalViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print(webView.url?.absoluteString)
        hideProgressBar()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressBar()
    }


    func webView(_ webView: WKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKWebView) -> Bool {

        if request.url?.absoluteString == "https://www.google.com" {
            return false
        }
        return true
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "tel" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.scheme == "mailto" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.scheme == "whatsapp" {
            UIApplication.shared.open(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }

        /*if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    let host = url.host, !host.hasPrefix("http://alpha-credi-iwacrptd21m3-1877051856.ap-south-1.elb.amazonaws.com/creditApplication/noOp/loan/agreementSetup/420e993a-75d5-4349-be11-9f7f06f79abf"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    //print(url)
                    //voltWebView.load(NSURLRequest(url: url ?? URL(fileURLWithPath: "")) as URLRequest)
                    print("Redirected to browser. No need to open it locally")
                    decisionHandler(.cancel)
                    return
                } else {
                    print("Open it locally")
                    decisionHandler(.allow)
                    return
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
                return
            }*/
        }
}
