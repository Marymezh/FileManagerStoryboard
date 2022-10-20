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
    case changePassword
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    private let password = Password()
    
    var mode: Mode?

    private var screenTitle: String {
        switch mode {
        case .createPassword:
            return "Registration"
        case .confirmPassword:
            return "Confirmation"
        case .signIn:
            return "Sign in"
        case .changePassword:
            return "Enter new password"
        default:
            return ""
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
        case .changePassword:
            return "Set new password"
        default:
            return ""
        }
    }
    
    private var textFieldPlaceHolder: String {
        switch mode {
        case .createPassword,
                .changePassword:
            return "Please enter password"
        case .confirmPassword:
            return "Please re-enter your password"
        case .signIn:
            return "Enter your password"
        default:
            return ""
        }
    }
    
    private var passwordInput: String = ""
    private var initialPasswordInput: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setLoginMode()
        setupUI()
    }
    
    private func setLoginMode() {
        if mode == nil {
            if password.isSet {
                mode = .signIn
            } else {
                mode = .createPassword
            }
        }
    }
    
    private func setupUI () {
        titleLabel.text = screenTitle
        titleLabel.textColor = .purple
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.layer.shadowRadius = 6
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowOffset = CGSize(width: 7, height: 7)
        
        passwordTextField.placeholder = textFieldPlaceHolder
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.borderWidth = 0.2
        passwordTextField.layer.borderColor = UIColor.purple.cgColor
        passwordTextField.layer.shadowRadius = 6
        passwordTextField.layer.shadowOpacity = 0.7
        passwordTextField.layer.shadowOffset = CGSize(width: 7, height: 7)
        
        button.setTitle(buttonTitle, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 0.1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.shadowRadius = 6
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 7, height: 7)
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
            setupUI()

        case .confirmPassword:
            passwordInput = entry
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
                showErrorAlert(text: "Password is not matching! Start all over again.")
                passwordInput = ""
                initialPasswordInput = ""
                passwordTextField.text = ""
                mode = .createPassword
                setupUI()
                return
            }
            
        case .signIn:
            passwordInput = entry
            guard password.isValid(passwordInput) else {
                showErrorAlert(text: "Wrong password! Access is denied! Try again")
                passwordTextField.text = ""
                return
            }
            performLogin()
            return
            
        case .changePassword:
            initialPasswordInput = entry
            passwordTextField.text = ""
            mode = .confirmPassword
            setupUI()
            return
            
        default:
            return
        }
    }
    
    private func performLogin() {
        if navigationController == nil {
            self.dismiss(animated: true)
            return
        } else {
        let tabBarVC = (storyboard?.instantiateViewController(withIdentifier: "TabBarVC")) as! TabBarController
        navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    
    private func showErrorAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
