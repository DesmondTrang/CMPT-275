//
//  GameManager.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen, Kavya Bohra
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 10/25/18
//           -File Completed for Version 1 - 11/2/18
//           -File Completed for Version 2 - 11/17/18
//  Known Bugs: NONE!



import SpriteKit

//Manages the state of the game
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
    
    //Contains information for the memorization phase board
    //In an array because future versions will contain multiple rounds
    //This is a 2D array that will contain all the board patterns
    var rounds = [[boardCell(X:5,Y:5,Color:"red"), boardCell(X:5,Y:4,Color:"red"), boardCell(X:5,Y:3,Color:"red"),boardCell(X:4,Y:3,Color:"red"),boardCell(X:3,Y:3,Color:"red")]]
    
    //Add PS images here
    
    
    //Contains information for the partial pattern board
    var startRounds = [[boardCell(X:5,Y:5,Color:"orange"),boardCell(X:3,Y:3,Color:"orange")]]
    
    var scene: GameScene!
    var score: Int!
    var timer: Double!
    var timeUpdate: Timer! //Used to update timer
    var cellRemaining: Int!
    var gameStage: Int!
    var paused: Bool!
    //Version 2
    //var currentRound: UInt!
    //var currentGameStage: Int!
    var currentGameBoard: gameBoard!
    var gameBoardSolutions = [gameBoard]() //Stores solutions for summary and score calculation
    var gameBoardUserAnswers = [gameBoard]() //Stores user answers for summary and score calulation
    
    //Scene initalization
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
        
        let temp = 5*(((Double(count)/Double(total-startRounds[0].count)) - (0.005*timer)))
        score = Int(round(pow(2.718,temp)))
    }
    
    //Increments timer if not paused
    @objc func UpdateTimer(){
        if(paused == false){
            timer = timer + 1
        }
    }
}
