//
//  DetailViewController.swift
//  UCLSeminar
//
//  Created by Berat Cevik on 08/10/2023.
//

import UIKit

final class DetailViewController: UIViewController {

    private let viewModel: DetailViewModelProtocol

    private let imageView: UIImageView = {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.label.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    private let symbolLabel: UILabel = {
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    private let priceLabel: UILabel = {
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    private let favoriteButton: UIButton = {
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 24
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())

    init(stockID: String) {
        viewModel = DetailViewModel(
            stockID: stockID,
            stocksService: StocksService()
        )

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

private extension DetailViewController {

    func configureViews() {
        view.backgroundColor = .secondarySystemBackground

        view.addSubview(imageView)
        view.addSubview(symbolLabel)
        view.addSubview(priceLabel)
        view.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 48),
            imageView.widthAnchor.constraint(equalToConstant: 48)
        ])

        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            symbolLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            symbolLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            favoriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        favoriteButton.addTarget(self, action: #selector(favoriteButtonDidTap), for: .touchUpInside)
    }

    func configureBindings() {
        viewModel.bind(viewStateHandler: { [weak self] viewState in
            self?.navigationItem.title = viewState.title
            self?.imageView.kf.setImage(with: viewState.imageUrl)
            self?.symbolLabel.text = viewState.symbol
            self?.priceLabel.text = viewState.price
            self?.priceLabel.textColor = viewState.priceColor
            self?.favoriteButton.setTitle(viewState.favoriteButtonTitle, for: .normal)
        })
    }

    @objc
    func favoriteButtonDidTap() {
        viewModel.favoriteAction()
    }

}
