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
    
    @IBOutlet weak var muted: UIButton!
    @IBOutlet weak var Unmuted: UIButton!
    @IBOutlet weak var Number: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startingLabel: UIImageView!
    @IBOutlet weak var menuView: UIView!
    var countDownTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Play Background Music
        do {
            //Plays "backgroundMusic.mp3"
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: ".mp3")!))
            audioPlayer.prepareToPlay()
        }
        catch{
            print(error);
        }
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
    
    //Play Music Button
    @IBAction func musicOn(_ sender: Any) {
        audioPlayer.currentTime = 0;
        audioPlayer.play()
    }
    
    //Music Off Button
    @IBAction func musicOff(_ sender: Any) {
        if (audioPlayer.isPlaying)
        {
            audioPlayer.pause();
        }
    }
    //History Button
    @IBAction func historyButton(_ sender: Any) {
        
    }
    
    //Quit Game Button
    @IBAction func quitGame(_ sender: Any) {
    }
    
    @IBAction func Menu(_ sender: Any) {
        menuView.isHidden = false
    }
 
    @IBAction func Return(_ sender: Any) {
        menuView.isHidden = true
    }
    @IBAction func Mute(_ sender: Any) {
        Unmuted.isHidden = true
        muted.isHidden = false
    }
    
    @IBAction func Unmute(_ sender: Any) {
        Unmuted.isHidden = true
        muted.isHidden = true
    }
    
    
    @IBAction func startButton(_ sender: Any) {
        startButton.isHidden = true
        startingLabel.isHidden = false
        Number.isHidden = false
        Number.text = "3"
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    
    }
    
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


