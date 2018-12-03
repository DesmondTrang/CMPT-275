//
//  GameViewController.swift
//  MEAP - Game
//
//  Created by Angus Chen on 10/25/18.
//  Copyright © 2018 Angus Chen. All rights reserved.
//
//  Programmers: Angus Chen
//  UI Created By: Desmond Trang
//  Team: CMPT 275 Team 7 - MEAP
//  Changes: -File Created - 10/25/18
//           -File Completed - 11/2/18
//           -Fixed Bug - 11/4/18
//  Known Bugs: NONE!
//
// db.collection("users").document("frank").updateData([
// "age": 13,
// "favorites.color": "Red"
// ])


import UIKit
import AVFoundation
import Firebase
import FirebaseStorage
import Charts

//Controls the main menu story board
class GameViewController: UIViewController {
    
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var startingLabel: UIImageView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tutorialView: UIView!
    @IBOutlet weak var gameScoreChart: LineChartView!
    @IBOutlet weak var gamePlayChart: LineChartView!
    @IBOutlet weak var averagePC: UILabel!
    @IBOutlet weak var bestPC: UILabel!
    @IBOutlet weak var averagePS: UILabel!
    @IBOutlet weak var bestPS: UILabel!
    @IBOutlet weak var averageGamePlay: UILabel!
    @IBOutlet weak var bestGamePlay: UILabel!
    var countDownTimer:Timer! //Timer used to count down
    var player: AVQueuePlayer!
    var screenSize = UIScreen.main.bounds.size
    var playerLooper: AVPlayerLooper!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var graphView: String = "Daily" // shows daily view by default
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var dailyBtn: UIButton!
    @IBOutlet weak var monthGSAxis: UIImageView!
    @IBOutlet weak var monthGPAxis: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //plays and loops "Tutorial.mp4"
    private func PlayVideo(){
        
        screenSize = UIScreen.main.bounds.size
        //Plays "Tutorial.mp4"
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: "tutorial", ofType: ".mp4")!))
        
        player = AVQueuePlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "tutorial", ofType: ".mp4")!))
        
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        
        playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = CGRect(x: ((screenSize.width/4)-120) , y: ((screenSize.height/4)+120), width: 800, height: 500)
        self.view.layer.addSublayer(playerLayer)
        
        player.play()
        
    }

    //IOS Function to rotate screen
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
    
    //Brings up Tutorial from menu
    @IBAction func MenuTutorial(_ sender: Any) {
        tutorialView.isHidden = false
        PlayVideo()
    }
    
    //Brings up tutorial from main screen
    @IBAction func Tutorial(_ sender: Any) {
        if(countDownTimer != nil){
            countDownTimer.invalidate()
        }
        number.text = "3"
        number.isHidden = true
        startingLabel.isHidden = true
        startButton.isHidden = false
        tutorialView.isHidden = false
        PlayVideo()
    }
    
    //Exits Tutorial
    @IBAction func ExitTutorial(_ sender: Any) {
        tutorialView.isHidden = true
        playerLayer.removeFromSuperlayer()
        player.replaceCurrentItem(with: nil)
    }
    
    //Unhides Menu View
    @IBAction func Menu(_ sender: Any) {
        if(countDownTimer != nil){
            countDownTimer.invalidate()
        }
        number.text = "3";
        number.isHidden = true
        startButton.isHidden = false
        menuView.isHidden = false
        startingLabel.isHidden = true
    }
 
    //Hides Menu
    @IBAction func Return(_ sender: Any) {
        menuView.isHidden = true
    }
    
    //Shows History view
    @IBAction func History(_ sender: Any) {
        historyView.isHidden = false
        
        // default "Daily" view
        graphView = "Daily"
        monthGSAxis.isHidden = true
        monthGPAxis.isHidden = true
        dailyBtn.isUserInteractionEnabled = false
        monthlyBtn.isUserInteractionEnabled = true
        UpdateGameScoreGraph(graphView: graphView)
        UpdateGamePlayGraph(graphView: graphView)
    }
    
    //Shows Monthly Graph
    @IBAction func MonthlyBtn(_ sender: Any) {
        graphView = "Monthly"
        monthGSAxis.isHidden = false
        monthGPAxis.isHidden = false
        dailyBtn.isUserInteractionEnabled = true
        monthlyBtn.isUserInteractionEnabled = false
        UpdateGameScoreGraph(graphView: graphView)
        UpdateGamePlayGraph(graphView: graphView)
    }
    
    //Shows Daily Graph
    @IBAction func DailyBtn(_ sender: Any) {
        graphView = "Daily"
        monthGPAxis.isHidden = true
        monthGSAxis.isHidden = true
        dailyBtn.isUserInteractionEnabled = false
        monthlyBtn.isUserInteractionEnabled = true
        UpdateGameScoreGraph(graphView: graphView)
        UpdateGamePlayGraph(graphView: graphView)
    }
    
    //Formats and Outputs Pattern Completion and Pattern Separation Graphs
    func UpdateGameScoreGraph(graphView: String) {
        
        var patternCompletionY = [Int]()
        var patternSeparationY = [Int]()
        var patternCompletionEntry = [ChartDataEntry]()
        var patternSeparationEntry = [ChartDataEntry]()
        
        if (graphView == "Daily") {
            let gameScoreX: [Int] = [3, 5, 10, 11, 15, 21, 27, 30]
            
            for i in 0..<8 {
                patternCompletionY.append(Int(arc4random_uniform(30) + 70))
                let value = ChartDataEntry(x: Double(gameScoreX[i]), y: Double(patternCompletionY[i]))
                patternCompletionEntry.append(value)
            }
            
            for i in 0..<8 {
                patternSeparationY.append(Int(arc4random_uniform(30) + 50))
                let value = ChartDataEntry(x: Double(gameScoreX[i]), y: Double(patternSeparationY[i]))
                patternSeparationEntry.append(value)
            }
        }
            
        else if (graphView == "Monthly") {
            let gameScoreX: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
            
            for i in 0..<12 {
                patternCompletionY.append(Int(arc4random_uniform(30) + 70))
                let value = ChartDataEntry(x: Double(gameScoreX[i]), y: Double(patternCompletionY[i]))
                patternCompletionEntry.append(value)
            }
            
            for i in 0..<12 {
                patternSeparationY.append(Int(arc4random_uniform(30) + 50))
                let value = ChartDataEntry(x: Double(gameScoreX[i]), y: Double(patternSeparationY[i]))
                patternSeparationEntry.append(value)
            }

            
        }
        
        //pattern completion data
        let patternCompletion = LineChartDataSet(values: patternCompletionEntry, label: "")
        
        patternCompletion.colors = [NSUIColor.red]
        patternCompletion.setCircleColors(NSUIColor.red)
        patternCompletion.circleHoleColor = UIColor.red
        patternCompletion.circleHoleRadius = 4.0
        patternCompletion.circleRadius = 4.0
        patternCompletion.drawValuesEnabled = false
        
        let patternSeparation = LineChartDataSet(values: patternSeparationEntry, label: "")
        
        patternSeparation.colors = [NSUIColor.green]
        patternSeparation.setCircleColors(NSUIColor.green)
        patternSeparation.circleHoleColor = UIColor.green
        patternSeparation.circleHoleRadius = 2.0
        patternSeparation.circleRadius = 2.0
        patternSeparation.drawValuesEnabled = false
        
        let xAxis = gameScoreChart.xAxis
        xAxis.labelFont = NSUIFont.systemFont(ofSize: CGFloat(15.0))
        xAxis.labelTextColor = NSUIColor.init(named: "SecondaryColor")!
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        if (graphView == "Daily") {
            xAxis.axisMaximum = 31
            xAxis.drawLabelsEnabled = true
        }
        else if (graphView == "Monthly") {
            xAxis.axisMaximum = 11
            xAxis.drawLabelsEnabled = false
        }
        
        let yAxis = gameScoreChart.leftAxis
        yAxis.labelFont = NSUIFont.systemFont(ofSize: CGFloat(15.0))
        yAxis.labelTextColor = NSUIColor.init(named: "SecondaryColor")!
        yAxis.axisMinimum = 0.0
        yAxis.axisMaximum = 100.0
        
        gameScoreChart.legend.enabled = false
        gameScoreChart.rightAxis.enabled = false
        
        var sets = [LineChartDataSet]()
        sets.append(patternSeparation)
        sets.append(patternCompletion)
        
        let data = LineChartData(dataSets: sets)
        
        gameScoreChart.data = data
        gameScoreChart.chartDescription?.enabled = false
        gameScoreChart.borderColor = NSUIColor.blue
        
        let avgPC: Int = GetAverage(dataArray: patternCompletionY)
        averagePC.text = "Average: \(avgPC)"
        let bstPC: Int = GetBest(dataArray: patternCompletionY)
        bestPC.text = "Best: \(bstPC)"
        
        let avgPS: Int = GetAverage(dataArray: patternSeparationY)
        averagePS.text = "Average: \(avgPS)"
        let bstPS: Int = GetBest(dataArray: patternSeparationY)
        bestPS.text = "Best: \(bstPS)"
        
    }
    
    //Formats and Outputs GamePlay Graph
    func UpdateGamePlayGraph(graphView: String) {
        
        var gameplayY = [Int]()
        var lineChartEntry = [ChartDataEntry]()
        
        if (graphView == "Daily") {
        
            let gameplayX: [Int] = [3, 5, 10, 11, 15, 21, 27, 30]
            
            for i in 0..<8 {
                gameplayY.append(Int(arc4random_uniform(10)))
                let value = ChartDataEntry(x: Double(gameplayX[i]), y: Double(gameplayY[i]))
                lineChartEntry.append(value)
            }
        }
        
        else if (graphView == "Monthly") {
            
            let gameplayX: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
            
            for i in 0..<12 {
                gameplayY.append(Int(arc4random_uniform(10)))
                let value = ChartDataEntry(x: Double(gameplayX[i]), y: Double(gameplayY[i]))
                lineChartEntry.append(value)
            }
        }
        
        
        let gamePlay = LineChartDataSet(values: lineChartEntry, label: "Game Plays")
        
        gamePlay.colors = [NSUIColor.orange]
        gamePlay.setCircleColors(NSUIColor.orange)
        gamePlay.circleHoleColor = UIColor.orange
        gamePlay.circleRadius = 4.0
        gamePlay.circleHoleRadius = 4.0
        gamePlay.label = ""
        gamePlay.drawValuesEnabled = false
        
       
        let xAxis = gamePlayChart.xAxis
        xAxis.labelFont = NSUIFont.systemFont(ofSize: CGFloat(15.0))
        xAxis.labelTextColor = NSUIColor.init(named: "SecondaryColor")!
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0
        if (graphView == "Daily") {
            xAxis.drawLabelsEnabled = true
            xAxis.axisMaximum = 31
        }
        else if (graphView == "Monthly") {
            xAxis.axisMaximum = 11
            xAxis.drawLabelsEnabled = false
        }
        
        let yAxis = gamePlayChart.leftAxis
        yAxis.labelFont = NSUIFont.systemFont(ofSize: CGFloat(15.0))
        yAxis.labelTextColor = NSUIColor.init(named: "SecondaryColor")!
        yAxis.axisMinimum = 0.0
        yAxis.axisMaximum = 10.0
        
        gamePlayChart.legend.enabled = false
        gamePlayChart.rightAxis.enabled = false
        
        let data = LineChartData()
        data.addDataSet(gamePlay)
        gamePlayChart.data = data
        gamePlayChart.chartDescription?.enabled = false
        gamePlayChart.borderColor = NSUIColor.blue
        
        let average: Int = GetAverage(dataArray: gameplayY)
        averageGamePlay.text = "Average: \(average)"
        
        let best: Int = GetBest(dataArray: gameplayY)
        bestGamePlay.text = "Best: \(best)"
        
    }
    
    func GetAverage(dataArray: Array<Int>) -> Int {
        var sum = 0
        var size = 0
        for number in dataArray {
            sum += number
            size += 1
        }
        return sum/size
    }
    
    func GetBest(dataArray: Array<Int>) -> Int {
        var highest = 0;
        for number in dataArray {
            if (number > highest) {
                highest = number
            }
        }
        return highest
    }
    
    //Hides History view
    @IBAction func ReturnToMenu(_ sender: Any) {
        historyView.isHidden = true
    }
    
    //Starts game countdown
    @IBAction func startButton(_ sender: Any) {
        startButton.isHidden = true
        startingLabel.isHidden = false
        number.isHidden = false
        number.text = "3"
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    
    }
    
    //Countes down to 1 and segue to game view
    @objc func countDown(){
        if(number.text == "3"){
            number.text = "2"
        }
        else if(number.text == "2"){
            number.text = "1"
        }
        else{
            countDownTimer.invalidate()
            performSegue(withIdentifier: "StartPC", sender: self)
            //segue to game screen
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


