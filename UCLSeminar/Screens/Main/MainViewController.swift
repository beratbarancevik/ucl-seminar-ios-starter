//
//  MainViewController.swift
//  UCLSeminar
//
//  Created by Berat Cevik on 07/10/2023.
//

import UIKit

final class MainViewController: UIViewController {

    private let viewModel: MainViewModelProtocol

    private var stockRows: [StockCell.ViewState] = []

    private let tableView: UITableView = {
        $0.backgroundColor = .systemBackground
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(StockCell.self, forCellReuseIdentifier: StockCell.reuseIdentifier)
        return $0
    }(UITableView())

    init() {
        viewModel = MainViewModel(stocksService: StocksService())

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureBindings()
    }

}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stockRows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stockCell = tableView.dequeueReusableCell(
            withIdentifier: StockCell.reuseIdentifier
        ) as? StockCell else {
            return UITableViewCell()
        }
        stockCell.viewState = stockRows[indexPath.row]
        return stockCell
    }

}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(
            DetailViewController(stockID: stockRows[indexPath.row].id),
            animated: true
        )
    }

}


private extension MainViewController {

    func configureViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Stocks"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .init(systemName: "square.and.arrow.up"),
            style: .done,
            target: self,
            action: #selector(uploadDidTap)
        )

        view.backgroundColor = .systemBackground

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    func configureBindings() {
        viewModel.bind(viewStateHandler: { [weak self] viewState in
            self?.stockRows = viewState.rows
            self?.tableView.reloadData()
        })
    }

    @objc 
    func uploadDidTap() {
        viewModel.uploadAction()
    }

}
