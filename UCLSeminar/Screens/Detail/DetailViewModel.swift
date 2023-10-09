//
//  DetailViewModel.swift
//  UCLSeminar
//
//  Created by Berat Cevik on 08/10/2023.
//

import Foundation

final class DetailViewModel: DetailViewModelProtocol {

    private let stockID: String
    private let stocksService: StockServiceProtocol

    private var stock: Stock?

    init(stockID: String, stocksService: StockServiceProtocol) {
        self.stockID = stockID
        self.stocksService = stocksService
    }

    func bind(viewStateHandler: @escaping (DetailViewState) -> Void) {
        stocksService.getStockDetails(stockID: stockID) { [weak self] stock in
            viewStateHandler(
                .init(
                    title: stock.title,
                    symbol: stock.symbol,
                    price: "\(stock.price)",
                    priceColor: stock.price >= self?.stock?.price ?? 0 ? .green : .red,
                    favoriteButtonTitle: stock.favorite ? "Remove from Favourites" : "Add to Favourites",
                    imageUrl: URL(string: stock.logoUrl)!
                )
            )

            self?.stock = stock
        }
    }

    func favoriteAction() {
        stocksService.updateStockDetail(stockID: stockID, isFavorite: !(stock?.favorite ?? true))
    }

}

protocol DetailViewModelProtocol {

    func bind(viewStateHandler: @escaping (DetailViewState) -> Void)
    func favoriteAction()

}
