//
//  PCViewController.swift
//  MEAP - Game
//
//  Created by Angus  on 2018-11-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class PCViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!;
    @IBOutlet weak var bestValue: UILabel!
    @IBOutlet weak var best: UILabel!
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var scoreValue: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var nextArrow: UIButton!
    @IBOutlet weak var PatternCompletion: UILabel!
    @IBOutlet weak var PClabel: UILabel!
    @IBOutlet weak var pausedView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var muteMusic: UIButton!
    var cellChecker: Timer!
    
    var scene: GameScene!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        audioPlayer.stop()
    }
    
    @IBAction func Pause(_ sender: Any) {
        pausedView.isHidden = false
        scene.game.paused = true
    }
    
    @IBAction func ResumeGame(_ sender: Any) {
        pausedView.isHidden = true
        scene.game.paused = false
    }
    
    @IBAction func Start(_ sender: Any) {
        startBtn.isHidden = true
        nextButton.isHidden = false
        scene.game.StartPatternCompletion()
        PClabel.text = "Number of Blocks Left: " + String(scene.game.cellRemaining)
        cellChecker = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(nextButtonEnable), userInfo: nil, repeats: true)
    }
    
    @objc func nextButtonEnable(){
        PClabel.text = "Number of Blocks Left: " + String(scene.game.cellRemaining)
        if(scene.game.cellRemaining == 0){
            nextButton.isEnabled = true
        }
        else{
            nextButton.isEnabled = false
        }
    }

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
    
    @IBAction func nextButton(_ sender: Any) {
        nextButton.isHidden = true
        PatternCompletion.text = "SCORES"
        PClabel.isHidden = true
        PageControl.isHidden = false
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
