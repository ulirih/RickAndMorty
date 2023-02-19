//
//  RegistrationViewController.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import UIKit
import SnapKit
import Combine

class RegistrationViewController: UIViewController {
    
    var viewModel: RegistrationViewModelProtocol!
    
    @Published private var email = ""
    @Published private var password = ""
    @Published private var name = ""
    
    private var cancellable: [AnyCancellable] = []
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(logoImage)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nameTextField)
        view.addSubview(registrationButton)
        view.addSubview(errorLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObservingKeyboardAppears()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        
        registrationButton.addTarget(self, action: #selector(didTapRegistration), for: .touchUpInside)
    }
    
    @objc
    private func didTapRegistration() {
        viewModel.registration(email: email, password: password, name: name)
    }
    
    private func setupBindings() {
        emailTextField.textPublisher
            .sink { [unowned self] text in
                self.email = text
            }
            .store(in: &cancellable)
        
        passwordTextField.textPublisher
            .sink { [unowned self] text in
                self.password = text
            }
            .store(in: &cancellable)
        
        nameTextField.textPublisher
            .sink { [unowned self] text in
                self.name = text
            }
            .store(in: &cancellable)
        
        // validation
        Publishers.CombineLatest3($email, $password, $name)
            .sink { [unowned self] login, password, name in
                registrationButton.isEnabled = login.isValidEmail() && !password.isEmpty && !name.isEmpty
             }
            .store(in: &cancellable)
        
        viewModel.error
            .sink { [unowned self] errorText in
                self.errorLabel.text = errorText
            }
            .store(in: &cancellable)
    }
    
    private func startObservingKeyboardAppears() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        
        let textField = [nameTextField, passwordTextField, emailTextField].first { $0.isFirstResponder }
        guard let textField = textField else { return }
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let offset = textField.frame.height + 40 // + bottom padding
        let isHidedTextField = (view.frame.height - keyboardFrame.height - offset) < textField.frame.origin.y
        
        if isHidedTextField {
            self.view.frame.origin.y = -offset
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.4)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(-34)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.height.equalTo(46)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    
    // MARK: Views
    private let emailTextField: RMTextField = {
        let field = RMTextField(labelText: "Email")
        field.keyboardType = .emailAddress
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        return field
    }()
    
    private let passwordTextField: RMTextField = {
        let field = RMTextField(labelText: "Password")
        field.keyboardType = .default
        field.isSecureTextEntry = true
        field.borderStyle = .roundedRect
        return field
    }()
    
    private let nameTextField: RMTextField = {
        let field = RMTextField(labelText: "Name")
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        return field
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Registration", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let logoImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "RegistrationLogoRickMorty"))
        return img
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    deinit {
        print("deinit")
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
