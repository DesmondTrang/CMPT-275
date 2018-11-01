//
//  GameViewController.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    ///Instances
    var audioPlayer: AVAudioPlayer!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


