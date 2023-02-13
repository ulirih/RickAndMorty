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
    
    private let viewModel = CharactersListViewModel(service: ApiService())
    private var cancellable: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Rick and Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        
        setupConstraints()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchCharacters()
    }
    
    private func setupBindings() {
        viewModel.isLoading
            .sink { [unowned self] isLoading in
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
            .store(in: &cancellable)
        
        viewModel.characters
            .sink { values in
                print(values.count)
            }
            .store(in: &cancellable)
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        return indicator
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            make.trailing.leading.equalTo(view)
        }
    }
}

