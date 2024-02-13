//
//  RegisterController.swift
//  ToDoList
//
//  Created by Илья Лотник on 15.01.2024.
//

import UIKit

class RegisterController: UIViewController {
    
    // MARK: - UI Components
    private let headerView = AuthHeaderView(title: Constants.registrationHeaderTitle, subTitle: Constants.registrationHeaderSubTitle)
    
    private let usernameField = CustomTextField(fieldType: .username)
    private let emailField = CustomTextField(fieldType: .email)
    private let passwordField = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: Constants.registrationSignUpButtonTitle, hasBackground: true, fontSize: .big)
    private let signInButton = CustomButton(title: Constants.registrationSignInButtonTitle, fontSize: .med)
    
    private let termsTextView: UITextView = {
        
        
        let attributedString = NSMutableAttributedString(string: Constants.registrationTermsTextViewLiteral)
        
        attributedString.addAttribute(.link, value: Constants.registrationTermsTextViewTermsAndConditionsLinkLiteral, range: (attributedString.string as NSString).range(of: Constants.registrationTermsTextViewTermsAndConditionsLinkPositionLiteral))
        
        attributedString.addAttribute(.link, value: Constants.registrationTermsTextViewPrivacyPolicyLinkLiteral, range: (attributedString.string as NSString).range(of: Constants.registrationTermsTextViewPrivacyPolicyLinkPositionLiteral))
        
        let tv = UITextView()
        tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        tv.backgroundColor = .clear
        tv.attributedText = attributedString
        tv.textColor = .label
        tv.isSelectable = true
        tv.isEditable = false
        tv.delaysContentTouches = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.termsTextView.delegate = self
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUpPressed), for: .touchDown)
        self.signUpButton.addTarget(self, action: #selector(didTapSignUpReleased), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
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
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signUpButton)
        self.view.addSubview(termsTextView)
        self.view.addSubview(signInButton)
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.usernameField.translatesAutoresizingMaskIntoConstraints = false
        self.emailField.translatesAutoresizingMaskIntoConstraints = false
        self.passwordField.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.usernameField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 55),
            self.usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 22),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.termsTextView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 6),
            self.termsTextView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: termsTextView.bottomAnchor, constant: 11),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 44),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    
    // MARK: - Selectors
    @objc func didTapSignUpPressed(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }
    }
    
    @objc func didTapSignUpReleased(sender: UIButton) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                sender.transform = .identity
            }
        }
        
        let userRequest = RegisterUserRequest(
            email: self.emailField.text ?? "",
            username: self.usernameField.text ?? "",
            password: self.passwordField.text ?? "")
               
        // Username check
        if !Validator.isValidUsername(for: userRequest.username) {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
        
        // Email check
        if !Validator.isValidEmail(for: userRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: userRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        guard let request = Endpoint.createAccount(userRequest: userRequest).request else { return }
        
        AuthService.fetch(request: request) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(_):
                    
                    User.shared.initData(username: userRequest.username, password: userRequest.password, inputEmail: userRequest.email)
                    
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        sceneDelegate.checkAuthentication()
                    }
                    
                    
                case .failure(let error):
                    guard let error = error as? ServiceError else { return }
                    
                    switch error {
                        
                    case .serverError(let string),
                            .unknown(let string),
                            .decodingError(let string):
                        AlertManager.showRegistrationErrorAlert(on: self, with: string)
                    }
                }
            }
        }
    }
    
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension RegisterController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == Constants.registrationTermsTextViewTermsAndConditionsURLScheme {
            self.showWebViewerController(with: Constants.registrationTermsTextViewTermsAndConditionsURL)
        } else if URL.scheme == Constants.registrationTermsTextViewPrivacyPolicyURLScheme {
            self.showWebViewerController(with: Constants.registrationTermsTextViewPrivacyPolicyURL)
        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
