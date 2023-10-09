//
//  Stock.swift
//  UCLSeminar
//
//  Created by Berat Cevik on 07/10/2023.
//

import FirebaseFirestoreSwift

struct Stock: Codable {

    @DocumentID var id: String?
    let title: String
    let symbol: String
    let price: Double
    let logoUrl: String
    let favorite: Bool

}
