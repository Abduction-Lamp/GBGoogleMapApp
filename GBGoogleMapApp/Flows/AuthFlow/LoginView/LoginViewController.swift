//
//  LoginViewController.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 03.04.2022.
//

import UIKit

final class LoginViewController: UIViewController {

    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var loginView: LoginView {
        guard let view = self.view as? LoginView else {
            return LoginView(frame: self.view.frame)
        }
        return view
    }
    
    private let notification = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    

    //    private var spinner: LoadingScreenWithSpinner?
    
    
    
    var refresh: AuthRefreshActions = .initiation {
        didSet {
            switch refresh {
            case .initiation:
                break
            case .loading:
                break
            case .success:
                break
            case .failure(let message):
                showAlert(title: "Wrong", message: message, actionTitle: "Cancel") {
                    self.refresh = .initiation
                }
            }
        }
    }
    
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }

    override func viewDidLoad() {
        viewModel.refresh = { [weak self] action in
            guard let self = self else { return }
            self.refresh = action
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notification.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view = LoginView(frame: self.view.frame)

        loginView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        loginView.loginTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.loginButton.addTarget(self, action: #selector(pressedLoginButton), for: .touchUpInside)
        loginView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
        
        loginView.loginTextField.text = "Username"
        loginView.passwordTextField.text = "UserPassword"

//        spinner = LoadingScreenWithSpinner(view: loginView)
    }
}



// MARK: - Extension Button Actions
//
extension LoginViewController {
    
    @objc
    private func pressedLoginButton(_ sender: UIButton) {
        guard let login = loginView.loginTextField.text,
              let password = loginView.passwordTextField.text,
              !login.isEmpty,
              !password.isEmpty else { return }
        viewModel.login(login: login, password: password)
    }
    
    @objc
    private func pressedRegistrationButton(_ sender: UIButton) {
        viewModel.registretion()
    }
}



// MARK: - Extension TextField Delegate
//
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === loginView.loginTextField {
            textField.placeholder = "Login"
        } else {
            textField.placeholder = "Password"
        }
    }
}



// MARK: - Extension Keyboard Actions
//
extension LoginViewController {
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = loginView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        loginView.scrollView.contentInset = contentInset
        loginView.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        loginView.scrollView.contentInset = contentInset
        loginView.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc
    private func keyboardHide(_ sender: Any?) {
        loginView.scrollView.endEditing(true)
        if let button = sender as? UIButton,
           button === loginView.loginButton {
            pressedLoginButton(button)
        }
    }
}
