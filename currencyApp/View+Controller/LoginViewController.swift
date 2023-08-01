//
//  LoginViewController.swift
//  currencyApp
//
//  Created by Revathy Rajan on 01/08/23.
//
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignInButton()
        setUpVCTitle()
    }
   
    //Function to setup VC Title Programmatically
    func setUpVCTitle() {
        // Create a UILabel for the title
        let titleLabel = UILabel()
        titleLabel.text = "Login Page"
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
    // Function to set up the Google Sign-In button
    func setupGoogleSignInButton() {
        let signInButton = GIDSignInButton()
        signInButton.center = view.center
        signInButton.colorScheme = .dark
        signInButton.style = .standard
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(sign), for: .touchUpInside)
        
    }

    // MARK: - Google Sign-In Delegate Methods

    // This method is called when the user successfully signs in
    @objc func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { user, error in
            guard error == nil else { return }
//            guard user == user else { return }
//            let emailAddress = user.profile?.email
            guard let user = user else { return }
            let emailAddress = user.user.profile?.email
            self.redirectToHomeScreen()
            // If sign in succeeded, display the app's main content View.
          }
        
    }

    // Function to redirect to the home screen after successful sign-in
    func redirectToHomeScreen() {
        self.dismiss(animated: true, completion: {
            let vc = CurrencyConverterViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        })
    }


    
}




