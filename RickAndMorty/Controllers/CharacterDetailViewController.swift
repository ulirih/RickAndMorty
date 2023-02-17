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

        dataSource = configureDataSource()
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.detail, .alsoHeader, .also])
        dataSource.apply(snapshot)
        
        viewModel.fetchData()
    }
    
    private func setupBindings() {
        viewModel.detailCharacter
            .sink { character in
                var snapshot = self.dataSource.snapshot()
                snapshot.appendItems([.detail(character)], toSection: .detail)
                self.dataSource.apply(snapshot)
            }
            .store(in: &cancellable)
        
        viewModel.alsoCharacters
            .sink { [unowned self] characters in
                var snapshot = self.dataSource.snapshot()
                let ar = characters.shuffled().map { model in
                    return CharacterDetailListRow.also(model)
                }
                snapshot.appendItems([.alsoHeader("See also characters")], toSection: .alsoHeader)
                snapshot.appendItems(ar, toSection: .also)
                self.dataSource.apply(snapshot)
            }
            .store(in: &cancellable)
        
        viewModel.isLoading
            .sink { [unowned self] isLoading in
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellable)
        
        viewModel.error
            .sink { [unowned self] error in
                self.showAlertError(message: error.getDefaultTextError())
            }
            .store(in: &cancellable)
        
        viewModel.isFavorite
            .sink { [unowned self] isFavorite in
                navigationItem.rightBarButtonItem?.image = UIImage(
                    systemName: isFavorite ? "heart.fill" : "heart"
                )?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
            }
            .store(in: &cancellable)
    }
    
    private func setupViews() {
        title = character.name
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "heart")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapFavorite)
        )
        navigationItem.rightBarButtonItem = rightBarButton
        
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    @objc
    private func didTapFavorite() {
        viewModel.toggleFavorite(character: character)
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
                
            case .alsoHeader(let headerTitle):
                let cell = tableView.dequeueReusableCell(withIdentifier: CharacterHeaderViewCell.reusableId, for: indexPath) as! CharacterHeaderViewCell
                cell.titleLabel.text = headerTitle
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
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.register(CharacterViewCell.self, forCellReuseIdentifier: CharacterViewCell.reusableId)
        table.register(CharacterDetailViewCell.self, forCellReuseIdentifier: CharacterDetailViewCell.reusableId)
        table.register(CharacterHeaderViewCell.self, forCellReuseIdentifier: CharacterHeaderViewCell.reusableId)
        
        return table
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        return indicator
    }()
    
    enum CharacterDetailListSection: Int, Hashable {
        case detail
        case alsoHeader
        case also
    }
    
    enum CharacterDetailListRow: Hashable {
        case detail(CharacterModel)
        case alsoHeader(String)
        case also(CharacterModel)
    }
    
    deinit {
        print("deinit")
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
