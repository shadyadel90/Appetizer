//
//  LoginViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import Foundation
import UIKit

class LoginViewModel: NSObject, UITextFieldDelegate {
    
    weak var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate) {
        self.delegate = delegate
    }
    
    func validateText(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            delegate?.showAlert(title: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
        } else if username != "shadyadel" {
            delegate?.showAlert(title: "Username is incorrect")
        } else if password != "1234" {
            delegate?.showAlert(title: "Password is incorrect")
        } else {
            delegate?.loginSuccessful()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
