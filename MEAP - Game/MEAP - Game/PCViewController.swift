//
//  PCViewController.swift
//  MEAP - Game
//
//  Created by Angus  on 2018-11-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen, Amir Fazelipour
//  UI Created By: Desmond Trang
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 11/1/18
//           -File Completed - 11/2/18
//           -Fixed Bug - 11/4/18
//           -Fixed Bug - 11/5/18
//           -Updated to support Pattern Separation 11/18/18
//  Known Bugs: NONE!


import UIKit
import SpriteKit
import AVFoundation

//Controls the Pattern Completion game view
class PCViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!;
    @IBOutlet var bestValue: [UILabel]! //Value of best score
    @IBOutlet var best: [UILabel]!
    //@IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var scoreValue: [UILabel]! //Value of score
    @IBOutlet var nextButton: [UIButton]!
    @IBOutlet var startBtn: [UIButton]!
    @IBOutlet var nextArrow: [UIButton]!
    
    
    @IBOutlet var pcHistoryNext: [UIButton]!
    @IBOutlet var patternCompletion: [UILabel]!
    @IBOutlet var pCLabel: [UILabel]!
    @IBOutlet weak var pausedView: UIView!
    @IBOutlet  var scoreLabel: [UILabel]!
    @IBOutlet weak var muteMusic: UIButton!
    @IBOutlet weak var tutorialView: UIView!


    //PS
    @IBOutlet var pSImageView: [UIImageView]!
    @IBOutlet var similarBtn: [UIButton]!
    @IBOutlet var newBtn: [UIButton]!
    @IBOutlet var oldBtn: [UIButton]!
    @IBOutlet var correctLabel: [UILabel]!
    @IBOutlet var incorrectLabel: [UILabel]!
    @IBOutlet var pSNextArrow: [UIButton]!
   // @IBOutlet var pCNextArrow: [UIButton]!
    @IBOutlet var pSScoreLabel: [UILabel]!
    @IBOutlet var pSScoreVal: [UILabel]!
    @IBOutlet var pSBestVal: [UILabel]!
    @IBOutlet var pSBestLabel: [UILabel]!
    var imgCount = 0
    
    
    //Tutorial Player
    var playerLooper: AVPlayerLooper!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var player: AVQueuePlayer!
   
    var screenSize = UIScreen.main.bounds.size
    var cellChecker: Timer! //Timer used to update cells of the board
    
    @IBOutlet weak var portraitView: SKView!
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
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: ".mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch{
            print(error);
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isPortrait{
            portraitView.isHidden = false
        }
        else{
            portraitView.isHidden = true
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
        scene.game.currentGameStage = 1
        for btn in startBtn {
            btn.isHidden = true
        }
        //(startBtn as NSArray).setValue(true, forKey: "isHidden")
        //(nextButton as NSArray).setValue(false, forKey: "isHidden")

        scene.game.StartPatternCompletion()
        //(pCLabel as NSArray).setValue("Number of Blocks Left: " + String(scene.game.cellRemaining), forKey: "text")

        cellChecker = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextButtonEnable), userInfo: nil, repeats: true)
    }
    
    //Updates whether the next button is disabled or not
    @objc func nextButtonEnable(){
        if(scene.game.cellRemaining == 0){
            //(nextButton as NSArray).setValue(true, forKey: "isEnabled")
        }
        else{
            //(nextButton as NSArray).setValue(false, forKey: "isEnabled")
        }
    }

    //Mutes or plays music
    @IBAction func MuteMusic(_ sender: Any) {
        if(audioPlayer.isPlaying == true){
            audioPlayer.stop()
            muteMusic.setImage(UIImage(named: "PlayMusic"), for: .normal)
        }
        else {
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            muteMusic.setImage(UIImage(named: "MuteMusic"), for: .normal)
        }
    }
    
    //Takes user to game summary screen.
    //Screen objects are moved and updated
    @IBAction func nextButton(_ sender: Any) {
        if(scene.game.currentRound == 9){
            
            (nextButton as NSArray).setValue("SCORES", forKey: "text")
            
            (pCLabel as NSArray).setValue(true, forKey: "isHidden")
            (scoreLabel as NSArray).setValue(false, forKey: "isHidden")
            (scoreValue as NSArray).setValue(false, forKey: "isHidden")
            (best as NSArray).setValue(false, forKey: "isHidden")
            (bestValue as NSArray).setValue(false, forKey: "isHidden")

            scene.game.FinishPatternCompletionRound()
            
            for i in 0...9{
                scene.game.finalScore += scene.game.score[i]
            }
           
            (nextArrow as NSArray).setValue(true, forKey: "isHidden")
            (nextButton as NSArray).setValue(true, forKey: "isHidden")
            (pcHistoryNext as NSArray).setValue(false, forKey: "isHidden")

            scene.InitiateSummary()
            
            (scoreValue as NSArray).setValue(String(scene.game.finalScore), forKey: "text")
            (bestValue as NSArray).setValue(String(scene.game.finalScore), forKey: "text")

            scene.game.timeUpdate.invalidate()
            scene.game.currentRound += 1
            print(scene.game.currentRound)
            print(scene.game.currentRound)
        }
        else if(scene.game.currentRound < 9){
            (nextButton as NSArray).setValue(true, forKey: "isHidden")
            (startBtn as NSArray).setValue(false, forKey: "isHidden")

            scene.game.FinishPatternCompletionRound()
            scene.game.currentRound += 1
            scene.game.InitializePatternCompletion()
            
        }
            //For now next button will show performance history
            //replace this with actual left and right buttons to scroll through
    }
    
    @IBAction func PCHistoryNext(_ sender: Any) {
        scene.game.PCnum += 1
        scene.InitiateSummary()
        if(scene.game.PCnum >= 9){
            (nextArrow as NSArray).setValue(false, forKey: "isHidden")
            (pcHistoryNext as NSArray).setValue(true, forKey: "isHidden")
        }
    }
    
    //Start PatternSepartion
    @IBAction func StartPs(_ sender: Any) {
        (patternCompletion as NSArray).setValue("Pattern Separation", forKey: "text")

        scene.game.currentGameStage = 2
        scene.removeAllChildren()
        scene.game.InitializePatternSeparation()
        (pSImageView as NSArray).setValue(UIImage(named: String(scene.game.image)), forKey: "image")
        
        (nextArrow as NSArray).setValue(true, forKey: "isHidden")
        (pSImageView as NSArray).setValue(false, forKey: "isHidden")
        (newBtn as NSArray).setValue(false, forKey: "isHidden")
        (oldBtn as NSArray).setValue(false, forKey: "isHidden")
        (similarBtn as NSArray).setValue(false, forKey: "isHidden")
        (best as NSArray).setValue(true, forKey: "isHidden")
        (bestValue as NSArray).setValue(true, forKey: "isHidden")
        (scoreLabel as NSArray).setValue(true, forKey: "isHidden")
        (scoreValue as NSArray).setValue(true, forKey: "isHidden")


    }
    
    //User taps Similar Button
    @IBAction func Similar(_ sender: Any) {
        if(scene.game.currentGameStage != 3){
            scene.game.FinishPatternSeparation(answer: 1)
            buttonPressed()
        }
    }
    
    //User taps New Button
    @IBAction func New(_ sender: Any) {
        if(scene.game.currentGameStage != 3){
            scene.game.FinishPatternSeparation(answer: 2)
            buttonPressed()
        }
    }
    
    //User taps Old Button
    @IBAction func Old(_ sender: Any) {
        if(scene.game.currentGameStage != 3){
            scene.game.FinishPatternSeparation(answer: 3)
            buttonPressed()
        }
    }
  
    //User pressed New, Old or Similar
    func buttonPressed(){
        if(scene.game.pSRound <= 15){
            scene.game.InitializePatternSeparation()
            (pSImageView as NSArray).setValue(UIImage(named: String(scene.game.image)), forKey: "image")
        }
        else {
            scene.game.currentGameStage = 3
            scene.game.CalculateScorePS()

            (pSScoreVal as NSArray).setValue(String(scene.game.pSScore), forKey: "text")
            (pSBestVal as NSArray).setValue(String(scene.game.pSScore), forKey: "text")
            
            (pSBestVal as NSArray).setValue(false, forKey: "isHidden")
            (pSScoreVal as NSArray).setValue(false, forKey: "isHidden")
            (pSBestLabel as NSArray).setValue(false, forKey: "isHidden")
            (pSScoreLabel as NSArray).setValue(false, forKey: "isHidden")

            (pSImageView as NSArray).setValue(UIImage(named: String(scene.game.questions[0])), forKey: "image")

            (pSNextArrow as NSArray).setValue(false, forKey: "isHidden")

            
            if(scene.game.userAnswers[0] == 1){
                (similarBtn as NSArray).setValue(true, forKey: "isEnabled")
                (oldBtn as NSArray).setValue(false, forKey: "isEnabled")
                (newBtn as NSArray).setValue(false, forKey: "isEnabled")
            }
            else if(scene.game.userAnswers[0] == 2){
                (similarBtn as NSArray).setValue(false, forKey: "isEnabled")
                (oldBtn as NSArray).setValue(false, forKey: "isEnabled")
                (newBtn as NSArray).setValue(true, forKey: "isEnabled")
            }
            else{
                (similarBtn as NSArray).setValue(false, forKey: "isEnabled")
                (oldBtn as NSArray).setValue(true, forKey: "isEnabled")
                (newBtn as NSArray).setValue(false, forKey: "isEnabled")
            }
            
            if(scene.game.userAnswers[0] == scene.game.correctAnswer[0]){
                (correctLabel as NSArray).setValue(false, forKey: "isHidden")
                (incorrectLabel as NSArray).setValue(true, forKey: "isHidden")
            }
            else{
                (correctLabel as NSArray).setValue(true, forKey: "isHidden")
                (incorrectLabel as NSArray).setValue(false, forKey: "isHidden")
            }
        }
    }
    
    //Displays next round in PatternSeparation summary
    @IBAction func PSNext(_ sender: Any) {
        imgCount+=1
        
        if(imgCount == 14){
            performSegue(withIdentifier: "ReturnHome", sender: self)
        }
        
        (pSImageView as NSArray).setValue(UIImage(named: String(scene.game.questions[imgCount])), forKey: "image")

        
        if(scene.game.userAnswers[imgCount] == 1){
            (similarBtn as NSArray).setValue(true, forKey: "isEnabled")
            (oldBtn as NSArray).setValue(false, forKey: "isEnabled")
            (newBtn as NSArray).setValue(false, forKey: "isEnabled")
        }
        else if(scene.game.userAnswers[imgCount] == 2){
            (similarBtn as NSArray).setValue(false, forKey: "isEnabled")
            (oldBtn as NSArray).setValue(false, forKey: "isEnabled")
            (newBtn as NSArray).setValue(true, forKey: "isEnabled")
        }
        else{
            (similarBtn as NSArray).setValue(false, forKey: "isEnabled")
            (oldBtn as NSArray).setValue(true, forKey: "isEnabled")
            (newBtn as NSArray).setValue(false, forKey: "isEnabled")
        }
        
        if(scene.game.userAnswers[imgCount] == scene.game.correctAnswer[imgCount]){
            (correctLabel as NSArray).setValue(false, forKey: "isHidden")
            (incorrectLabel as NSArray).setValue(true, forKey: "isHidden")
        }
        else{
            (correctLabel as NSArray).setValue(true, forKey: "isHidden")
            (incorrectLabel as NSArray).setValue(false, forKey: "isHidden")
        }
    }
    
    
}
