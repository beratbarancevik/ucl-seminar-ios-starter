//
//  StocksService.swift
//  UCLSeminar
//
//  Created by Berat Cevik on 07/10/2023.
//

import FirebaseFirestore

final class StocksService: StockServiceProtocol {

    private let db: Firestore

    private var listeners: [ListenerRegistration] = []

    init(db: Firestore = Firestore.firestore()) {
        self.db = db
    }

    deinit {
        listeners.forEach { $0.remove() }
    }

    func getStocks(completionHandler: @escaping ([Stock]) -> Void) {
        let listener = db.collection("stocks").order(by: "title").addSnapshotListener { snapshot, error in
            do {
                guard let stocks = try snapshot?.documents.map({ try $0.data(as: Stock.self) }) else {
                    return
                }
                completionHandler(stocks)
            } catch {
                print("Decoding error")
            }
        }
        listeners.append(listener)
    }

    func getStockDetails(stockID: String, completionHandler: @escaping (Stock) -> Void) {
        let listener = db.collection("stocks").document(stockID).addSnapshotListener { snapshot, error in
            do {
                guard let stock = try snapshot?.data(as: Stock.self) else {
                    return
                }
                completionHandler(stock)
            } catch {
                print("Decoding error")
            }
        }
        listeners.append(listener)
    }

    func updateStockDetail(stockID: String, isFavorite: Bool) {
        db.collection("stocks").document(stockID).setData([
            "favorite": isFavorite
        ], merge: true) { error in
            if let error { print("Update stock error: \(error.localizedDescription)") }
        }
    }

    func uploadStocks() {
        let stocks: [Stock] = [
            .init(id: "id-1", title: "Tesla", symbol: "TSLA", price: 120.6, logoUrl: "https://oceansquare.com/wp-content/uploads/2018/04/tesla-logo-500.jpg", favorite: false),
            .init(id: "id-2", title: "Apple", symbol: "AAPL", price: 45.3, logoUrl: "https://i.pinimg.com/474x/b0/d2/6e/b0d26e8122dffa8a51081f7f814581d7.jpg", favorite: false),
            .init(id: "id-3", title: "Meta", symbol: "META", price: 935.2, logoUrl: "https://img.freepik.com/premium-vector/meta-company-logo_265339-667.jpg", favorite: false)
        ]
        stocks.forEach {
            do {
                try db.collection("stocks").document($0.id!).setData(from: $0) { error in
                    if let error { print("Failed to upload stock: \(error)") }
                }
            } catch {
                print("Encoding error")
            }
        }
    }

}

protocol StockServiceProtocol {

    func getStocks(completionHandler: @escaping ([Stock]) -> Void)
    func getStockDetails(stockID: String, completionHandler: @escaping (Stock) -> Void)
    func updateStockDetail(stockID: String, isFavorite: Bool)
    func uploadStocks()

}
