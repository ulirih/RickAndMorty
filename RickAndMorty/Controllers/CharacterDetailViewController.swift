//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 14.02.2023.
//

import UIKit
import Combine

class CharacterDetailViewController: UIViewController {
    
    var character: CharacterModel!
    var viewModel: CharacterDetailViewModelProtocol!
    
    private var dataSource: UITableViewDiffableDataSource<CharacterDetailListSection, CharacterDetailListRow>!
    private var cancellable: [AnyCancellable] = []
    
    override func loadView() {
        super.loadView()
        
        setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupBindings()
        
        viewModel.fetchAlsoCharacters()

        dataSource = configureDataSource()
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.detail, .also])
        snapshot.appendItems([.detail(character)], toSection: .detail)
        dataSource.apply(snapshot)

    }
    
    private func setupBindings() {
        viewModel.alsoCharacters
            .sink { _ in
                
            } receiveValue: { [unowned self] characters in
                var snapshot = self.dataSource.snapshot()
                let ar = characters.shuffled().map { model in
                    return CharacterDetailListRow.also(model)
                }
                snapshot.appendItems(ar, toSection: .also)
                self.dataSource.apply(snapshot)
            }
            .store(in: &cancellable)
        
        viewModel.isLoading
            .sink { [unowned self] isLoading in
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellable)
    }
    
    private func setupViews() {
        title = character.name
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
    }
    
    private func configureDataSource() -> UITableViewDiffableDataSource<CharacterDetailListSection, CharacterDetailListRow> {
        let dataSource = UITableViewDiffableDataSource<CharacterDetailListSection, CharacterDetailListRow>(tableView: tableView) {
            tableView, indexPath, item in
            
            switch item {
            case .detail(let characterModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailViewCell.reusableId, for: indexPath) as! CharacterDetailViewCell
                cell.configure(model: characterModel)
                cell.isUserInteractionEnabled = false
                return cell
                
            case .also(let characterModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: CharacterViewCell.reusableId, for: indexPath) as! CharacterViewCell
                cell.configure(model: characterModel)
                cell.contentView.layer.masksToBounds = true
                return cell
            }
        }
        
        return dataSource
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.register(CharacterViewCell.self, forCellReuseIdentifier: CharacterViewCell.reusableId)
        table.register(CharacterDetailViewCell.self, forCellReuseIdentifier: CharacterDetailViewCell.reusableId)
        
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        return indicator
    }()
    
    enum CharacterDetailListSection: Hashable {
        case detail
        case also
    }
    
    enum CharacterDetailListRow: Hashable {
        case detail(CharacterModel)
        case also(CharacterModel)
    }
    
    deinit {
        print("dealloc")
    }
}

// MARK: TableView Delegate
extension CharacterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if case .also(let character) = dataSource.itemIdentifier(for: indexPath) {
            viewModel.didSelectCharacter(character: character)
        }
    }
}
