//
//  GameScene.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 10/25/18
//           -File Completed - 11/2/18
//  Known Bugs: NONE!


import SpriteKit
import GameplayKit

//Generates the boards and makes board interactable
class GameScene: SKScene {
   
    var touch: UITouch!
    var game: GameManager! //Instance of game manager
    var customBackGroundColor = UIColor(named: "backgroundColor")!
    let screenSize = UIScreen.main.bounds.size //Size of screen
    let cellWidth: CGFloat =  50 //Width of cell of the board
    var board = [[SKShapeNode]]()
    
    //Initializes Scene
    override func didMove(to view: SKView) {
        
        self.backgroundColor = customBackGroundColor
        game = GameManager(scene: self)
        InitiateBoard()
    }
    

    //Creates empty board
    func InitiateBoard(){
        let height = screenSize.height
        let width = screenSize.width
        var x = CGFloat((width / 4)+50)
        var y = CGFloat(height*(3/4)+20)
        for _ in 0...9{
            var boardArray = [SKShapeNode]()
            for _ in 0...9{
                let node = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
                node.fillColor = SKColor.blue
                node.position = CGPoint(x: x, y: y)
                boardArray.append(node)
                self.addChild(node)
                x += cellWidth
            }
            board.append(boardArray)
            x = CGFloat((width / 4)+50)
            y -= cellWidth
        }
    }
    
    //Creates two separate boards containing the solution and user's answer side by side
    func InitiateSummary(){
        self.removeAllChildren()
        let height = screenSize.height
        var x1 = CGFloat(50)
        var x2 = CGFloat(600)
        var y = CGFloat(height*(3/4)-40)
        for i in 0...9{
            for j in 0...9{
                let node = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
                let node1 = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
                node.position = CGPoint(x: x1, y: y)
                node1.position = CGPoint(x: x2, y: y)
                
                if(game.gameBoardSolutions[game.PCnum].board[j][i] == "red"){
                    node.fillColor = SKColor.red
                }
                else{
                    node.fillColor = SKColor.blue
                }
                
                if(game.gameBoardUserAnswers[game.PCnum].board[j][i] == "red"){
                    node1.fillColor = SKColor.red
                }
                else if(game.gameBoardUserAnswers[game.PCnum].board[j][i] == "blue"){
                    node1.fillColor = SKColor.blue
                }
                else{
                    node1.fillColor = SKColor.orange
                }
                
                
                self.addChild(node)
                self.addChild(node1)
                x1 += cellWidth
                x2 += cellWidth
                
            }
            x1 = CGFloat(50)
            x2 = CGFloat(600)
            y -= cellWidth
        }
    }
    
    //Calculates which specific cell was tapped by user and updates cell/cell Count
    func touchDown(atPoint pos : CGPoint) {
        let height = screenSize.height
        let width = screenSize.width
        let x = Int(floor(((pos.x - ((width/4)+25))/50)))
        let y = Int(floor(((pos.y - (height-(height*(1/4)+508))))/50))
        if(x>=0 && x<=9 && y>0 && y<=10 && game.gameStage == 1){
            if(game.currentGameBoard.board[x][10-y] == "blue" && game.cellRemaining>0){
                game.currentGameBoard.board[x][10-y] = "red"
                game.cellRemaining = game.cellRemaining - 1
                //board[10-y][x].fillColor = SKColor.red
            }
            else if(game.currentGameBoard.board[x][10-y] == "red"){
                game.currentGameBoard.board[x][10-y] = "blue"
                game.cellRemaining = game.cellRemaining + 1
                //board[10-y][x].fillColor = SKColor.blue
            }
        }
    }
    
    //IOS function for tapping the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    //IOS function that updates board every frame
    //i and j are flipped because of how 2-D array was initialized
    override func update(_ currentTime: TimeInterval) {
        if(game.gameStage != 2){
        for i in 0...9{
            for j in 0...9{
                if(game.currentGameBoard.board[i][j] == "red"){
                    board[j][i].fillColor = SKColor.red
                }
                else if(game.currentGameBoard.board[i][j] == "blue" ){
                    board[j][i].fillColor = SKColor.blue
                }
                else{
                    board[j][i].fillColor = SKColor.orange
                }
            }
        }
        }
    }
}
