//
//  PCViewController.swift
//  MEAP - Game
//
//  Created by Angus  on 2018-11-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen, Kavya Bohra
//  UI Created By: Desmond Trang
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 11/1/18
//           -File Completed for Version 1 - 11/2/18
//           -Fixed Bug - 11/4/18
//           -Fixed Bug - 11/5/18
//           -File Completed for Version 2 - 11/17/18
//  Known Bugs: NONE!


import UIKit
import SpriteKit
import AVFoundation

//Controls the Pattern Completion game view
class PCViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!;
    @IBOutlet weak var bestValue: UILabel! //Value of best score
    @IBOutlet weak var best: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scoreValue: UILabel! //Value of score
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var nextArrow: UIButton!
    @IBOutlet weak var patternCompletion: UILabel!
    @IBOutlet weak var pClabel: UILabel!
    @IBOutlet weak var pausedView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var muteMusic: UIButton!
    @IBOutlet weak var tutorialView: UIView!
    var playerLooper: AVPlayerLooper!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var player: AVQueuePlayer!
    var screenSize = UIScreen.main.bounds.size
    var cellChecker: Timer! //Timer used to update cells of the board
    
    var scene: GameScene! //Instance of the game scene
    
    //Loads GameScene into UIView and initalizes music player
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        skView.presentScene(scene)
        // Do any additional setup after loading the view.
        
        do {
            //Plays "backgroundMusic.mp3"
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic_short", ofType: ".mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1 //Music length reduced to 10 minutes, hence loops indefinitely until muted
        }
        catch{
            print(error);
        }
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
    
    //Stops music when screen is left
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        audioPlayer.stop()
    }
    
    //Return from tutorial screen
    @IBAction func Return(_ sender: Any) {
        tutorialView.isHidden = true
        playerLayer.removeFromSuperlayer()
        player.replaceCurrentItem(with: nil)
        scene.game.paused = false
    }
    
    //Brings up tutorial and plays tutorial video
    @IBAction func Tutorial(_ sender: Any) {
        scene.game.paused = true
        tutorialView.isHidden = false
        PlayVideo()
        
    }
    
    //Displays pause screen and pauses game
    @IBAction func Pause(_ sender: Any) {
        pausedView.isHidden = false
        scene.game.paused = true
    }
    
    //Hides pause screen and resumes game
    @IBAction func ResumeGame(_ sender: Any) {
        pausedView.isHidden = true
        scene.game.paused = false
    }
    
    //Starts Phase 2 of pattern completion
    @IBAction func Start(_ sender: Any) {
        startBtn.isHidden = true
        nextButton.isHidden = false
        scene.game.StartPatternCompletion()
        pClabel.text = "Number of Blocks Left: " + String(scene.game.cellRemaining)
        cellChecker = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextButtonEnable), userInfo: nil, repeats: true)
    }
    
    //Updates whether the next button is disabled or not
    @objc func nextButtonEnable(){
        pClabel.text = "Number of Blocks Left: " + String(scene.game.cellRemaining)
        if(scene.game.cellRemaining == 0){
            nextButton.isEnabled = true
        }
        else{
            nextButton.isEnabled = false
        }
    }

    //Mutes or plays background music
    @IBAction func MuteMusic(_ sender: Any) {
        if(audioPlayer.isPlaying == true){
            audioPlayer.stop()
            muteMusic.setImage(UIImage(named: "PlayMusic"), for: .normal)
        }
        else {
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = 0
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1 //Loops indefintely until muted again
            muteMusic.setImage(UIImage(named: "MuteMusic"), for: .normal)
        }
    }
    
    //Takes user to game summary screen.
    //Screen objects are moved and updated
    @IBAction func nextButton(_ sender: Any) {
        nextButton.isHidden = true
        patternCompletion.text = "SCORES"
        pClabel.isHidden = true
        pageControl.isHidden = false
        nextArrow.isHidden = false
        scoreValue.center.x += 100
        scoreValue.center.y -= 150
        best.center.x -= 100
        best.center.y -= 150
        scoreLabel.center.x += 100
        scoreLabel.center.y -= 150
        bestValue.center.x -= 100
        bestValue.center.y -= 150
        scene.game.FinishPatternCompletionRound()
        scene.InitiateSummary()
        scoreValue.text = String(scene.game.score)
        bestValue.text = String(scene.game.score)
    }

}
