//
//  LoginViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import Foundation
import UIKit

class LoginViewModel: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties
    
    weak var delegate: LoginViewModelDelegate?
    
    // MARK: - Initialization
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Validation
    
    func validateText(username: String, password: String) {
        // Check if either username or password is empty
        if username.isEmpty || password.isEmpty {
            delegate?.showAlert(title: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
        }
        // Check if the username is incorrect
        else if username != "shadyadel" {
            delegate?.showAlert(title: "Username is incorrect")
        }
        // Check if the password is incorrect
        else if password != "1234" {
            delegate?.showAlert(title: "Password is incorrect")
        }
        // Login successful
        else {
            delegate?.loginSuccessful()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
