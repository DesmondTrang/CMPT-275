//
//  GameManager.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import SpriteKit

class GameManager{
    class gameBoard{
        var board = [[String]]()
    }
    
    var scene: GameScene!
    var score: UInt!
    var timer: UInt!
    var currentGameStage: UInt!
    var currentRound: UInt!
    var currentGameBoard = gameBoard()
    var gameBoardSolutions = [gameBoard]()
    var gameBoardUserAnswers = [gameBoard]()
    
    init(scene: GameScene) {
        self.scene = scene
        score = 0
        timer = 0
        currentGameStage = 0
        currentRound = 0
    }
    
    
}
