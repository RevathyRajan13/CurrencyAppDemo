//
//  CurrencyConverterViewModel.swift
//  currencyApp
//
//  Created by SMH on 29/07/23.
//

import Foundation

struct CurrencyData: Codable {
    let rates: [String: Double]
}

class CurrencyConverterViewModel {
    private var currencies: [Currency] = []

    func fetchCurrencies(completion: @escaping (Error?) -> Void) {
        let urlString = "http://api.exchangeratesapi.io/v1/latest?access_key=a00e38904673a306195a8cec5eb29cc3&format=1"

        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    completion(error)
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(CurrencyData.self, from: data)
                    let currencies = decodedData.rates.map { Currency(name: $0.key, rate: $0.value) }
                    self?.currencies = currencies
                    completion(nil)
                } catch {
                    completion(error)
                }
            }.resume()
        }
    }

    func getCurrencies() -> [Currency] {
        return currencies
    }

    func convertCurrency(from homeCurrency: Currency, to otherCurrency: Currency) -> String {
        let conversionRate = otherCurrency.rate / homeCurrency.rate
        return String(format: "1 %@ = %.2f %@", homeCurrency.name, conversionRate, otherCurrency.name)
    }
}
