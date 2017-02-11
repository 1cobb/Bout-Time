//
//  ViewController.swift
//  Bout Time
//
//  Created by James Cobb on 1/26/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import UIKit
import GameKit
import Foundation

class GameViewController: UIViewController {
    
    var roundsDisplayed = 0
    var correctRounds = 0
    var indexOfSelectedRound: Int = 0
    var alreadyDisplayedRounds: [Int] = []
    var roundsAsked = 0
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var topQuestion: UIView!
    @IBOutlet weak var upperMiddleQuestion: UIView!
    @IBOutlet weak var lowerMiddleQuestion: UIView!
    @IBOutlet weak var bottomQuestion: UIView!
    
    @IBOutlet weak var topQuestionLabel: UILabel!
    @IBOutlet weak var upperMiddleQuestionLabel: UILabel!
    @IBOutlet weak var lowerMiddleQuestionLabel: UILabel!
    @IBOutlet weak var bottomQuestionLabel: UILabel!
    
    @IBOutlet weak var topQuestionYear: UILabel!
    @IBOutlet weak var upperMiddleYear: UILabel!
    @IBOutlet weak var lowerMiddleYear: UILabel!
    @IBOutlet weak var bottomQuestionYear: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var topDownButton: UIButton!
    @IBOutlet weak var upperMiddleUpButton: UIButton!
    @IBOutlet weak var upperMiddleDownButton: UIButton!
    @IBOutlet weak var lowerMiddleUpButton: UIButton!
    @IBOutlet weak var lowerMiddleDownButton: UIButton!
    @IBOutlet weak var bottomUpButton: UIButton!
    
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var shakeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayRound()
        runTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRound() {
        indexOfSelectedRound = GKRandomSource.sharedRandom().nextInt(upperBound: eventsForRounds.count)
        
        while alreadyDisplayedRounds.contains(indexOfSelectedRound) {
            indexOfSelectedRound = GKRandomSource.sharedRandom().nextInt(upperBound: eventsForRounds.count)
        }
        alreadyDisplayedRounds.append(indexOfSelectedRound)
        let selectedRound = eventsForRounds[indexOfSelectedRound]
        
        topQuestionLabel.text = selectedRound.event4.0
        topQuestionYear.text = String(selectedRound.event4.1)
        
        upperMiddleQuestionLabel.text = selectedRound.event3.0
        upperMiddleYear.text = String(selectedRound.event3.1)
        
        lowerMiddleQuestionLabel.text = selectedRound.event2.0
        lowerMiddleYear.text = String(selectedRound.event2.1)
        
        bottomQuestionLabel.text = selectedRound.event1.0
        bottomQuestionYear.text = String(selectedRound.event1.1)
        
        roundsDisplayed += 1
        nextRoundButton.isHidden = true
        timerLabel.text = "GO!"
        
    }
    
    func gradeRound() {
        if (topQuestionYear.text?.hashValue)! < (upperMiddleYear.text?.hash)! && (lowerMiddleYear.text?.hash)! < (bottomQuestionYear.text?.hash)! {
            correctRounds += 1
            shakeLabel.isHidden = true
            nextRoundButton.isHidden = false
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: UIControlState.normal)
            print("In Order")
        } else {
            shakeLabel.isHidden = true
            nextRoundButton.isHidden = false
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: UIControlState.normal)
            print("Not in order")
        }
    }
    
    func gameOver() {
        if roundsDisplayed == 6 {
            roundsDisplayed = 0
            
            //Segue
            let MainStory: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameOverVC = MainStory.instantiateViewController(withIdentifier: "gameOverViewController") as! GameOverViewController
            gameOverVC.finalCorrectRounds = correctRounds
            self.performSegue(withIdentifier: "gameOverSegue", sender: self)
        } else {
            return
        }
    }
    
    // Timer
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1 // This will decrement(count down) the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
        if seconds == 0 {
            stopTimer()
            gradeRound()
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    // Shake Detected
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            stopTimer()
            gradeRound()
        } else {
            return
        }
    }
    
    // Swapping Events
    @IBAction func topDownButtonPressed() {
        swap(&topQuestionLabel.text!, &upperMiddleQuestionLabel.text!)
        swap(&topQuestionYear.text!, &upperMiddleYear.text!)
    }
    
    @IBAction func upperMiddleUpButtonPressed() {
        swap(&upperMiddleQuestionLabel.text!, &topQuestionLabel.text!)
        swap(&upperMiddleYear.text!, &topQuestionYear.text!)
    }
    
    @IBAction func upperMiddleDownButtonPressed() {
        swap(&upperMiddleQuestionLabel.text!, &lowerMiddleQuestionLabel.text!)
        swap(&upperMiddleYear.text!, &lowerMiddleYear.text!)
    }
    
    @IBAction func lowerMiddleUpButtonPressed() {
        swap(&lowerMiddleQuestionLabel.text!, &upperMiddleQuestionLabel.text!)
        swap(&lowerMiddleYear.text!, &upperMiddleYear.text!)
    }
    
    @IBAction func lowerMiddleDownButtonPressed() {
        swap(&lowerMiddleQuestionLabel.text!, &bottomQuestionLabel.text!)
        swap(&lowerMiddleYear.text!, &bottomQuestionYear.text!)
    }
    
    @IBAction func bottomUpButtonPressed() {
        swap(&bottomQuestionLabel.text!, &lowerMiddleQuestionLabel.text!)
        swap(&bottomQuestionYear.text!, &lowerMiddleYear.text!)
    }
    
    @IBAction func nextRoundButtonPressed(_ sender: Any) {
        gameOver()
        shakeLabel.isHidden = false
        timerLabel.text = "GO!"
        seconds = 60
        displayRound()
        updateTimer()
        runTimer()
    }

}


