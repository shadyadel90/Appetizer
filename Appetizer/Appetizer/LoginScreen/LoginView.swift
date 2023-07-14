//
//  LoginView.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class LoginView: UIViewController,UITextFieldDelegate {
    
    lazy var loginVM : LoginViewModel = {
        return LoginViewModel()
    }()
    
    @IBOutlet var UsernameTextField: UITextField! {
        didSet {
            UsernameTextField.tag = 1
            UsernameTextField.becomeFirstResponder()
            UsernameTextField.delegate = self
        }
    }
    
    @IBOutlet var PasswordTextField: UITextField! {
        didSet {
            PasswordTextField.tag = 2
            PasswordTextField.delegate = self
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let username = UsernameTextField.text
        let password = PasswordTextField.text
        validateText(username: username!, password: password!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //junmp to the next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    //MARK: Text Validating
    func validateText(username: String, password: String){
        if username == "" || password == ""
        {
            showAlert(title: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
        }
        else if username != "shadyadel" {
            showAlert(title: "username is incorrect")
        }
        else if password != "1234" {
            showAlert(title: "password is incorrect")
        }
        else {
            unwindToHomeViewController()
        }
    }
    
    //MARK: Unwind Segue
    func unwindToHomeViewController() {
        if let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as? RecipeListView {
            navigationController?.setViewControllers([homeViewController], animated: true)
        }
    }
    
    //MARK: Show Alert
    func showAlert(title: String){
        let alertController = UIAlertController(title: "Oops", message: title, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
        

