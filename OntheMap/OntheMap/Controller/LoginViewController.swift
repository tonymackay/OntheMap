//
//  LoginViewController.swift
//  OntheMap
//
//  Created by Tony Mackay on 28/04/2020.
//  Copyright © 2020 ViewModel Software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions

    @IBAction func loginTapped(_ sender: Any) {
        setLoggingIn(true)
        OTMClient.login(email: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    // MARK: Private Methods
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OTMModel.isAuthenticated = true
            dismiss(animated: true, completion: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            setLoggingIn(false)
            clearTextFields()
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            //activityIndicator.startAnimating()
        } else {
            //activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.becomeFirstResponder()
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
