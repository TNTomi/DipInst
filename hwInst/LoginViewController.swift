
//
//  LoginViewController.swift
//  hwInst
//
//  Created by Артём Горовой on 9.01.25.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    private let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
    
    private let passwordKey = "userPassword"
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.isHidden = true
        return textField
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        let action = UIAction {_ in
            self.handleActionButtonTap()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureForFirstLaunch()
        view.addGestureRecognizer(recognizer)
    }
    
    private func setupUI() {
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(actionButton)
        view.addSubview(errorLabel)
        view.addGestureRecognizer(recognizer)
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(passwordTextField)
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(40)
            make.width.equalTo(passwordTextField)
            make.height.equalTo(50)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(actionButton.snp.bottom).offset(20)
            make.width.equalTo(passwordTextField)
        }
    }
    
    private func configureForFirstLaunch() {
        if UserDefaults.standard.string(forKey: passwordKey) == nil {
            confirmPasswordTextField.isHidden = false
            actionButton.setTitle("Set Password", for: .normal)
        } else {
            confirmPasswordTextField.isHidden = true
            actionButton.setTitle("Login", for: .normal)
        }
    }
    
    private func handleActionButtonTap() {
        let password = passwordTextField.text ?? ""
        
        if confirmPasswordTextField.isHidden {
            validatePassword(password: password)
        } else {
            let confirmPassword = confirmPasswordTextField.text ?? ""
            setPassword(password: password, confirmPassword: confirmPassword)
        }
    }
    
    private func setPassword(password: String, confirmPassword: String) {
        guard !password.isEmpty, !confirmPassword.isEmpty else {
            showError("Enter and confirm your password.")
            return
        }
        guard password == confirmPassword else {
            showError("Passwords do not match.")
            return
        }
        
        UserDefaults.standard.set(password, forKey: passwordKey)
        confirmPasswordTextField.isHidden = true
        actionButton.setTitle("Login", for: .normal)
        errorLabel.isHidden = true
        passwordTextField.text = ""
        showAlert("Password set successfully!")
    }
    
    private func validatePassword(password: String) {
        let savedPassword = UserDefaults.standard.string(forKey: passwordKey)
        if password == savedPassword {
            errorLabel.isHidden = true
            navigateToNextScreen()
        } else {
            showError("Wrong password")
        }
    }
    
    private func navigateToNextScreen() {
        let nextScreen = FirstScreen()
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func tapDetected() {
        view.endEditing(true)
    }
}
/*
 func clearUserDefaults() {
 if let appDomain = Bundle.main.bundleIdentifier {
 UserDefaults.standard.removePersistentDomain(forName: appDomain)
 UserDefaults.standard.synchronize()
 print("UserDefaults has been cleared.")
 }
 }
 */

