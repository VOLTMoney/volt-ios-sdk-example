//
//  ViewController.swift
//  VoltDemo
//
//  Created by R.P.Kumar.Mishra on 03/02/23.
//

import UIKit
import VoltFramework
import WebKit

public class ViewController: BaseViewController {

    @IBOutlet weak var voltWebView: WKWebView!

    @IBOutlet weak var refTextField: UITextField!
    @IBOutlet weak var partnerPlatformTextField: UITextField!
    @IBOutlet weak var primaryColorTextField: UITextField!
    @IBOutlet weak var secondaryColorTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var panNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!


    let platform: String = "SDK_INVESTWELL"
    let baseURL: String = "https://api.staging.voltmoney.in"
    let webBaseURL: String = "https://app.staging.voltmoney.in"

    var voltSDKInstance: Volt?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "VoltMoneySDK Sample"
    }

    @IBAction func createAppClick(_ sender: UIButton) {
        createVoltInstance()
        showProgressBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            createApplication()
        }
    }

    @IBAction func invokeSDKClick(_ sender: UIButton) {
        loadSDK()
    }

    func createVoltInstance() {
        let ref = refTextField.text ?? ""
        let primaryColor = primaryColorTextField.text ?? ""
        let secondaryColor = secondaryColorTextField.text ?? ""
        let partnerPlatform = partnerPlatformTextField.text ?? ""

        let voltInstance = VoltInstance(appKey: Constant.appKey, appSecret: Constant.appSecret, partnerPlatform: partnerPlatform, primaryColor: primaryColor, secondaryColor: secondaryColor, ref: ref)
        voltSDKInstance = Volt(voltInstance: voltInstance)
    }

    func createApplication() {

        let dob = dobTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let panNumber = panNumberTextField.text ?? ""
        let mobileNumber = mobileTextField.text ?? ""

        Volt.createApplication(dob: dob, email: email, panNumber: panNumber, mobileNumber: Int(mobileNumber) ?? +9100000000) { [weak self] response in
            self?.hideProgressBar()
            if response?.customerAccountId != nil {
                self?.showAlert(message: "Application Created.")
            } else {
                self?.showAlert(message: response?.message ?? "")
            }
        }
    }

    private func loadSDK() {
        //let mobileNumber = mobileTextField.text ?? ""

        //let createUrl = CreateVoltInstanceURL(mobileNumber: mobileNumber)

        //guard let url = Volt.createVoltSDKUrl() else { return }
        let controller = VoltHomeViewController()
        self.navigationController?.pushViewController(controller, animated: false)
    }

}


