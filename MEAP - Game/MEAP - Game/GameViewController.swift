//
//  GameViewController.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen, Amir Fazelipour
//  UI Created By: Desmond Trang
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 10/25/18
//           -File Completed - 11/2/18
//           -Fixed Bug - 11/4/18
//  Known Bugs: NONE!


import UIKit
import AVFoundation

//Controls the main menu story board
class GameViewController: UIViewController {
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var startingLabel: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tutorialView: UIView!
    var countDownTimer:Timer! //Timer used to count down
    var player: AVQueuePlayer!
    var screenSize = UIScreen.main.bounds.size
    var playerLooper: AVPlayerLooper!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    
    typealias Request = ((_ value:Bool) -> ())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //plays and loops "Tutorial.mp4"
    private func PlayVideo(){
        
        screenSize = UIScreen.main.bounds.size
        //Plays "Tutorial.mp4"
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: "tutorial", ofType: ".mp4")!))
        
        player = AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "tutorial", ofType: ".mp4")!))
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = CGRect(x: ((screenSize.width/4)-120) , y: ((screenSize.height/4)+120), width: 800, height: 500)
        self.view.layer.addSublayer(playerLayer)
        
        player.play()
        
    }

    //IOS Function to rotate screen
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
    
    //Brings up Tutorial from menu
    @IBAction func MenuTutorial(_ sender: Any) {
        tutorialView.isHidden = false
        PlayVideo()
    }
    
    //Brings up tutorial from main screen
    @IBAction func Tutorial(_ sender: Any) {
        if(countDownTimer != nil){
            countDownTimer.invalidate()
        }
        number.text = "3"
        number.isHidden = true
        startingLabel.isHidden = true
        startButton.isHidden = false
        tutorialView.isHidden = false
        PlayVideo()
    }
    
    //Exits Tutorial
    @IBAction func ExitTutorial(_ sender: Any) {
        tutorialView.isHidden = true
        playerLayer.removeFromSuperlayer()
        player.replaceCurrentItem(with: nil)
    }
    
    //Unhides Menu View
    @IBAction func Menu(_ sender: Any) {
        if(countDownTimer != nil){
            countDownTimer.invalidate()
        }
        number.text = "3";
        number.isHidden = true
        startButton.isHidden = false
        menuView.isHidden = false
        startingLabel.isHidden = true
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
    
    func networkAlert(completion:@escaping Request) {
        
        // create the alert
        let alert = UIAlertController(title: "MEAP could not connect to the MEAP database. The network is down or unavailable.", message: "Make sure your network connection is active and try again.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            if Connectivity.isConnectedToInternet() {
                print("Yes! internet is available.")
                self.startCountdown()
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
    
    
    
    //Starts game countdown
    @IBAction func startButton(_ sender: Any) {
        
        if !Connectivity.isConnectedToInternet() {
            print("No! internet is not available.")
            self.networkAlert { (value) in
                print(value)
            }
        }
        
        else {
            self.startCountdown()
        }
    }
    
    //Countes down to 1 and segue to game view
    @objc func countDown(){
        if(number.text == "3"){
            number.text = "2"
        }
        else if(number.text == "2"){
            number.text = "1"
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
    
    func startCountdown() {
        startButton.isHidden = true
        startingLabel.isHidden = false
        number.isHidden = false
        number.text = "3"
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
}



