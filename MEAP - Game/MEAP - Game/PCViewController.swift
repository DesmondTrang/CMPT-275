//
//  PCViewController.swift
//  MEAP - Game
//
//  Created by Angus  on 2018-11-01.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import UIKit
import SpriteKit

class PCViewController: UIViewController {

    @IBOutlet weak var bestValue: UILabel!
    @IBOutlet weak var best: UILabel!
    @IBOutlet weak var Unmuted: UIButton!
    @IBOutlet weak var muted: UIButton!
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var scoreValue: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var nextArrow: UIButton!
    @IBOutlet weak var PatternCompletion: UILabel!
    @IBOutlet weak var PClabel: UILabel!
    @IBOutlet weak var pausedView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    var cellChecker: Timer!
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        skView.presentScene(scene)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Pause(_ sender: Any) {
        pausedView.isHidden = false
        scene.game.paused = true
    }
    
    @IBAction func Resume(_ sender: Any) {
        scene.game.paused = false
        pausedView.isHidden = true
    }
    
    @IBAction func Mute(_ sender: Any) {
        muted.isHidden = false
        Unmuted.isHidden = true
    }
    
    @IBAction func Unmute(_ sender: Any) {
        muted.isHidden = true
        Unmuted.isHidden = false
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
