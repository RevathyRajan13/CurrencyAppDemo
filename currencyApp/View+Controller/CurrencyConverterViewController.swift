//
//  CurrencyConverterViewController.swift
//  currencyApp
//
//  Created by SMH on 29/07/23.
//

import UIKit
import GoogleSignIn

class CurrencyConverterViewController: UIViewController {
    var homeCurrencyDropdown: UIPickerView!
    var otherCurrencyDropdown: UIPickerView!
    var convertButton: UIButton!
    var resultLabel: UILabel!
    var viewModel = CurrencyConverterViewModel()
    var currencies: [Currency] = [] // Array to hold the list of currencies and rates
    var selectedHomeCurrency: Currency?
    var selectedOtherCurrency: Currency?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCurrencies()
        self.view.backgroundColor = .white
        // Add the sign-out button at the bottom
        setupSignOutButton()
        setUpVCTitle()
    }
    
    //Function to setup VC Title Programmatically
    func setUpVCTitle() {
        // Create a UILabel for the title
        let titleLabel = UILabel()
        titleLabel.text = "Currency Convert Page"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .blue
        
        // Set corner radius to make it rounded
        titleLabel.layer.cornerRadius = 10
        titleLabel.clipsToBounds = true
        
        // Add the label to the view
        view.addSubview(titleLabel)
        
        // Position the label using Auto Layout (constraints)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupUI() {
        // Create the Home Currency UIPickerView
        homeCurrencyDropdown = UIPickerView()
        homeCurrencyDropdown.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeCurrencyDropdown)

        // Create the Other Currency UIPickerView
        otherCurrencyDropdown = UIPickerView()
        otherCurrencyDropdown.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otherCurrencyDropdown)

        // Create the Convert Button
        convertButton = UIButton(type: .system)
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        convertButton.setTitle("Convert", for: .normal)
        convertButton.addTarget(self, action: #selector(convertButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(convertButton)

        // Create the Result Label
        resultLabel = UILabel()
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.textAlignment = .center
        view.addSubview(resultLabel)

        // Setup constraints
        NSLayoutConstraint.activate([
            homeCurrencyDropdown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            homeCurrencyDropdown.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            otherCurrencyDropdown.topAnchor.constraint(equalTo: homeCurrencyDropdown.bottomAnchor, constant: 10),
            otherCurrencyDropdown.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            convertButton.topAnchor.constraint(equalTo: otherCurrencyDropdown.bottomAnchor, constant: 20),
            convertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resultLabel.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        homeCurrencyDropdown.dataSource = self
        homeCurrencyDropdown.delegate = self
        otherCurrencyDropdown.dataSource = self
        otherCurrencyDropdown.delegate = self
    }

    func fetchCurrencies() {
        viewModel.fetchCurrencies { [weak self] error in
            if let error = error {
                // Handle the error, e.g., show an alert to the user
                print("Error fetching currencies: \(error.localizedDescription)")
                return
            }
            self?.currencies = self?.viewModel.getCurrencies() ?? []
            DispatchQueue.main.async {
                self?.homeCurrencyDropdown.reloadAllComponents()
                self?.otherCurrencyDropdown.reloadAllComponents()
            }
        }
    }

    @objc func convertButtonTapped(_ sender: Any) {
        guard let homeCurrency = selectedHomeCurrency, let otherCurrency = selectedOtherCurrency else {
            // Show error message, asking the user to select both currencies
            return
        }

        // Perform the currency conversion
        let result = viewModel.convertCurrency(from: homeCurrency, to: otherCurrency)
        resultLabel.text = result
    }
    private func setupSignOutButton() {
            // Create the sign-out button
            let signOutButton = UIButton(type: .system)
            signOutButton.setTitle("Sign Out", for: .normal)
            signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
            signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.backgroundColor = .blue
        signOutButton.layer.cornerRadius = 10
        signOutButton.clipsToBounds = true
            // Add the button to the view
            view.addSubview(signOutButton)

            // Set up constraints for the button (you can customize the constraints based on your layout)
            NSLayoutConstraint.activate([
                signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                signOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                signOutButton.heightAnchor.constraint(equalToConstant: 44)
            ])
        }

        @objc private func signOutButtonTapped() {
            // Handle the sign-out button tap event here
            // For example, show an alert or perform the sign-out logic
            print("Sign Out button tapped!")
            GIDSignIn.sharedInstance.signOut()
            // Then dismiss the view controller
            self.dismiss(animated: true, completion: nil)
        }
}

extension CurrencyConverterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == homeCurrencyDropdown {
            selectedHomeCurrency = currencies[row]
        } else if pickerView == otherCurrencyDropdown {
            selectedOtherCurrency = currencies[row]
        }
    }
}

