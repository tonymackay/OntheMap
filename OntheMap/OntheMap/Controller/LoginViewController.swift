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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    
    let segueIdentifier = "loggedInSegue"
    
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
            OTMClient.getUserData(completion: handleGetUserData(userData:error:))
        } else {
            showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
            setLoggingIn(false)
            clearTextFields()
        }
    }
    
    func handleGetUserData(userData: UserDataResponse?, error: Error?) {
        if let userData = userData {
            OTMModel.isAuthenticated = true
            OTMClient.Auth.firstName = userData.firstName
            OTMClient.Auth.lastName = userData.lastName
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        } else {
            if let error = error {
                print(error)
                showAlert(title: "UserData Error", message: error.localizedDescription)
            }
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
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
}
