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

    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var scoreValue: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var nextArrow: UIButton!
    @IBOutlet weak var PatternCompletion: UILabel!
    @IBOutlet weak var PClabel: UILabel!
    var scene: GameScene!
    var cellChecker: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene = GameScene(size: view.bounds.size)
        let skView = self.view as! SKView
        
        skView.presentScene(scene)
        // Do any additional setup after loading the view.
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
