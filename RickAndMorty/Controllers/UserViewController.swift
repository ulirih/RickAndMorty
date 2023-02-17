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
    private var favorites: [FavoriteEntity] = []
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(userImage)
        view.addSubview(userNameLabel)
        view.addSubview(userEmailLabel)
        view.addSubview(logoutButton)
        view.addSubview(collectionView)
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
        
        viewModel.favorites
            .sink { [unowned self] favorites in
                collectionView.backgroundView = favorites.isEmpty ? self.emptyListLabel : nil
                self.favorites = favorites
                self.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(logoutButton.snp.top).offset(-16)
        }
    }
    
    private let collectionView: UICollectionView = {
        let header = UILabel()
        header.text = "hfdjhk"
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CharacterFavoriteViewCell.self, forCellWithReuseIdentifier: CharacterFavoriteViewCell.reusableId)
        return collectionView
    }()
    
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
    
    private let emptyListLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.text = "Favorite list is empty"
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

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterFavoriteViewCell.reusableId, for: indexPath) as! CharacterFavoriteViewCell
        cell.configure(at: favorites[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 2) - 16 - 10
        let height = width * 1.2
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
