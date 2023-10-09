//
//  MainViewModel.swift
//  UCLSeminar
//
//  Created by Berat Cevik on 07/10/2023.
//

final class MainViewModel: MainViewModelProtocol {

    private let stocksService: StockServiceProtocol

    init(stocksService: StockServiceProtocol) {
        self.stocksService = stocksService
    }

    func bind(viewStateHandler: @escaping (MainViewState) -> Void) {
        stocksService.getStocks { stocks in
            viewStateHandler(.init(rows: stocks.compactMap {
                if let id = $0.id {
                    return StockCell.ViewState(
                        id: id,
                        title: $0.title,
                        iconName: $0.favorite ? "star.fill" : "star"
                    )
                }
                return nil
            }))
        }
    }

    func uploadAction() {
        stocksService.uploadStocks()
    }

}

protocol MainViewModelProtocol {

    func bind(viewStateHandler: @escaping (MainViewState) -> Void)
    func uploadAction()

}
