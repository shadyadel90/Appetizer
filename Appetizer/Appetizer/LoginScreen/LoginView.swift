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
    
    @IBOutlet var usernameTextField: UITextField! {
        didSet {
            usernameTextField.tag = 1
            usernameTextField.becomeFirstResponder()
        }
        
    }
    
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
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        loginVM.validateText(username: username, password: password)
    }
}

extension LoginView: LoginViewModelDelegate {
    func loginSuccessful() {
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: "Oops", message: title, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
        

