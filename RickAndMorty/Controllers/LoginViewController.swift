//
//  LoginViewController.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import UIKit
import SnapKit
import Combine

class LoginViewController: UIViewController {
    private var cancellable: [AnyCancellable] = []
    
    @Published private var login = ""
    @Published private var password = ""
    
    var viewModel: LoginViewModelProtocol!
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(logoImage)
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registrationButton)
        view.addSubview(errorLabel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
        setupBindings()
    }
    
    private func setupBindings() {
        loginTextField.textPublisher
            .sink { [unowned self] text in
                self.login = text
            }
            .store(in: &cancellable)
        
        passwordTextField.textPublisher
            .sink { [unowned self] text in
                self.password = text
            }
            .store(in: &cancellable)
        
        // validation
        Publishers.CombineLatest($login, $password)
            .sink { [unowned self] login, password in
                loginButton.isEnabled = login.isValidEmail() && !password.isEmpty
             }
            .store(in: &cancellable)
        
        viewModel.error
            .sink { [unowned self] errorMessage in
                self.errorLabel.text = errorMessage
            }
            .store(in: &cancellable)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        registrationButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
    }
    
    @objc
    private func didTapLogin() {
        viewModel.signIn(login: login, pasword: password)
    }
    
    @objc
    private func didTapRegister() {
        viewModel.goToRegistration()
    }
    
    private func setupConstraints() {
        logoImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.height.equalTo(160)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        registrationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(registrationButton.snp.top).offset(-18)
            make.height.equalTo(46)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private let loginTextField: RMTextField = {
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
    
    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "LogoRickMorty"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let registrationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Registration", for: .normal)
        button.setTitleColor(UIColor.systemCyan, for: .normal)
        button.setTitleColor(UIColor.systemCyan.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
