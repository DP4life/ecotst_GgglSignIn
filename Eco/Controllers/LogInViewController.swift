//
//  LogInViewController.swift
//  Eco
//
//  Created by Porcescu Artiom on 8/28/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.backgroundColor = .clear
        emailTextField.layer.cornerRadius = 27
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.systemGreen.cgColor
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.layer.cornerRadius = 27
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    @IBAction func logInPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.errorLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: "logInToMap", sender: self)
                }
            }
        }
    }
    
    @IBAction func ForgotPasswordPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FP", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
