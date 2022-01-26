//
//  NetworkModels.swift
//  Stocks
//
//  Created by Nikita on 22.01.2022.
//

import Foundation
import UIKit

struct CompanyData: Decodable {
    var symbol: String
    var name: String
}

struct CompanyDataSymbol: Decodable {
    var symbol: String
    var companyName: String
    var latestPrice: Double
    var previousClose: Double
}

typealias CompaniesData = [CompanyData]
