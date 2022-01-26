//
//  HTTPURLResponse+StatusCodeChecker.swift
//  Stocks
//
//  Created by Nikita on 22.01.2022.
//

import Foundation

extension HTTPURLResponse {
    
    func isResponseOK() -> Bool {
        return (200...299).contains(self.statusCode)
    }
}

