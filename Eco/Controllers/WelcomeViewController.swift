//
//  ViewController.swift
//  Eco
//
//  Created by Porcescu Artiom on 8/28/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import UIKit
import GoogleSignIn

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var GoogleSignInButton: GIDSignInButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logInButton.backgroundColor = .clear
        logInButton.layer.cornerRadius = 27
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.systemGreen.cgColor
        
        //Google Sign In
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GoogleSignInButton.backgroundColor = UIColor.systemGreen
        GoogleSignInButton.layer.cornerRadius = 27
        GoogleSignInButton.layer.borderWidth = 1
        GoogleSignInButton.layer.borderColor = UIColor.systemGreen.cgColor
        
    }


}

