//
//  RegistrationView.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//

import UIKit

final class RegistrationView: UIView {
    
    private(set) var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) lazy var firstNameTextField: UITextField = {
        return makeTextFildView(placeholder: "First Name")
    }()

    private(set) lazy var lastNameTextField: UITextField = {
        return makeTextFildView(placeholder: "Last Name")
    }()
    
    private(set) lazy var emailTextField: UITextField = {
        return makeTextFildView(placeholder: "e-mail", keyboardType: .emailAddress)
    }()

    private(set) lazy var loginTextField: UITextField = {
        return makeTextFildView(placeholder: "Login")
    }()

    private(set) lazy var passwordTextField: UITextField = {
        let textField = makeTextFildView(placeholder: "Password")
        textField.isSecureTextEntry = true
        textField.textContentType = .init(rawValue: "")
        return textField
    }()
    
    private(set) lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        button.setTitle("Registration", for: .normal)
        return button
    }()
    
    private let registrationButtonSize = CGSize(width: 200, height: 40)
    private let registrationButtonPadding = UIEdgeInsets(top: .zero, left: .zero, bottom: 15, right: .zero)
    private let textFieldPadding = UIEdgeInsets(top: 7, left: 40, bottom: 7, right: 40)
    private let textFieldSize = CGSize(width: .zero, height: 40)

    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Content
    //
    private func configureContent() {
        self.backgroundColor = .systemGray6
        self.addSubview(scrollView)

        scrollView.addSubview(contentView)
        
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(registrationButton)
        
        placesConstraint()
    }
    
    private func placesConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            firstNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textFieldPadding.top * 2),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.left),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.right),
            firstNameTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: textFieldPadding.top),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.left),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.right),
            lastNameTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: textFieldPadding.top * 4),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.left),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.right),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            loginTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldPadding.top * 2),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.left),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.right),
            loginTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: textFieldPadding.top),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.left),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.right),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.widthAnchor.constraint(equalToConstant: registrationButtonSize.width),
            registrationButton.heightAnchor.constraint(equalToConstant: registrationButtonSize.height),
            registrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -registrationButtonPadding.bottom)
        ])
    }
    
    private func makeTextFildView(placeholder: String, keyboardType: UIKeyboardType = .asciiCapable) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .left
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.placeholder = placeholder
        return textField
    }
}
