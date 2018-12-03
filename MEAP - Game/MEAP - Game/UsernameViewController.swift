//
//  UsernameViewController.swift
//  MEAP - Game
//
//  Created by Angus  on 2018-11-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Desmond Trang, Travis Friday
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 11/17/18
//  Known Bugs: NONE!

import UIKit
import Firebase
import FirebaseStorage
import SpriteKit

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
    var documentID: String = ""
    var appUser: String = "appUser"

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        
        // sees if user has already made a username (stored in core data)
        // if username exists, directly segue to home screen
        let userNamePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(appUser)"
        if FileManager.default.fileExists(atPath: userNamePath) {
            performSegue(withIdentifier: "HomeScreenSegue", sender: nil)
        }
        
        // query firebase for specific data
        let db = Firestore.firestore()
        db.collection("appUserGraph").whereField("userName", isEqualTo: "??").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let userLevel = document.get("userLevel") as! String
                    print(userLevel)
                }
            }
        }
        
        // generate data for chart
        Firestore.firestore().collection("appUserGraph").document("Graph").setData(["Dec" : [ "1" : [ "gamePlays" : 2,
                                                                                 "averageScoresPC" : 80,
                                                                                 "totalScoresPC" : 160,
                                                                                 "averageScoresPS" : 60,
                                                                                 "totalScoresPS" : 120],
                                                                           "4" : [ "gamePlays" : 2,
                                                                                 "averageScoresPC" : 80,
                                                                                 "totalScoresPC" : 160,
                                                                                 "averageScoresPS" : 60,
                                                                                 "totalScoresPS" : 120],
                                                                           "10" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "15" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "22" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "29" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120]
            ],
                                                                 "Nov" : [ "3" : [ "gamePlays" : 2,
                                                                                 "averageScoresPC" : 80,
                                                                                 "totalScoresPC" : 160,
                                                                                 "averageScoresPS" : 60,
                                                                                 "totalScoresPS" : 120],
                                                                           "5" : [ "gamePlays" : 2,
                                                                                 "averageScoresPC" : 80,
                                                                                 "totalScoresPC" : 160,
                                                                                 "averageScoresPS" : 60,
                                                                                 "totalScoresPS" : 120],
                                                                           "12" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "17" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "18" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "30" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120]
            ],
                                                                 "Oct" : [ "2" : [ "gamePlays" : 2,
                                                                                 "averageScoresPC" : 80,
                                                                                 "totalScoresPC" : 160,
                                                                                 "averageScoresPS" : 60,
                                                                                 "totalScoresPS" : 120],
                                                                           "10" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "11" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "12" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "15" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120],
                                                                           "20" : [ "gamePlays" : 2,
                                                                                  "averageScoresPC" : 80,
                                                                                  "totalScoresPC" : 160,
                                                                                  "averageScoresPS" : 60,
                                                                                  "totalScoresPS" : 120]
            ]
        ])
        
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
        //user enters the data and it is stored in the variable "newName"
        //check to see if "name" exists in the database
        newName = usernameField.text!
        var sameName: Bool = false
        let db = Firestore.firestore()
        
        db.collection("appUser").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.documentID = document.documentID
                    if (self.documentID == self.newName) {
                        sameName = true;
                        break;
                    }
                    
                }
                if (sameName == true) {
                    self.usernameImage.isHidden = true
                    self.incorrectImage.isHidden = false
                }
                else {
                    
                    // stores data in FB in two different collections
                    //                    let month = currentDayMonth().month
                    //                    let day = currentDayMonth().day
                    db.collection("appUser").document(self.newName).setData(["userName" : self.newName,
                                                                             "bestScorePC" : 0,
                                                                             "bestScorePS" : 0,
                                                                             "userLevel" : "extreme"])
                    for month in 1...12 {
                        if (month == 1) {
                            db.collection("appUserGraph").document(self.newName).setData([String(month) :
                                [ "1" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "2" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "3" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "4" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "5" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "6" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "7" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "8" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "9" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "10" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "11" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "12" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "13" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "14" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "15" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "16" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "17" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "18" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "19" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "20" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "21" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "22" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "23" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "24" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "25" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "26" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "27" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "28" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "29" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "30" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "31" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0]
                                ]])
                        }
                        else {
                            db.collection("appUserGraph").document(self.newName).updateData([String(month) :
                                [ "1" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "2" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "3" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "4" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "5" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "6" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "7" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "8" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "9" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "10" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "11" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "12" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "13" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "14" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "15" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "16" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "17" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "18" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "19" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "20" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "21" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "22" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "23" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "24" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "25" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "26" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "27" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "28" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "29" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "30" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0],
                                  "31" : [ "gamePlays" : 0, "averageScoresPC" : 0, "totalScoresPC" : 0, "averageScoresPS" : 0, "totalScoresPS" : 0]
                                ]])
                        }
                    }
                    
                    self.usernameImage.isHidden = true
                    self.incorrectImage.isHidden = true
                    self.correctImage.isHidden = false
                    self.forwardArrow.isHidden = false
                    
                    // writes username to core data
                    let userNamePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(self.appUser)"
                    let userNameUrl: URL = URL(fileURLWithPath: userNamePath)
                    try? self.newName.write(to: userNameUrl, atomically: false, encoding: .utf8)
                    print(try? String(contentsOf: userNameUrl, encoding: .utf8))
                }
            }
            
        }
        
    }
}

// returns month and day as string (i.e. "10" = Oct)
func currentDayMonth() -> (month: String, day: String) {
    let currentDate = Date()
    let currentCalendar = Calendar.current
    let requestedComponents: Set<Calendar.Component> = [
        .month,
        .day
    ]
    let dateComponents = currentCalendar.dateComponents(requestedComponents, from: currentDate)
    return (String(dateComponents.month!), String(dateComponents.day!))
}

extension UIViewController : UITextFieldDelegate {
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
