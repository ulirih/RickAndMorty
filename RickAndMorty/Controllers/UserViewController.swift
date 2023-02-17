//
//  UserViewController.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 17.02.2023.
//

import UIKit
import SnapKit
import Combine

class UserViewController: UIViewController {
    
    var viewModel: UserViewModelProtocol!
    
    private var cancellable: [AnyCancellable] = []
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(userImage)
        view.addSubview(userNameLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(logoutButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        setupBindings()
        
        viewModel.fetchData()
    }
    
    private func setupBindings() {
        viewModel.user
            .sink { [unowned self] user in
                self.title = user.name
                self.userNameLabel.text = user.name
                self.userEmailLabel.text = user.email
            }
            .store(in: &cancellable)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    @objc
    private func didTapLogout() {
        viewModel.logout()
    }
    
    private func setupConstraints() {
        userImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(50)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(userImage.snp.trailing).offset(12)
        }
        
        userEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(userImage.snp.trailing).offset(12)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(45)
        }
    }
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let userImage: UIImageView = {
        let image = UIImageView(
            image: UIImage(systemName: "person.circle.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        )
        return image
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        return button
    }()

}
