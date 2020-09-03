//
//  EndGameViewController.swift
//  Trivia
//
//  Created by Simran Singh Sandhu on 03/09/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import CoreData

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var summaryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryTextView.isUserInteractionEnabled = false
        
        // Not Working
        let name = "Simran"
        
        
        // Not working
        summaryTextView.text = "Hello \(name) \n\nHere are the answers selected \n\n \n\nAnswer: \n\n..Question 2...\n\nAnswers :..Answer 2.."
    }
    @IBAction func handleRestartBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
