//
//  GameViewController.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    ///Instances
    var audioPlayer: AVAudioPlayer!;
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var muteText: UIButton!
    @IBOutlet weak var muted: UIButton!
    @IBOutlet weak var Unmuted: UIButton!
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startingLabel: UIImageView!
    @IBOutlet weak var menuView: UIView!
    var countDownTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }

    override var shouldAutorotate: Bool {
        return true
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    //Unhides Menu View
    @IBAction func Menu(_ sender: Any) {
        menuView.isHidden = false
    }
 
    //Hides Menu
    @IBAction func Return(_ sender: Any) {
        menuView.isHidden = true
    }
    
    //Shows History view
    @IBAction func History(_ sender: Any) {
        historyView.isHidden = false
    }
    
    //Hides History view
    @IBAction func ReturnToMenu(_ sender: Any) {
        historyView.isHidden = true
    }
    
    //Starts game countdown
    @IBAction func startButton(_ sender: Any) {
        startButton.isHidden = true
        startingLabel.isHidden = false
        Number.isHidden = false
        Number.text = "3"
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    
    }
    
    //Countes down to 1 and segue to game view
    @objc func countDown(){
        if(Number.text == "3"){
            Number.text = "2"
        }
        else if(Number.text == "2"){
            Number.text = "1"
        }
        else{
            countDownTimer.invalidate()
            performSegue(withIdentifier: "StartPC", sender: self)
            //segue to game screen
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


