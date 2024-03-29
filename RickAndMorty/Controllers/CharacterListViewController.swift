//
//  ViewController.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 13.02.2023.
//

import UIKit
import Combine
import SnapKit

class CharactersListViewController: UIViewController {
    
    var viewModel: CharactersListViewModelProtocol!
    
    private var cancellable: [AnyCancellable] = []
    private var dataSource: UITableViewDiffableDataSource<CharacterListSection, CharacterModel>!
    
    override func loadView() {
        super.loadView()
        
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = configureDataSource()
        
        setupConstraints()
        setupBindings()
        
        viewModel.fetchCharacters()
    }
    
    private func setupView() {
        title = "Rick and Morty"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "person.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupBindings() {
        viewModel.isLoading
            .sink { [unowned self] isLoading in
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellable)
        
        viewModel.characters
            .sink { [unowned self] characters in
                var snapshot = self.dataSource.snapshot()
                if !snapshot.sectionIdentifiers.contains(.characters) {
                    snapshot.appendSections([.characters])
                }
                snapshot.appendItems(characters, toSection: .characters)
                dataSource.apply(snapshot)
            }
            .store(in: &cancellable)
        
        viewModel.error
            .sink { [unowned self] error in
                self.showAlertError(message: error.getDefaultTextError())
            }
            .store(in: &cancellable)
    }
    
    private func configureDataSource() -> UITableViewDiffableDataSource<CharacterListSection, CharacterModel> {
        let dataSource = UITableViewDiffableDataSource<CharacterListSection, CharacterModel>(tableView: tableView) {
            [unowned self] tableView, indexPath, model in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterViewCell.reusableId, for: indexPath) as! CharacterViewCell
            cell.configure(model: model)
            cell.contentView.layer.masksToBounds = true
            
            if tableView.numberOfRows(inSection: indexPath.section) == indexPath.row + 1 {
                self.viewModel.fetchCharacters()
            }
            
            return cell
        }
        
        return dataSource
    }
    
    @objc
    private func didTapProfile() {
        viewModel.didTapProfile()
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        return indicator
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(CharacterViewCell.self, forCellReuseIdentifier: CharacterViewCell.reusableId)
        return table
    }()
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.trailing.leading.equalTo(view)
        }
    }
    
    enum CharacterListSection: Hashable {
        case characters
    }
}

extension CharactersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectCharacter(character: dataSource.itemIdentifier(for: indexPath)!)
    }
}

