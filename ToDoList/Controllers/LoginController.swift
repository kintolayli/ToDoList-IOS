//
//  LoginController.swift
//  ToDoList
//
//  Created by Илья Лотник on 15.01.2024.
//

import UIKit

class LoginController: UIViewController {

    
    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: Constants.logInHeaderTitle, subTitle: Constants.logInHeaderSubTitle)

    private let usernameField = CustomTextField(fieldType: .username)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signInButton = CustomButton(title: Constants.logInSignInButtonTitle, hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: Constants.logInNewUserButtonTitle, fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: Constants.logInForgotPasswordButtonTitle, fontSize: .small)
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignInPressed), for: .touchDown)
        self.signInButton.addTarget(self, action: #selector(didTapSignInReleased), for: .touchUpInside)
        
        
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
        
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(headerView)
        self.view.addSubview(usernameField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
        
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 55),
            self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 6),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
        ])
    }
    
    // MARK: - Selectors
    @objc func didTapSignInPressed(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    @objc private func didTapSignInReleased(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                sender.transform = .identity
            }
        }
        
        let userRequest = SignInUserRequest(
            username: self.usernameField.text ?? "",
            password: self.passwordField.text ?? "")
               
        // Username check
        if !Validator.isValidUsername(for: userRequest.username) {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: userRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        

        User.shared.initData(username: userRequest.username, password: userRequest.password, inputEmail: "")
        
        TokenManager.shared.requestAndSaveJWTToken(userRequest: userRequest) { statusCode in
            if statusCode == 200 {
                if User.shared.isAccessAllowed {
                    DispatchQueue.main.async {
                        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                            sceneDelegate.checkAuthentication()
                        }
                    }
                }
            } else {
                AlertManager.showUserDoesNotExist(on: self) { result in
                    if result {
                        DispatchQueue.main.async {
                            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                                sceneDelegate.checkAuthentication()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @objc private func didTapNewUser() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        let vc = ForgorPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
