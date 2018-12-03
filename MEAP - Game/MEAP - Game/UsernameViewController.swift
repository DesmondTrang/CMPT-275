//
//  UsernameViewController.swift
//  MEAP - Game
//
//  Created by Angus  on 2018-11-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Desmond Trang, Travis Friday, Amir Fazelipour
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 11/17/18
//  Known Bugs: NONE!

import UIKit
import Firebase
import FirebaseStorage

//User Creation screen UIViewController
class UsernameViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var usernameImage: UIImageView!
    @IBOutlet weak var incorrectImage: UIImageView!
    @IBOutlet weak var correctImage: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var clearUsernameButton: UIButton!
    @IBOutlet weak var forwardArrow: UIButton!
    
    typealias Request = ((_ value:Bool) -> ())

    var name: String = ""
    var newName: String = ""
    var sameName: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    func networkAlert(completion:@escaping Request) {
        
        // create the alert
        let alert = UIAlertController(title: "MEAP could not connect to the MEAP database. The network is down or unavailable.", message: "Make sure your network connection is active and try again.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
                self.confirm()
            }
            else {
                self.networkAlert { (value) in
                    print(value)
                }
                
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    //User creates user with username
    @IBAction func EnterConfirm(_ sender: Any) {
        //user enters the data and it is stored in the variable "newName"
        //check to see if "name" exists in the database

        
        if !Connectivity.isConnectedToInternet() {
            print("No! internet is not available.")
            self.networkAlert { (value) in
                print(value)
            }
        }
        
        else {
            self.confirm()
        }
    }
    
    func confirm() {
        self.newName = self.usernameField.text!
        let db = Firestore.firestore()
        db.collection("appUser").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.name = document.get("userName") as! String
                    if(self.newName == self.name) {
                        self.usernameImage.isHidden = true
                        self.incorrectImage.isHidden = false
                    }
                    else {
                        db.collection("appUser").document("name").setData(["userName": self.newName])
                        self.usernameImage.isHidden = true
                        self.incorrectImage.isHidden = true
                        self.correctImage.isHidden = false
                        self.forwardArrow.isHidden = false
                    }
                }
            }
        }
    }
    
}

extension UIViewController : UITextFieldDelegate {
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
