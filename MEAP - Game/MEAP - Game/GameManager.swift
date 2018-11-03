//
//  GameManager.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//

import SpriteKit

class GameManager{
    
    //Class for cell of the grid board
    class boardCell{
        var x: Int
        var y: Int
        var color: String
        init(X: Int, Y: Int, Color: String){
            x = X
            y = Y
            color = Color
        }
    }
    
    //Class Ccntaining the game board
    class gameBoard{
        var board = [[String]]()
        init(boardInfo: [boardCell]){
            board = Array(repeating: Array(repeating: "blue", count: 10), count: 10)
            for i in 0...boardInfo.count-1{
                board[boardInfo[i].x][boardInfo[i].y] = boardInfo[i].color
            }
        }
    }
    
    //In an array because future versions will contain multiple rounds
    var rounds = [[boardCell(X:5,Y:5,Color:"red"), boardCell(X:5,Y:4,Color:"red"), boardCell(X:5,Y:3,Color:"red"),boardCell(X:4,Y:3,Color:"red"),boardCell(X:3,Y:3,Color:"red")]]
    var startRounds = [[boardCell(X:5,Y:5,Color:"orange"),boardCell(X:3,Y:3,Color:"orange")]]
    
    var scene: GameScene!
    var score: Int!
    var timer: Int!
    var timeUpdate: Timer!
    var cellRemaining: Int!
    var gameStage: Int!
    //var currentGameStage: Int!
    var paused: Bool!
    //VErsion 2
    //var currentRound: UInt!
    var currentGameBoard: gameBoard!
    var gameBoardSolutions = [gameBoard]()
    var gameBoardUserAnswers = [gameBoard]()
    
    init(scene: GameScene) {
        self.scene = scene
        InitalizeGame()
        InitializePatternCompletion()
    }
    
    //Initalizes variables for start of game
    private func InitalizeGame(){
        score = 0
        timer = 0
        gameStage = 0
        paused = false
        //forVersion 2
        //currentGameStage = 0
        //currentRound = 0
    }
    
    //Initializes gameboard for pattern completion game mode
    func InitializePatternCompletion(){
        currentGameBoard = gameBoard(boardInfo: rounds[0])
        gameBoardSolutions.append(currentGameBoard)
    }
    
    //Starts phase of game where user is able to tap squares of the board and starts timer
    func StartPatternCompletion(){
        gameStage = 1
        currentGameBoard = gameBoard(boardInfo: startRounds[0])
        cellRemaining = rounds[0].count - startRounds[0].count
        timeUpdate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    //Finishs round of pattern Completion. Ends timer and Calculates score
    func FinishPatternCompletionRound(){
        gameStage = 2
        gameBoardUserAnswers.append(currentGameBoard)
        timeUpdate.invalidate()
        CalculateScore()
    }
    
    //Calculates score depending on time and correctness
    private func CalculateScore(){
        let total = rounds[0].count
        var count = 0;
        for i in 0...total-1{
            if(currentGameBoard.board[rounds[0][i].x][rounds[0][i].y] == "red"){
                count += 1
            }
        }
        score = timer + (count/total)*100
    }
    
    //Increments timer if not paused
    @objc func UpdateTimer(){
        if(paused == false){
            timer = timer + 1
        }
    }
    
    
    
}
