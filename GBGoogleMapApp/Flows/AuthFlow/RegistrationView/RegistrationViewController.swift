//
//  RegistrationViewController.swift
//  GBGoogleMapApp
//
//  Created by Владимир on 04.04.2022.
//


import UIKit

final class RegistrationViewController: UIViewController {

    private var registrationView: RegistrationView {
        guard let view = self.view as? RegistrationView else {
            return RegistrationView(frame: self.view.frame)
        }
        return view
    }
    
    private var spinner: LoadingScreenWithSpinner?
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("Back", for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        button.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        button.sizeToFit()
        
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()


    private weak var viewModel: RegistrationViewModel?
    
    var refresh: AuthRefreshActions = .initiation {
        didSet {
            switch refresh {
            case .initiation:
                spinner?.hide()
            case .loading:
                spinner?.show()
            case .success:
                spinner?.hide()
            case .failure(let message):
                showAlert(title: "Wrong", message: message, actionTitle: "Cancel") {
                    self.refresh = .initiation
                }
            }
        }
    }
    
    
    
    // MARK: - Initialization
    //
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("♻️\tDeinit RegistrationViewController")
    }
    
    
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configuration()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.refresh = { [weak self] action in
            guard let self = self else { return }
            self.refresh = action
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notifiction.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notifiction.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    
    
    // MARK: - Configure Content
    //
    private func configuration() {
        self.view = RegistrationView(frame: self.view.frame)
        spinner = LoadingScreenWithSpinner(view: registrationView)
        
//        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.title = "Registration"
        
        registrationView.scrollView.addGestureRecognizer(keyboardHideGesture)
        registrationView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
    }
}



// MARK: - Extension Button Actions
//
extension RegistrationViewController {
    
    @objc
    private func pressedRegistrationButton(_ sender: UIButton) {
        guard let firstName = registrationView.firstNameTextField.text,
              let lastName = registrationView.lastNameTextField.text,
              let email = registrationView.emailTextField.text,
              let login = registrationView.loginTextField.text,
              let password = registrationView.passwordTextField.text else {
                  showAlert(title: "Error", message: "Not all fields are filled in", actionTitle: "Сancel")
                  return
              }
        viewModel?.registretion(firstName: firstName, lastName: lastName, email: email, login: login, password: password)
    }
    
    @objc
    private func pressedBackButton(_ sender: UIBarButtonItem) {
        viewModel?.login()
    }
}


// MARK: - Extension Keyboard Actions
//
extension RegistrationViewController {

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = registrationView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        registrationView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        registrationView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardHide(_ sender: Any?) {
        registrationView.scrollView.endEditing(true)
    }
}
