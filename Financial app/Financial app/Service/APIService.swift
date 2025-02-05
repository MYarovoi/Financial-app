//
//  APIService.swift
//  Financial app
//
//  Created by Mykyta Yarovoi on 04.02.2025.
//

import Foundation
import Combine

struct APIService {
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["CBUCAPK3X3P8B8AJ", "F0ELLPODHPU8AS1P", "H1P7XYEAU1BNQERD"]
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
