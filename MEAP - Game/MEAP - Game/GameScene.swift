//
//  GameScene.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
   
    var game: GameManager!
    override func didMove(to view: SKView) {
        game = GameManager(scene: self)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
