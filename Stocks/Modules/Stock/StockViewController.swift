//
//  StockViewController.swift
//  Stocks
//
//  Created by Nikita on 22.01.2022.
//

import UIKit

class StockViewController: UIViewController {
    
    var mainView: StockView {
        return view as! StockView
    }
    
    var companies: [Company] = []
    
    override func loadView() {
        let view = StockView()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.companyPickerView.dataSource = self
        mainView.companyPickerView.delegate = self

        fetchComponiesInfo()
    }
    
    private func fetchComponiesInfo() {
        mainView.activityIndicator.startAnimating()
        NetworkManager.shared.fetchCompaniesInfo { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .success(let companies):
                    self?.companies = companies
                    self?.mainView.companyPickerView.reloadAllComponents()
                    self?.mainView.companyPickerView.isHidden = false
                    self?.fetchCompanyInfo()
                    self?.fetchCompanyImage()
                @unknown default:
                    self?.showAlertViewController(status.description)
                }
                self?.mainView.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func fetchCompanyInfo() {
        guard companies.count != 0 else { return }
        let row = self.mainView.companyPickerView.selectedRow(inComponent: 0)
        let company = self.companies[row]
    
        if let price = company.price, let priceChange = company.priceChange {
            mainView.updateLabels(company.name, company.symbol, price, priceChange)
        }
        else {
            mainView.activityIndicator.startAnimating()
            NetworkManager.shared.fetchCompanyInfo(company) { [weak self] status in
                DispatchQueue.main.async {
                    switch status {
                    case .success(let company):
                        guard let first = company.first else { return }
                        self?.companies[row] = first
                        
                        self?.mainView.updateLabels(first.name, first.symbol, first.price, first.priceChange)
                    @unknown default:
                        self?.mainView.updateLabels()
                        self?.showAlertViewController(status.description)
                    }
                    self?.mainView.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func fetchCompanyImage() {
        guard companies.count != 0 else { return }
        let row = self.mainView.companyPickerView.selectedRow(inComponent: 0)
        let company = self.companies[row]
        
        NetworkManager.shared.fetchCompanyImage(company) { [weak self] image in
            DispatchQueue.main.async {
                self?.mainView.updateImage(image)
            }
        }
    }
    
    private func showAlertViewController(_ message: String) {
        let alertController = UIAlertController(title: "Message", message: "Error", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            if self?.companies.count == 0 {
                self?.fetchComponiesInfo()
            }
            else {
                self?.fetchCompanyInfo()
                self?.fetchCompanyImage()
            }
        }
        
        alertController.message = message
        
        alertController.addAction(cancelAction)
        alertController.addAction(retryAction)
    
        if presentedViewController == nil {
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension StockViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return companies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let companyName = companies[row].name
        
        return NSAttributedString(string: companyName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchCompanyInfo()
        fetchCompanyImage()
    }
}
