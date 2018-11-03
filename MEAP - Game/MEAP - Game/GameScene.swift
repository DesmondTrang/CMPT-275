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
   
    var touch: UITouch!
    var game: GameManager!
    var customBackGroundColor = UIColor(named: "backgroundColor")!
    let screenSize = UIScreen.main.bounds.size
    let cellWidth: CGFloat =  50
    var board = [[SKShapeNode]]()
    override func didMove(to view: SKView) {
        
        self.backgroundColor = customBackGroundColor
        game = GameManager(scene: self)
        InitiateBoard()
    }
    

    
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
                
                if(game.gameBoardSolutions[0].board[j][i] == "red"){
                    node.fillColor = SKColor.red
                }
                else{
                    node.fillColor = SKColor.blue
                }
                
                if(game.gameBoardUserAnswers[0].board[j][i] == "red"){
                    node1.fillColor = SKColor.red
                }
                else if(game.gameBoardUserAnswers[0].board[j][i] == "blue"){
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
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
        // Called before each frame is rendered
    }
}
