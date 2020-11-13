//
//  MapBarViewController.swift
//  Eco
//
//  Created by Porcescu Artiom on 9/12/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import UIKit
import Firebase

class MapBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
