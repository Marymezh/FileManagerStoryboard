//
//  LoginViewController.swift
//  FileManagerStoryboard
//
//  Created by Мария Межова on 11.09.2022.
//

import UIKit

enum Mode {
    case createPassword
    case confirmPassword
    case signIn
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    private let password = Password()
    
    private var mode: Mode = .createPassword {
        didSet {
            titleLabel.text = screenTitle
            button.setTitle(buttonTitle, for: .normal)
            passwordTextField.placeholder = textFieldPlaceHolder
        }
    }
    
    private var originalMode: Mode = .createPassword
    
    private var screenTitle: String {
        switch mode {
        case .createPassword,
                .confirmPassword:
            return "Registration"
        case .signIn:
            return "Sign in"
        }
    }
    
    private var buttonTitle: String {
        switch mode {
        case .createPassword:
            return "Create password"
        case .confirmPassword:
            return "Confirm password"
        case .signIn:
            return "Login"
        }
    }
    
    private var textFieldPlaceHolder: String {
        switch mode {
        case .createPassword:
            return "Please enter password"
        case .confirmPassword:
            return "Please re-enter your password"
        case .signIn:
            return "Enter your password"
        }
    }
    
    private var passwordInput: String = ""
    private var initialPasswordInput: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoginMode()
        
    }
    
    private func setLoginMode() {
        if password.isSet {
            mode = .signIn
            print(password.isSet)
        } else {
            mode = .createPassword
            print(password.isSet)
        }
    }
    
    @IBAction func buttonIsTapped(_ sender: Any) {
        let entry = passwordTextField.text ?? ""
        
        guard entry != "" else {
            showErrorAlert(text: "Password is required!")
            return
        }
        
        guard entry.count > 3 else {
            passwordTextField.text = ""
            showErrorAlert(text: "Password should be at least 4 characters long!")
            return
        }
        
        switch mode {
        case .createPassword:
            initialPasswordInput = entry
            passwordTextField.text = ""
            mode = .confirmPassword

        case .confirmPassword:
            passwordInput = entry
            passwordTextField.placeholder = textFieldPlaceHolder
            if passwordInput == initialPasswordInput {
                password.save(passwordInput) { (success, error) in
                    guard success,
                          error == nil else {
                        if let error = error {
                            self.showErrorAlert(text: "\(error.localizedDescription)")
                        }
                        return
                    }
                    self.performLogin()
                }
            } else {
                showErrorAlert(text: "Password is not matching!")
                passwordInput = ""
                initialPasswordInput = ""
                passwordTextField.placeholder = textFieldPlaceHolder
                passwordTextField.text = ""
                mode = .createPassword
                return
            }
        case .signIn:
            passwordInput = entry
            passwordTextField.placeholder = textFieldPlaceHolder
            guard password.isValid(passwordInput) else {
                showErrorAlert(text: "Wrong password! Access is denied! Try again")
                passwordTextField.text = ""
                return
            }
            performLogin()
        }
    }
    
    private func performLogin() {
        let tableVC = storyboard?.instantiateViewController(withIdentifier: "TableVC") as! MyFoldersTableViewController
        navigationController?.pushViewController(tableVC, animated: true)
    }
    
    private func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}
