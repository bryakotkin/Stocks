//
//  StockView.swift
//  Stocks
//
//  Created by Nikita on 22.01.2022.
//

import UIKit

class StockView: UIView {
    
    let companyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let companyName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Company name:"
        label.textColor = .white
        
        return label
    }()
    
    let companyNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "-"
        label.textColor = .white
        
        return label
    }()
    
    private let companySymbol: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Company symbol:"
        label.textColor = .white
        
        return label
    }()
    
    let companySymbolLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "-"
        label.textColor = .white
        
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Price:"
        label.textColor = .white
        
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "-"
        label.textColor = .white
        
        return label
    }()
    
    private let priceChange: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Price change:"
        label.textColor = .white
        
        return label
    }()
    
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "-"
        label.textColor = .white
        
        return label
    }()
    
    let companyPickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.isHidden = true
        picker.tintColor = .white
        
        return picker
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .fromHex(hex: 0x161d2b)
        
        addSubview(companyImage)
        addSubview(companyName)
        addSubview(companyNameLabel)
        addSubview(companySymbol)
        addSubview(companySymbolLabel)
        addSubview(price)
        addSubview(priceLabel)
        addSubview(priceChange)
        addSubview(priceChangeLabel)
        addSubview(activityIndicator)
        addSubview(companyPickerView)
        
        setupConstraints()
    }
    
    func updateLabels(_ name: String = "-", _ symbol: String = "-", _ price: Double? = nil, _ priceChange: Double? = nil) {
        if let price = price, let priceChange = priceChange {
            var priceText = ""
            
            if priceChange < 0 {
                priceChangeLabel.textColor = .red
            }
            else if priceChange == 0 {
                priceChangeLabel.textColor = .white
            }
            else {
                priceChangeLabel.textColor = .green
                priceText += "+"
            }
            
            priceLabel.text = String(format: "%.2f", price)
            priceChangeLabel.text = priceText + String(format: "%.2f", priceChange)
        }
        else {
            priceLabel.text = "-"
            priceChangeLabel.text = "-"
            priceChangeLabel.textColor = .white
        }
        
        companyNameLabel.text = name
        companySymbolLabel.text = symbol
    }
    
    func updateImage(_ image: UIImage?) {
        if let image = image {
            companyImage.image = image
        }
        else {
            companyImage.image = UIImage(named: "no-data")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        companyImage.translatesAutoresizingMaskIntoConstraints = false
        companyName.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        companySymbol.translatesAutoresizingMaskIntoConstraints = false
        companySymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceChange.translatesAutoresizingMaskIntoConstraints = false
        priceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        companyPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        let companyImageConstraint = [
            companyImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            companyImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            companyImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/3),
            companyImage.heightAnchor.constraint(equalTo: companyImage.widthAnchor)
        ]
        
        let companyNameConstraint = [
            companyName.rightAnchor.constraint(equalTo: centerXAnchor, constant: -16),
            companyName.topAnchor.constraint(equalTo: companyImage.bottomAnchor, constant: 16),
        ]
        
        let companyNameLabelConstraint = [
            companyNameLabel.leftAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            companyNameLabel.topAnchor.constraint(equalTo: companyName.topAnchor),
            companyNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ]
        
        let companySymbolConstraint = [
            companySymbol.rightAnchor.constraint(equalTo: companyName.rightAnchor),
            companySymbol.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 16)
        ]
        
        let companySymbolLabelConstraint = [
            companySymbolLabel.leftAnchor.constraint(equalTo: companyNameLabel.leftAnchor),
            companySymbolLabel.topAnchor.constraint(equalTo: companySymbol.topAnchor)
        ]
        
        let priceConstraint = [
            price.rightAnchor.constraint(equalTo: companyName.rightAnchor),
            price.topAnchor.constraint(equalTo: companySymbol.bottomAnchor, constant: 16)
        ]
        
        let priceLabelConstraint = [
            priceLabel.leftAnchor.constraint(equalTo: companyNameLabel.leftAnchor),
            priceLabel.topAnchor.constraint(equalTo: price.topAnchor)
        ]
        
        let priceChangeConstraint = [
            priceChange.rightAnchor.constraint(equalTo: companyName.rightAnchor),
            priceChange.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16)
        ]
        
        let priceChangeLabelConstraint = [
            priceChangeLabel.leftAnchor.constraint(equalTo: companyNameLabel.leftAnchor),
            priceChangeLabel.topAnchor.constraint(equalTo: priceChange.topAnchor)
        ]
        
        let activityIndicatorConstraint = [
            activityIndicator.topAnchor.constraint(equalTo: priceChangeLabel.bottomAnchor, constant: 16),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]
        
        let companyPickerViewConstraint = [
            companyPickerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            companyPickerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            companyPickerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ]
        
        constraints.append(contentsOf: companyImageConstraint)
        constraints.append(contentsOf: companyNameConstraint)
        constraints.append(contentsOf: companyNameLabelConstraint)
        constraints.append(contentsOf: companySymbolConstraint)
        constraints.append(contentsOf: companySymbolLabelConstraint)
        constraints.append(contentsOf: priceConstraint)
        constraints.append(contentsOf: priceLabelConstraint)
        constraints.append(contentsOf: priceChangeConstraint)
        constraints.append(contentsOf: priceChangeLabelConstraint)
        constraints.append(contentsOf: activityIndicatorConstraint)
        constraints.append(contentsOf: companyPickerViewConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}
