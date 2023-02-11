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

    var voltSDKInstance: VoltSDKContainer?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "VoltMoneySDK Sample"
    }

    @IBAction func createAppClick(_ sender: UIButton) {
        showProgressBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            createApplication()
        }
    }

    @IBAction func createVoltInstanceClick(_ sender: UIButton) {
        createVoltInstance()
    }

    @IBAction func invokeSDKClick(_ sender: UIButton) {
        loadVoltSDK()
    }

    func createVoltInstance() {
        if partnerPlatformTextField.text?.count ?? 0 > 0 {
            let appKey = "volt-sdk-staging@voltmoney.in"
            let appSecret = "e10b6eaf2e334d1b955434e25fcfe2d8"
            let ref = refTextField.text ?? ""
            let primaryColor = primaryColorTextField.text ?? ""
            let secondaryColor = secondaryColorTextField.text ?? ""
            let partnerPlatform = partnerPlatformTextField.text ?? ""

            let voltInstance = VoltInstance(app_key: appKey, app_secret: appSecret, partner_platform: partnerPlatform, primary_color: primaryColor, secondary_color: secondaryColor, ref: ref)
            voltSDKInstance = VoltSDKContainer(voltInstance: voltInstance)
            self.showAlert(message: "Instance Created.")
        } else {
            self.showAlert(message: "Please provide Platform")
        }
    }

    func createApplication() {
        let dob = dobTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let panNumber = panNumberTextField.text ?? ""
        let mobileNumber = mobileTextField.text ?? ""

        VoltSDKContainer.preCreateApplication(dob: dob, email: email, panNumber: panNumber, mobileNumber: Int(mobileNumber) ?? +9100000000) { [weak self] response in
            self?.hideProgressBar()
            if response?.customerAccountId != nil {
                self?.showAlert(message: "Application Created.")
            } else {
                self?.showAlert(message: response?.message ?? "")
            }
        }
    }

    private func loadVoltSDK() {
        if voltSDKInstance != nil {
            let controller = VoltHomeViewController(mobileNumber: mobileTextField.text ?? "")
            self.navigationController?.pushViewController(controller, animated: false)
        } else {
            self.showAlert(message: "Please create Volt Instance.")
        }
    }

}


