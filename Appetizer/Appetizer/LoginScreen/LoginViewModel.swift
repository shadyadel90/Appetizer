//
//  LoginViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import Foundation
import UIKit

class LoginViewModel {
    
    lazy var loginView: LoginView = {
        return LoginView()
    }()
    
    //validate text
    func validateText(username: String, password: String){
        if username == "" || password == ""
        {
            loginView.showAlert(title: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
        }
        else if  username != "shadyadel" {
            loginView.showAlert(title: "username is incorrect")
        }
        else if password != "1234" {
            loginView.showAlert(title: "password is incorrect")
        }
        else {
            loginView.unwindToHomeViewController()
        }
    }
    
}
