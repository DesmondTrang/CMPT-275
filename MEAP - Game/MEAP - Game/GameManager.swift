//
//  GameManager.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen, Amir Fazelipour
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 10/25/18
//           -File Completed - 11/2/18
//           -Implemented Pattern Separation - 11/18/2018
//           -Updated Pattern Completion - 11/18/2018
//  Known Bugs: NONE!



import SpriteKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

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
    //3D array containing PC patterns for different levels
    var rounds = [
        [//Easy
            [boardCell(X:5,Y:5,Color:"red"), boardCell(X:5,Y:4,Color:"red"), boardCell(X:5,Y:3,Color:"red"),boardCell(X:4,Y:3,Color:"red"),boardCell(X:3,Y:3,Color:"red"),boardCell(X:2,Y:3,Color:"red")],
            [boardCell(X:0,Y:0,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:1,Y:4,Color:"red")],
            [boardCell(X:2,Y:6,Color:"red"), boardCell(X:2,Y:7,Color:"red"), boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red")],
            [boardCell(X:5,Y:1,Color:"red"), boardCell(X:5,Y:2,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:5,Y:7,Color:"red"),boardCell(X:5,Y:8,Color:"red")],
            [boardCell(X:3,Y:7,Color:"red"), boardCell(X:4,Y:7,Color:"red"), boardCell(X:5,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:4,Y:9,Color:"red")],
            //Easy (same as above) replace with new patterns later
            [boardCell(X:6,Y:4,Color:"red"), boardCell(X:5,Y:4,Color:"red"), boardCell(X:5,Y:3,Color:"red"),boardCell(X:4,Y:3,Color:"red"),boardCell(X:3,Y:3,Color:"red"),boardCell(X:2,Y:3,Color:"red")],
            [boardCell(X:1,Y:1,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:1,Y:4,Color:"red")],
            [boardCell(X:3,Y:7,Color:"red"), boardCell(X:2,Y:7,Color:"red"), boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red")],
            [boardCell(X:6,Y:2,Color:"red"), boardCell(X:5,Y:2,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:5,Y:7,Color:"red"),boardCell(X:5,Y:8,Color:"red")],
            [boardCell(X:3,Y:6,Color:"red"), boardCell(X:4,Y:7,Color:"red"), boardCell(X:5,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:4,Y:9,Color:"red")]
        ],
        //////////////////////////////////////////////////////////////////////////////////////////////////
        [//Medium
            [boardCell(X:4,Y:6,Color:"red"), boardCell(X:5,Y:6,Color:"red"), boardCell(X:6,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:8,Y:5,Color:"red"),boardCell(X:8,Y:4,Color:"red"),boardCell(X:7,Y:4,Color:"red")],
            [boardCell(X:2,Y:3,Color:"red"), boardCell(X:3,Y:3,Color:"red"), boardCell(X:4,Y:3,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:5,Y:7,Color:"red")],
            [boardCell(X:9,Y:9,Color:"red"), boardCell(X:8,Y:9,Color:"red"), boardCell(X:7,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:3,Y:7,Color:"red")],
            [boardCell(X:3,Y:3,Color:"red"), boardCell(X:4,Y:3,Color:"red"), boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:5,Y:7,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:3,Y:7,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:3,Y:5,Color:"red"),boardCell(X:3,Y:4,Color:"red")],
            [boardCell(X:2,Y:8,Color:"red"), boardCell(X:3,Y:8,Color:"red"), boardCell(X:4,Y:8,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red")],
            //Medium (same as above) replace with new patterns later
            [boardCell(X:4,Y:6,Color:"red"), boardCell(X:5,Y:6,Color:"red"), boardCell(X:6,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:8,Y:5,Color:"red"),boardCell(X:8,Y:4,Color:"red"),boardCell(X:7,Y:4,Color:"red")],
            [boardCell(X:2,Y:3,Color:"red"), boardCell(X:3,Y:3,Color:"red"), boardCell(X:4,Y:3,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:5,Y:7,Color:"red")],
            [boardCell(X:9,Y:9,Color:"red"), boardCell(X:8,Y:9,Color:"red"), boardCell(X:7,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:3,Y:7,Color:"red")],
            [boardCell(X:3,Y:3,Color:"red"), boardCell(X:4,Y:3,Color:"red"), boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:5,Y:7,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:3,Y:7,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:3,Y:5,Color:"red"),boardCell(X:3,Y:4,Color:"red")],
            [boardCell(X:2,Y:8,Color:"red"), boardCell(X:3,Y:8,Color:"red"), boardCell(X:4,Y:8,Color:"red"),boardCell(X:4,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red")]
        ],
        //////////////////////////////////////////////////////////////////////////////////////////////////
        [//Hard
            [boardCell(X:2,Y:6,Color:"red"), boardCell(X:2,Y:5,Color:"red"), boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:3,Color:"red"),boardCell(X:3,Y:3,Color:"red"),boardCell(X:4,Y:3,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:6,Y:3,Color:"red"),boardCell(X:6,Y:4,Color:"red"),boardCell(X:6,Y:5,Color:"red"),boardCell(X:7,Y:5,Color:"red"),boardCell(X:8,Y:5,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:8,Y:7,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:7,Y:8,Color:"red")],
            [boardCell(X:3,Y:8,Color:"red"), boardCell(X:3,Y:7,Color:"red"), boardCell(X:3,Y:6,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:6,Y:4,Color:"red"),boardCell(X:7,Y:4,Color:"red"),boardCell(X:8,Y:4,Color:"red"),boardCell(X:9,Y:4,Color:"red"),boardCell(X:9,Y:5,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:8,Y:7,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:6,Y:7,Color:"red")],
            [boardCell(X:7,Y:3,Color:"red"), boardCell(X:7,Y:4,Color:"red"), boardCell(X:7,Y:5,Color:"red"),boardCell(X:6,Y:5,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:5,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:3,Y:5,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:1,Y:3,Color:"red"),boardCell(X:0,Y:2,Color:"red")],
            [boardCell(X:1,Y:4,Color:"red"), boardCell(X:2,Y:4,Color:"red"), boardCell(X:3,Y:4,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:6,Y:4,Color:"red"),boardCell(X:6,Y:5,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:8,Y:7,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:9,Y:5,Color:"red"),boardCell(X:8,Y:4,Color:"red")],
            [boardCell(X:7,Y:1,Color:"red"), boardCell(X:7,Y:2,Color:"red"), boardCell(X:8,Y:2,Color:"red"),boardCell(X:9,Y:2,Color:"red"),boardCell(X:9,Y:3,Color:"red"),boardCell(X:1,Y:6,Color:"red"),boardCell(X:1,Y:7,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:6,Y:3,Color:"red")],
            //Hard (same as above) replace with new patterns later
            [boardCell(X:2,Y:6,Color:"red"), boardCell(X:2,Y:5,Color:"red"), boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:3,Color:"red"),boardCell(X:3,Y:3,Color:"red"),boardCell(X:4,Y:3,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:6,Y:3,Color:"red"),boardCell(X:6,Y:4,Color:"red"),boardCell(X:6,Y:5,Color:"red"),boardCell(X:7,Y:5,Color:"red"),boardCell(X:8,Y:5,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:8,Y:7,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:7,Y:8,Color:"red")],
            [boardCell(X:3,Y:8,Color:"red"), boardCell(X:3,Y:7,Color:"red"), boardCell(X:3,Y:6,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:6,Y:4,Color:"red"),boardCell(X:7,Y:4,Color:"red"),boardCell(X:8,Y:4,Color:"red"),boardCell(X:9,Y:4,Color:"red"),boardCell(X:9,Y:5,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:8,Y:7,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:6,Y:7,Color:"red")],
            [boardCell(X:7,Y:3,Color:"red"), boardCell(X:7,Y:4,Color:"red"), boardCell(X:7,Y:5,Color:"red"),boardCell(X:6,Y:5,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:5,Y:7,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:3,Y:5,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:1,Y:3,Color:"red"),boardCell(X:0,Y:2,Color:"red")],
            [boardCell(X:1,Y:4,Color:"red"), boardCell(X:2,Y:4,Color:"red"), boardCell(X:3,Y:4,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:6,Y:4,Color:"red"),boardCell(X:6,Y:5,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:8,Y:7,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:9,Y:5,Color:"red"),boardCell(X:8,Y:4,Color:"red")],
            [boardCell(X:7,Y:1,Color:"red"), boardCell(X:7,Y:2,Color:"red"), boardCell(X:8,Y:2,Color:"red"),boardCell(X:9,Y:2,Color:"red"),boardCell(X:9,Y:3,Color:"red"),boardCell(X:1,Y:6,Color:"red"),boardCell(X:1,Y:7,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:6,Y:3,Color:"red")]
        ],
        //////////////////////////////////////////////////////////////////////////////////////////////////
        [//Extreme
            [boardCell(X:0,Y:0,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:0,Y:5,Color:"red"),boardCell(X:0,Y:6,Color:"red"),boardCell(X:0,Y:7,Color:"red"),boardCell(X:0,Y:8,Color:"red"),boardCell(X:0,Y:9,Color:"red"),boardCell(X:1,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:5,Y:8,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red")],
            [boardCell(X:1,Y:2,Color:"red"), boardCell(X:1,Y:3,Color:"red"), boardCell(X:2,Y:3,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:6,Y:7,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:1,Color:"red"),boardCell(X:2,Y:0,Color:"red"),boardCell(X:1,Y:0,Color:"red"),boardCell(X:0,Y:0,Color:"red")],
            //Extreme duplicates of above 2
            [boardCell(X:0,Y:0,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:0,Y:5,Color:"red"),boardCell(X:0,Y:6,Color:"red"),boardCell(X:0,Y:7,Color:"red"),boardCell(X:0,Y:8,Color:"red"),boardCell(X:0,Y:9,Color:"red"),boardCell(X:1,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:5,Y:8,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red")],
            [boardCell(X:1,Y:2,Color:"red"), boardCell(X:1,Y:3,Color:"red"), boardCell(X:2,Y:3,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:6,Y:7,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:1,Color:"red"),boardCell(X:2,Y:0,Color:"red"),boardCell(X:1,Y:0,Color:"red"),boardCell(X:0,Y:0,Color:"red")],
            [boardCell(X:0,Y:0,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:0,Y:5,Color:"red"),boardCell(X:0,Y:6,Color:"red"),boardCell(X:0,Y:7,Color:"red"),boardCell(X:0,Y:8,Color:"red"),boardCell(X:0,Y:9,Color:"red"),boardCell(X:1,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:5,Y:8,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red")],
            [boardCell(X:1,Y:2,Color:"red"), boardCell(X:1,Y:3,Color:"red"), boardCell(X:2,Y:3,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:6,Y:7,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:1,Color:"red"),boardCell(X:2,Y:0,Color:"red"),boardCell(X:1,Y:0,Color:"red"),boardCell(X:0,Y:0,Color:"red")],
            [boardCell(X:0,Y:0,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:0,Y:5,Color:"red"),boardCell(X:0,Y:6,Color:"red"),boardCell(X:0,Y:7,Color:"red"),boardCell(X:0,Y:8,Color:"red"),boardCell(X:0,Y:9,Color:"red"),boardCell(X:1,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:5,Y:8,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red")],
            [boardCell(X:1,Y:2,Color:"red"), boardCell(X:1,Y:3,Color:"red"), boardCell(X:2,Y:3,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:6,Y:7,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:1,Color:"red"),boardCell(X:2,Y:0,Color:"red"),boardCell(X:1,Y:0,Color:"red"),boardCell(X:0,Y:0,Color:"red")],
            [boardCell(X:0,Y:0,Color:"red"), boardCell(X:0,Y:1,Color:"red"), boardCell(X:0,Y:2,Color:"red"),boardCell(X:0,Y:3,Color:"red"),boardCell(X:0,Y:4,Color:"red"),boardCell(X:0,Y:5,Color:"red"),boardCell(X:0,Y:6,Color:"red"),boardCell(X:0,Y:7,Color:"red"),boardCell(X:0,Y:8,Color:"red"),boardCell(X:0,Y:9,Color:"red"),boardCell(X:1,Y:9,Color:"red"),boardCell(X:2,Y:9,Color:"red"),boardCell(X:3,Y:9,Color:"red"),boardCell(X:4,Y:9,Color:"red"),boardCell(X:5,Y:9,Color:"red"),boardCell(X:6,Y:9,Color:"red"),boardCell(X:7,Y:9,Color:"red"),boardCell(X:8,Y:9,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:9,Y:8,Color:"red"),boardCell(X:9,Y:7,Color:"red"),boardCell(X:9,Y:6,Color:"red"),boardCell(X:8,Y:6,Color:"red"),boardCell(X:7,Y:6,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:5,Color:"red"),boardCell(X:2,Y:6,Color:"red"),boardCell(X:2,Y:7,Color:"red"),boardCell(X:2,Y:8,Color:"red"),boardCell(X:3,Y:8,Color:"red"),boardCell(X:4,Y:8,Color:"red"),boardCell(X:5,Y:8,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red")],
            [boardCell(X:1,Y:2,Color:"red"), boardCell(X:1,Y:3,Color:"red"), boardCell(X:2,Y:3,Color:"red"),boardCell(X:6,Y:8,Color:"red"),boardCell(X:7,Y:8,Color:"red"),boardCell(X:6,Y:7,Color:"red"),boardCell(X:6,Y:6,Color:"red"),boardCell(X:5,Y:6,Color:"red"),boardCell(X:4,Y:5,Color:"red"),boardCell(X:9,Y:9,Color:"red"),boardCell(X:8,Y:8,Color:"red"),boardCell(X:7,Y:7,Color:"red"),boardCell(X:5,Y:3,Color:"red"),boardCell(X:5,Y:4,Color:"red"),boardCell(X:5,Y:5,Color:"red"),boardCell(X:4,Y:4,Color:"red"),boardCell(X:3,Y:4,Color:"red"),boardCell(X:2,Y:4,Color:"red"),boardCell(X:2,Y:1,Color:"red"),boardCell(X:2,Y:0,Color:"red"),boardCell(X:1,Y:0,Color:"red"),boardCell(X:0,Y:0,Color:"red")]
        ]
    ]
    
    //Contains information for the partial pattern board
    var startRounds = [
        [//Easy
            [boardCell(X:5,Y:5,Color:"orange"),boardCell(X:3,Y:3,Color:"orange")],
            [boardCell(X:0,Y:0,Color:"orange"),boardCell(X:0,Y:4,Color:"orange")],
            [boardCell(X:3,Y:8,Color:"orange"),boardCell(X:2,Y:7,Color:"orange"),boardCell(X:4,Y:7,Color:"orange")],
            [boardCell(X:5,Y:2,Color:"orange"),boardCell(X:5,Y:7,Color:"orange"),boardCell(X:5,Y:4,Color:"orange")],
            [boardCell(X:4,Y:6,Color:"orange"),boardCell(X:4,Y:9,Color:"orange")],
            //Easy 2 (repeated)
            [boardCell(X:6,Y:4,Color:"orange"),boardCell(X:3,Y:3,Color:"orange")],
            [boardCell(X:1,Y:1,Color:"orange"),boardCell(X:0,Y:4,Color:"orange")],
            [boardCell(X:3,Y:8,Color:"orange"),boardCell(X:2,Y:7,Color:"orange"),boardCell(X:4,Y:7,Color:"orange")],
            [boardCell(X:5,Y:2,Color:"orange"),boardCell(X:5,Y:7,Color:"orange"),boardCell(X:5,Y:4,Color:"orange")],
            [boardCell(X:4,Y:6,Color:"orange"),boardCell(X:4,Y:9,Color:"orange")]
        ],
        [//Medium
            [boardCell(X:8,Y:5,Color:"orange"),boardCell(X:7,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange"),boardCell(X:5,Y:7,Color:"orange")],
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:4,Y:9,Color:"orange"),boardCell(X:2,Y:9,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:3,Y:7,Color:"orange")],
            [boardCell(X:3,Y:3,Color:"orange"),boardCell(X:5,Y:7,Color:"orange")],
            [boardCell(X:2,Y:8,Color:"orange"),boardCell(X:2,Y:6,Color:"orange"),boardCell(X:2,Y:4,Color:"orange")],
            //Medium 2 (repeated)
            [boardCell(X:8,Y:5,Color:"orange"),boardCell(X:7,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange"),boardCell(X:5,Y:7,Color:"orange")],
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:4,Y:9,Color:"orange"),boardCell(X:2,Y:9,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:3,Y:7,Color:"orange")],
            [boardCell(X:3,Y:3,Color:"orange"),boardCell(X:5,Y:7,Color:"orange")],
            [boardCell(X:2,Y:8,Color:"orange"),boardCell(X:2,Y:6,Color:"orange"),boardCell(X:2,Y:4,Color:"orange")]
        ],
        [//Hard
            [boardCell(X:2,Y:3,Color:"orange"),boardCell(X:6,Y:4,Color:"orange"),boardCell(X:8,Y:5,Color:"orange"),boardCell(X:7,Y:8,Color:"orange")],
            [boardCell(X:3,Y:8,Color:"orange"),boardCell(X:2,Y:6,Color:"orange"),boardCell(X:9,Y:4,Color:"orange"),boardCell(X:9,Y:9,Color:"orange"),boardCell(X:6,Y:7,Color:"orange")],
            [boardCell(X:7,Y:3,Color:"orange"),boardCell(X:5,Y:5,Color:"orange"),boardCell(X:0,Y:2,Color:"orange")],
            [boardCell(X:1,Y:4,Color:"orange"),boardCell(X:8,Y:6,Color:"orange"),boardCell(X:9,Y:9,Color:"orange")],
            [boardCell(X:9,Y:3,Color:"orange"),boardCell(X:2,Y:9,Color:"orange")],
            //Hard 2 (repeated)
            [boardCell(X:2,Y:3,Color:"orange"),boardCell(X:6,Y:4,Color:"orange"),boardCell(X:8,Y:5,Color:"orange"),boardCell(X:7,Y:8,Color:"orange")],
            [boardCell(X:3,Y:8,Color:"orange"),boardCell(X:2,Y:6,Color:"orange"),boardCell(X:9,Y:4,Color:"orange"),boardCell(X:9,Y:9,Color:"orange"),boardCell(X:6,Y:7,Color:"orange")],
            [boardCell(X:7,Y:3,Color:"orange"),boardCell(X:5,Y:5,Color:"orange"),boardCell(X:0,Y:2,Color:"orange")],
            [boardCell(X:1,Y:4,Color:"orange"),boardCell(X:8,Y:6,Color:"orange"),boardCell(X:9,Y:9,Color:"orange")],
            [boardCell(X:9,Y:3,Color:"orange"),boardCell(X:2,Y:9,Color:"orange")]
        ],
        [//Extreme
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:2,Y:4,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:7,Y:7,Color:"orange"),boardCell(X:9,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange")],
            //Extreme 2 (duplicates of above 2)
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:2,Y:4,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:7,Y:7,Color:"orange"),boardCell(X:9,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange")],
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:2,Y:4,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:7,Y:7,Color:"orange"),boardCell(X:9,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange")],
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:2,Y:4,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:7,Y:7,Color:"orange"),boardCell(X:9,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange")],
            [boardCell(X:9,Y:9,Color:"orange"),boardCell(X:2,Y:4,Color:"orange"),boardCell(X:2,Y:8,Color:"orange"),boardCell(X:7,Y:7,Color:"orange"),boardCell(X:9,Y:6,Color:"orange")],
            [boardCell(X:4,Y:4,Color:"orange")]
        ]
    ]
    
    var PCnum: Int!
    
    var scene: GameScene!
    var randomIndex: Int!
    var score = Array(repeating: 0, count: 10)
    var finalScore: Int!
    var timer: Double!
    var timeUpdate: Timer! //Used to update timer
    var cellRemaining: Int!
    var gameStage: Int!
    var PC: Bool!
    var paused: Bool!
    //Version 2
    var currentRound: Int!
    var currentGameStage: Int!
    var currentGameBoard: gameBoard!
    var gameBoardSolutions = [gameBoard]() //Stores solutions for summary and score calculation
    var gameBoardUserAnswers = [gameBoard]() //Stores user answers for summary and score calulation
    var userLevel: Int! //Easy = 0, Medium = 1, Hard = 2, Extreme = 3
    var multiplier: Double! //Easy = 1, Medium = 2, Hard = 3, Extreme = 4
    var percentageCompleted: Double!
    var levelUpIfTwo: Int!
    var levelDownIfTwo: Int!
    var appUser: String = "appUser"
    
    //Scene initalization
    init(scene: GameScene) {
        self.scene = scene
        InitalizeGame()
        InitializePatternCompletion()
        
    }
    
    //Initalizes variables for start of game
    private func InitalizeGame(){
        
        // writes username to core data
        let userNamePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(self.appUser)"
        let userNameUrl: URL = URL(fileURLWithPath: userNamePath)
        let userName = try? String(contentsOf: userNameUrl, encoding: .utf8)
        var getUserLevel: String = "easy" // default
        userLevel = 0 // default
        
        // query firebase for specific data
        let db = Firestore.firestore()
        db.collection("appUser").whereField("userName", isEqualTo: userName!).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    getUserLevel = document.get("userLevel") as! String
                }
                if (getUserLevel == "easy") {
                    self.userLevel = 0
                }
                else if (getUserLevel == "normal") {
                    self.userLevel = 1
                }
                else if (getUserLevel == "hard") {
                    self.userLevel = 2
                }
                else if (getUserLevel == "extreme") {
                    self.userLevel = 3
                }
                print (getUserLevel)
                print (self.userLevel)
                self.timer = 0
                self.gameStage = 0
                self.paused = false
                //forVersion 2
                self.currentGameStage = 0
                self.currentRound = 0
                self.finalScore = 0
                self.randomIndex = 0
                self.multiplier = 0
                self.PC = true
                self.levelUpIfTwo = 0
                self.levelDownIfTwo = 0
                self.percentageCompleted = 0
                self.PCnum = 0
                self.InitializePatternCompletion()
            }
        }
    }
    
    //Initializes gameboard for pattern completion game mode
    func InitializePatternCompletion(){
        timer = 0
        percentageCompleted = 0
        PC = true
        
        //Generate random index based on userLevel
        print( "here")
        print (userLevel)
        randomIndex = Int(arc4random_uniform(UInt32(rounds[userLevel].count)))
        
        if(rounds[userLevel][randomIndex].count - startRounds[userLevel][randomIndex].count <= 5){
            multiplier = 1
        }
        else if(rounds[userLevel][randomIndex].count - startRounds[userLevel][randomIndex].count <= 10 &&  rounds[userLevel][randomIndex].count - startRounds[userLevel][randomIndex].count > 5){
            multiplier = 2
        }
        else if(rounds[userLevel][randomIndex].count - startRounds[userLevel][randomIndex].count <= 20 && rounds[userLevel][randomIndex].count - startRounds[userLevel][randomIndex].count > 10){
            multiplier = 3
        }
        else{
            multiplier = 4
        }
        
        //Get pattern from rounds at randomIndex
        currentGameBoard = gameBoard(boardInfo: rounds[userLevel][randomIndex])
        gameBoardSolutions.append(currentGameBoard)
    }
    
    //Starts phase of game where user is able to tap squares of the board and starts timer
    func StartPatternCompletion(){
        gameStage = 1
        currentGameBoard = gameBoard(boardInfo: startRounds[userLevel][randomIndex])
        cellRemaining = rounds[userLevel][randomIndex].count - startRounds[userLevel][randomIndex].count
        timeUpdate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }
    
    //Finishs round of pattern Completion. Ends timer and Calculates score
    func FinishPatternCompletionRound(){
        gameStage = 0
        gameBoardUserAnswers.append(currentGameBoard)
        timeUpdate.invalidate()
        CalculateScore()
        rounds[userLevel].remove(at: randomIndex)
        startRounds[userLevel].remove(at: randomIndex)
        UpdateUserLevel()
    }
    
    ///Updates userLevel based on performance in last 3 patterns completed
    private func UpdateUserLevel(){
        if(levelUpIfTwo == 2 && userLevel < 3){
            userLevel += 1
            levelUpIfTwo = 0
        }
        else if(levelDownIfTwo == 2 && userLevel > 0){
            userLevel -= 1
            levelDownIfTwo = 0
        }
    }
    
    //Calculates score depending on time and correctness
    private func CalculateScore(){
        let total = rounds[userLevel][randomIndex].count
        var count = 0;
        for i in 0...total-1{
            if(currentGameBoard.board[rounds[userLevel][randomIndex][i].x][rounds[userLevel][randomIndex][i].y] == "red"){
                count += 1
            }
        }
        percentageCompleted = (Double(count)/Double(total-startRounds[userLevel][randomIndex].count))
        if(percentageCompleted >= 0.75){
            levelUpIfTwo += 1
            levelDownIfTwo = 0
        }
        else{
            levelDownIfTwo += 1
            levelUpIfTwo = 0
        }
        
        let temp = 5*((percentageCompleted - (0.005*timer)))
        score[currentRound] = Int((round(pow(2.718,temp)) / 10) * multiplier)
    }
    
    //Increments timer if not paused
    @objc func UpdateTimer(){
        if(paused == false){
            timer = timer + 1
        }
    }
    
    
    
    //PatternSeparation variables and arrays
    var all = [0, 1, 2, 3, 4, 10, 11, 12, 13, 20, 21, 22, 30, 31, 32, 33, 40, 41, 42, 43, 50, 51, 52, 53, 60, 70, 80]
    
    var new = [0, 1, 2, 3, 4, 10, 11, 12, 13, 20, 21, 22, 30, 31, 32, 33, 40, 41, 42, 43, 50, 51, 52, 53, 60, 70, 80]
    var old = [Int]()
    var similar = [Int]()
    var userAnswers = [Int]()
    var correctAnswer = [Int]()
    var questions = [Int]()
    var image: Int!
    var imgString: String!
    var correct = 0
    var pSRound = 1
    var pSScore = 0
    
    //Randomly selects image to display
    func InitializePatternSeparation(){
        PC = false
        let rand = Int(arc4random()%27)
        image = all[rand]
    }
    
    //similar = 1 ... new = 2 ... old = 3
    //Checks whether user got the correct answer
    //Calculates which images belong to which Old, Similar or New
    func FinishPatternSeparation(answer: Int){
        pSRound+=1
        userAnswers.append(answer)
        var correctAn = 0
        
        if(similar.first(where: {$0 == image}) != nil){
            correctAn = 1
        }
        else if(new.first(where: {$0 == image} ) != nil){
            correctAn = 2
        }
        else if(old.first(where: {$0 == image}) != nil){
            correctAn = 3
        }
        
        correctAnswer.append(correctAn)
        
        if(answer == correctAn){
            correct+=1
        }
        
        var inx = new.index(where: {$0 == image})
        
        if(inx != nil){
            new.remove(at: inx!)
            old.append(image)
        }
        
        inx = similar.index(where: {$0 == image})
        if(inx != nil){
            similar.remove(at: inx!)
            old.append(image)
        }
        
        questions.append(image)
        
        if(image<10){
            var img = new.first(where: {$0<10})
            while(img != nil){
                let index = new.index(of: img!)
                new.remove(at: index!)
                similar.append(img!)
                img = new.first(where: {$0<10})
            }
        }
        else if(image>=10 && image<20){
            var img = new.first(where: {$0>=10 && $0<20})
            while(img != nil){
                let index = new.index(of: img!)
                new.remove(at: index!)
                similar.append(img!)
                img = new.first(where: {$0>=10 && $0<20})
            }
        }
        else if(image>=20 && image<30){
            var img = new.first(where: {$0>=20 && $0<30})
            while(img != nil){
                let index = new.index(of: img!)
                new.remove(at: index!)
                similar.append(img!)
                img = new.first(where: {$0>=20 && $0<30})
            }
        }
        else if(image>=30 && image<40){
            var img = new.first(where: {$0>=30 && $0<40})
            while(img != nil){
                let index = new.index(of: img!)
                new.remove(at: index!)
                similar.append(img!)
                img = new.first(where: {$0>=30 && $0<40})
            }
        }
        else if(image>=40 && image<50){
            var img = new.first(where: {$0>=40 && $0<50})
            while(img != nil){
                let index = new.index(of: img!)
                new.remove(at: index!)
                similar.append(img!)
                img = new.first(where: {$0>=40 && $0<50})
            }
        }
        else if(image>=50 && image<60){
            var img = new.first(where: {$0>=50 && $0<60})
            while(img != nil){
                let index = new.index(of: img!)
                new.remove(at: index!)
                similar.append(img!)
                img = new.first(where: {$0>=50 && $0<60})
            }
        }
    }
    
    //Calculates score for pattern Separation
    func CalculateScorePS(){
        pSScore = correct*10
        
        // writes username to core data
        let userNamePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(self.appUser)"
        let userNameUrl: URL = URL(fileURLWithPath: userNamePath)
        let userName = try? String(contentsOf: userNameUrl, encoding: .utf8)
        var dbPSScore: Int = 0
        
        // query firebase for specific data
        let db = Firestore.firestore()
        db.collection("appUser").whereField("userName", isEqualTo: userName!).getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    dbPSScore = document.get("bestScorePS") as! Int
                    
                }
            }
            print ("PS")
            print(dbPSScore)
            print (self.pSScore)
            if (self.pSScore > dbPSScore) {
                db.collection("appUser").document(userName!).updateData(["bestScorePS" : self.pSScore])
            }
        }
        
    }
    
    
    
}
