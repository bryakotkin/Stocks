//
//  Company.swift
//  Stocks
//
//  Created by Nikita on 22.01.2022.
//

import Foundation
import UIKit

class Company {
    
    var symbol: String
    var name: String
    var price: Double?
    var priceChange: Double?
    var image: UIImage?

    init(data: CompanyDataSymbol) {
        self.symbol = data.symbol
        self.name = data.companyName
        self.price = data.latestPrice
        self.priceChange = data.latestPrice - data.previousClose
    }
    
    init(data: CompanyData) {
        self.symbol = data.symbol
        self.name = data.name
    }
}
