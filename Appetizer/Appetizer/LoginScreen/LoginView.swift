//
//  LoginView.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

protocol LoginViewModelDelegate: AnyObject {
    func loginSuccessful()
    func showAlert(title: String)
}

class LoginView: UIViewController {
    
    private var loginVM: LoginViewModel!
    
    // Username text field
    @IBOutlet var usernameTextField: UITextField! {
        didSet {
            usernameTextField.tag = 1
            usernameTextField.becomeFirstResponder() // Set the username text field as the first responder
        }
        
    }
    
    // Password text field
    @IBOutlet var passwordTextField: UITextField! {
        didSet {
            passwordTextField.tag = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
    }
    
    private func configureViewModel() {
        loginVM = LoginViewModel(delegate: self)
        usernameTextField.delegate = loginVM
        passwordTextField.delegate = loginVM
    }
    
    // Login button action Validate the username and password
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        loginVM.validateText(username: username, password: password)
    }
}

extension LoginView: LoginViewModelDelegate {
    // Delegate method called when login is successful
    func loginSuccessful() {
        navigationController?.popViewController(animated: true) // Pop the current view controller from the navigation stack
        UserDefaults.standard.set(true, forKey: "loggedIn") // Set the "loggedIn" flag in UserDefaults to true
    }
    
    // Delegate method called to show an alert
    func showAlert(title: String) {
        let alertController = UIAlertController(title: "Oops", message: title, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
