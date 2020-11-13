//
//  ProfileViewController.swift
//  Eco
//
//  Created by Porcescu Artiom on 9/21/20.
//  Copyright © 2020 EcoHelpers. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageDB: UIImageView!
    @IBOutlet weak var profileNameDB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storage = Storage.storage().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }

        storage.child("users/\(uid).jpg").getData(maxSize: 1024 * 1024 * 1) { (data, error) in
            if error != nil {
                print("error occured")
                return
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.profileImageDB.image = image
                }
            }
            
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { (documentsF, error) in
            if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in documentsF!.documents {
                            print("\(document.documentID) => \(document.data())")
                            let data = document.data()["username"]
                            self.profileNameDB.text = data as? String
                        }
                    }
        }
//
//        db.collection("users").getDocuments { (snapshot, error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            } else {
//                guard let snap = snapshot else { return }
//                for document in snap.documents {
//                    if (document.value(forKey: "\(uid)") != nil) {
//                        let data = document.data()
//                        let userName = data["username"]
//                        self.profileNameDB.text = userName as? String
//                    }
//                }
//            }
//        }
            
//            .document("\(uid)").getDocument { (snapshot, error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            } else {
//                guard let snap = snapshot else { return }
//                let data = snap.data()
//                let userName = data!["username"]
//            }
//        }
            
//            .getDocuments { (snapshot, error) in
//            if let err = error {
//                print(err.localizedDescription)
//                return
//            } else {
//                guard let snap = snapshot else { return }
//                for document in snap.documents {
//                    let data = document.data()
//                    let userName = data["username"]
//                    self.profileNameDB.text = userName as? String
//                }
//            }
//        }
        
        profileImageDB.layer.cornerRadius = profileImageDB.bounds.height / 2
        profileImageDB.clipsToBounds = true
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
