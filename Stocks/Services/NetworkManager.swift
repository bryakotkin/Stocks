//
//  NetworkManager.swift
//  Stocks
//
//  Created by Nikita on 22.01.2022.
//

import Foundation
import UIKit

class NetworkManager {
    
    private let session = URLSession(configuration: .default)
    
    static let shared = NetworkManager()
    
    private init() {}
    
    enum FetcherStatus {
        case success(Data)
        case invalid(NetworkManagerStatus)
    }
    
    enum NetworkManagerStatus {
        case success([Company])
        case invalidURL
        case invalidData
        case requestError(String)
        case parseError
        
        public var description: String {
            switch self {
            case .invalidURL:
                return "Invalid URL"
            case .requestError(let str):
                return str
            case .invalidData:
                return "Invalid Data"
            case .parseError:
                return "Parse error"
            case .success:
                return "The process is successful"
            }
        }
    }
    
    private func fetchRequest(urlString: String, completion: @escaping (FetcherStatus) -> Void) {
        guard let url = URL(string: urlString) else { return completion(.invalid(.invalidURL)) }

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.invalid(.requestError(error.localizedDescription)))
            }

            guard let response = response as? HTTPURLResponse, response.isResponseOK() else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode.description
                let description = "Bad response \(statusCode ?? "")"
                return completion(.invalid(.requestError(description)))
            }

            guard let data = data else { return completion(.invalid(.invalidData))}

            completion(.success(data))
        }

        task.resume()
    }
    
    func fetchCompaniesInfo(completion: @escaping (NetworkManagerStatus) -> Void) {
        let urlString = "https://cloud.iexapis.com/stable/ref-data/symbols?token=\(apiKey)"
        
        fetchRequest(urlString: urlString) { [unowned self] status in
            switch status {
            case .success(let data):
                completion(self.parseCompaniesJSON(data))
            case .invalid(let error):
                completion(error)
            }
        }
    }
    
    func fetchCompanyInfo(_ company: Company, completion: @escaping (NetworkManagerStatus) -> Void) {
        let urlString = "https://cloud.iexapis.com/stable/stock/\(company.symbol)/quote/?token=\(apiKey)"

        fetchRequest(urlString: urlString) { [unowned self] status in
            switch status {
            case .success(let data):
                completion(self.parseCompanyJSON(data))
            case .invalid(let error):
                completion(error)
            }
        }
    }
    
    func fetchCompanyImage(_ company: Company, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/\(company.symbol).png"
        
        fetchRequest(urlString: urlString) { [unowned self] status in
            switch status {
            case .success(let data):
                completion(parseCompanyImage(data))
            case .invalid(_):
                completion(nil)
            }
        }
    }
    
    private func parseCompanyJSON(_ data: Data) -> (NetworkManagerStatus) {
        let decoder = JSONDecoder()
        guard let companyData = try? decoder.decode(CompanyDataSymbol.self, from: data) else { return .parseError }
        let company = Company(data: companyData)
        
        return .success([company])
    }
    
    private func parseCompaniesJSON(_ data: Data) -> (NetworkManagerStatus) {
        let decoder = JSONDecoder()
        guard let companiesData = try? decoder.decode(CompaniesData.self, from: data) else { return (.parseError) }
        
        var companies: [Company] = []
        
        companiesData.forEach { companyData in
            let company = Company(data: companyData)
            companies.append(company)
        }
        
        return .success(companies)
    }
    
    private func parseCompanyImage(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}
