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
    @IBOutlet weak var bestValue: UILabel! //Value of best score
    @IBOutlet weak var best: UILabel!
    //@IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scoreValue: UILabel! //Value of score
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var nextArrow: UIButton!
    
    
    @IBOutlet weak var pcHistoryPrev: UIButton!
    @IBOutlet weak var pcHistoryNext: UIButton!
    @IBOutlet weak var patternCompletion: UILabel!
    @IBOutlet weak var pCLabel: UILabel!
    @IBOutlet weak var pausedView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var muteMusic: UIButton!
    @IBOutlet weak var tutorialView: UIView!
    
    //PS
    @IBOutlet weak var pSImageView: UIImageView!
    @IBOutlet weak var similarBtn: UIButton!
    @IBOutlet weak var newBtn: UIButton!
    @IBOutlet weak var oldBtn: UIButton!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var pSNextArrow: UIButton!
    @IBOutlet weak var pSPrevArrow: UIButton!
    @IBOutlet weak var pCNextArrow: UIButton!
    @IBOutlet weak var pSScoreLabel: UILabel!
    @IBOutlet weak var pSScoreVal: UILabel!
    @IBOutlet weak var pSBestVal: UILabel!
    @IBOutlet weak var pSBestLabel: UILabel!
    @IBOutlet weak var PSDone: UIButton!
    var imgCount = 0
    
   
    //Tutorial Player
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
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: ".mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
        catch{
            print(error);
        }
    }
    
    //plays and loops "Tutorial.mp4"
    private func PlayVideo(name: String){
        
        screenSize = UIScreen.main.bounds.size
        //Plays "Tutorial.mp4"
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: ".mp4")!))
        
        player = AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: ".mp4")!))
        
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
        PlayVideo(name: "tutorialPC")
        
    }
    @IBAction func PatternSeparationTutorial(_ sender: Any) {
        
        playerLayer.removeFromSuperlayer()
        player.replaceCurrentItem(with: nil)
        
        PlayVideo(name: "tutorialPS")
    }
    
    @IBAction func PatternCompletionTutorial(_ sender: Any) {
       
        playerLayer.removeFromSuperlayer()
        player.replaceCurrentItem(with: nil)
        
        PlayVideo(name: "tutorialPC")

        
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
        startBtn.isHidden = true
        nextButton.isHidden = false
        scene.game.StartPatternCompletion()
        pCLabel.text = "Number of Blocks Left: " + String(scene.game.cellRemaining)
        cellChecker = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextButtonEnable), userInfo: nil, repeats: true)
    }
    
    //Updates whether the next button is disabled or not
    @objc func nextButtonEnable(){
        pCLabel.text = "Number of Blocks Left: " + String(scene.game.cellRemaining)
        if(scene.game.cellRemaining == 0){
            nextButton.isEnabled = true
        }
        else{
            nextButton.isEnabled = false
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
            
            patternCompletion.text = "SCORES"
            pCLabel.isHidden = true
            scoreValue.center.x += 100
            scoreValue.center.y -= 150
            best.center.x -= 100
            best.center.y -= 150
            scoreLabel.center.x += 100
            scoreLabel.center.y -= 150
            bestValue.center.x -= 100
            bestValue.center.y -= 150
            scoreLabel.isHidden = false
            scoreValue.isHidden = false
            best.isHidden = false
            bestValue.isHidden = false
            scene.game.FinishPatternCompletionRound()
            
            for i in 0...9{
                scene.game.finalScore += scene.game.score[i]
            }
            nextArrow.isHidden = true
            nextButton.isHidden = true
            pcHistoryNext.isHidden = false
            pcHistoryPrev.isHidden = false
            scene.InitiateSummary()
            scoreValue.text = String(scene.game.finalScore)
            bestValue.text = String(scene.game.finalScore)
            scene.game.timeUpdate.invalidate()
            scene.game.currentRound += 1
            print(scene.game.currentRound)
            print(scene.game.currentRound)
        }
        else if(scene.game.currentRound < 9){
            nextButton.isHidden = true
            startBtn.isHidden = false
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
        if(scene.game.PCnum > 0){
            pcHistoryPrev.isEnabled = true
        }
        if(scene.game.PCnum >= 9){
            nextArrow.isHidden = false
            pcHistoryNext.isEnabled = false
        }
        else{
            pcHistoryNext.isEnabled = true
            nextArrow.isHidden = true
        }
    }
    
    @IBAction func PCHistoryPrev(_ sender: Any) {
        scene.game.PCnum -= 1
        scene.InitiateSummary()
        nextArrow.isHidden = true
        pcHistoryNext.isEnabled = true
        if(scene.game.PCnum == 0){
            pcHistoryPrev.isEnabled = false
        }
    }
    
    //Start PatternSepartion
    @IBAction func StartPs(_ sender: Any) {
        patternCompletion.text = "Pattern Separation"
        scene.game.currentGameStage = 2
        scene.removeAllChildren()
        scene.game.InitializePatternSeparation()
        pSImageView.image = UIImage(named: String(scene.game.image))
        pcHistoryPrev.isHidden = true
        pcHistoryNext.isHidden = true
        nextArrow.isHidden = true
        pSImageView.isHidden = false
        newBtn.isHidden = false
        oldBtn.isHidden = false
        similarBtn.isHidden = false
        best.isHidden = true
        bestValue.isHidden = true
        scoreLabel.isHidden = true
        scoreValue.isHidden = true
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
            pSImageView.image = UIImage(named: String(scene.game.image))
        }
        else {
            scene.game.currentGameStage = 3
            scene.game.CalculateScorePS()
            pSScoreVal.text = String(scene.game.pSScore)
            pSBestVal.text = String(scene.game.pSScore)
            pSBestVal.isHidden = false
            pSScoreVal.isHidden = false
            pSBestLabel.isHidden = false
            pSScoreLabel.isHidden = false
            pSImageView.image = UIImage(named: String(scene.game.questions[0]))
            pSNextArrow.isHidden = false
            pSPrevArrow.isHidden = false
            
            if(scene.game.userAnswers[0] == 1){
                similarBtn.isEnabled = true
                oldBtn.isEnabled = false
                newBtn.isEnabled = false
            }
            else if(scene.game.userAnswers[0] == 2){
                similarBtn.isEnabled = false
                oldBtn.isEnabled = false
                newBtn.isEnabled = true
            }
            else{
                similarBtn.isEnabled = false
                oldBtn.isEnabled = true
                newBtn.isEnabled = false
            }
            
            if(scene.game.userAnswers[0] == scene.game.correctAnswer[0]){
                correctLabel.isHidden = false
                incorrectLabel.isHidden = true
            }
            else{
                correctLabel.isHidden = true
                incorrectLabel.isHidden = false
            }
        }
    }
    
    //Displays next round in PatternSeparation summary
    @IBAction func PSNext(_ sender: Any) {
        imgCount+=1
        
        pSPrevArrow.isEnabled = true
        
        if(imgCount == 14){
            PSDone.isHidden = false
            pSNextArrow.isEnabled = false
        }
        
        pSImageView.image = UIImage(named: String(scene.game.questions[imgCount]))
        
        if(scene.game.userAnswers[imgCount] == 1){
            similarBtn.isEnabled = true
            oldBtn.isEnabled = false
            newBtn.isEnabled = false
        }
        else if(scene.game.userAnswers[imgCount] == 2){
            similarBtn.isEnabled = false
            oldBtn.isEnabled = false
            newBtn.isEnabled = true
        }
        else{
            similarBtn.isEnabled = false
            oldBtn.isEnabled = true
            newBtn.isEnabled = false
        }
        
        if(scene.game.userAnswers[imgCount] == scene.game.correctAnswer[imgCount]){
            correctLabel.isHidden = false
            incorrectLabel.isHidden = true
        }
        else{
            correctLabel.isHidden = true
            incorrectLabel.isHidden = false
        }
    }
    
    @IBAction func PSPrev(_ sender: Any) {
        imgCount -= 1
        
        PSDone.isHidden = true
        pSNextArrow.isEnabled = true
        
        if(imgCount == 0){
            pSPrevArrow.isEnabled = false
        }
        pSImageView.image = UIImage(named: String(scene.game.questions[imgCount]))
        
        if(scene.game.userAnswers[imgCount] == 1){
            similarBtn.isEnabled = true
            oldBtn.isEnabled = false
            newBtn.isEnabled = false
        }
        else if(scene.game.userAnswers[imgCount] == 2){
            similarBtn.isEnabled = false
            oldBtn.isEnabled = false
            newBtn.isEnabled = true
        }
        else{
            similarBtn.isEnabled = false
            oldBtn.isEnabled = true
            newBtn.isEnabled = false
        }
        
        if(scene.game.userAnswers[imgCount] == scene.game.correctAnswer[imgCount]){
            correctLabel.isHidden = false
            incorrectLabel.isHidden = true
        }
        else{
            correctLabel.isHidden = true
            incorrectLabel.isHidden = false
        }
    }
    
}
