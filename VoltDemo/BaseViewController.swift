//
//  BaseViewController.swift
//  QantasDemoApp
//
//  Created by 
//

import UIKit

public class BaseViewController: UIViewController {

    private var indicator: UIActivityIndicatorView?

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    func showProgressBar() {
        DispatchQueue.main.async {
            self.indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            self.indicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.indicator?.center = self.view.center
            self.indicator?.color = .gray
            self.view.addSubview(self.indicator!)
            self.view.bringSubviewToFront(self.indicator!)
            self.view.isUserInteractionEnabled = false
            self.indicator?.startAnimating()
        }
    }

    func hideProgressBar(){
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.indicator?.stopAnimating()
        }
    }

    func showAlert(message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
