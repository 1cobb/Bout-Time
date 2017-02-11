//
//  GameOverViewController.swift
//  Bout Time
//
//  Created by James Cobb on 2/7/17.
//  Copyright © 2017 James Cobb. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var correctRoundsLabel: UILabel!
    var finalCorrectRounds = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        correctRoundsLabel.text = String(finalCorrectRounds)
        

        // Do any additional setup after loading the view.
    }

    @IBAction func playAgainButton(_ sender: Any) {
        self.performSegue(withIdentifier: "newGameSegue", sender: self)
        finalCorrectRounds = 0

       
    }
    
}
