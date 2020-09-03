//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Simran Singh Sandhu on 03/09/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import CoreData

class QuestionViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var userName: String?
    var selectedAnswer: [String]?
    var questionBank = [Question]()
    
    var historyArray = [NewHistoryGame]()
    var optionArray = [NewOptions]()
    
    var savedAnswers = [Int]()
    
    var currentQuestionNumber: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var optionBtns: [UIButton]!
    var btnTappedCount: [Int] = [0, 0, 0, 0]
    
    @IBOutlet weak var nextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemTeal
    
        nextBtn.isEnabled = false
        
        for btn in optionBtns {
            btn.layer.cornerRadius = 10
        }
        
//        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // Resetting Quiz Questions and Answers
        currentQuestionNumber = 0
        
        NetworkManager.shared.fetchQuestions { (result) in
            switch result {
            case .failure(let err):
                print(err)
            case .success(let questions):
                print(questions)
                self.questionBank = questions
                
                self.loadQuestionData()
            }
        }
        
    }
        
    // When nextBtn is pressed
    @IBAction func handleNextBtn(_ sender: Any) {
        
        for n in 0..<optionBtns.count {
            if optionBtns[n].backgroundColor == UIColor.green {
                selectedAnswer?.append(optionBtns[n].titleLabel!.text!)
            }
            optionBtns[n].backgroundColor = UIColor.clear
            btnTappedCount[n] = 0
        }
        
        if currentQuestionNumber < questionBank.count - 1 {
            loadQuestionData()
            currentQuestionNumber += 1
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "endGameVC") as! EndGameViewController
            destinationVC.modalPresentationStyle = .fullScreen
            present(destinationVC, animated: true, completion: nil)
        }
    }
    
    private func loadQuestionData() {
        
        DispatchQueue.main.async {
            let option = self.questionBank[self.currentQuestionNumber].options
            
            self.questionLabel.text = self.questionBank[self.currentQuestionNumber].title
            
            for n in 0..<self.optionBtns.count {
                self.optionBtns[n].setTitle(" " + (option?[n].title)!, for: .normal)
            }
        }
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func loadData() {
        let request: NSFetchRequest<NewHistoryGame> = NewHistoryGame.fetchRequest()
        
        do {
            historyArray = try context.fetch(request)
        } catch {
            print(error)
        }
    }

    @IBAction func handleOptionBtn(_ sender: AnyObject) {
        
        switch questionBank[currentQuestionNumber].type {
        
        case .single:
            for n in 0..<self.optionBtns.count {
                let btn = self.optionBtns[n]
                btn.backgroundColor = UIColor.clear
                
                if btn.tag == sender.tag {
                    btnTappedCount[n] += 1
                    if btnTappedCount[n] % 2 != 0 {
                        btn.backgroundColor = UIColor.green
                        print("selected")
                        nextBtn.isEnabled = true
                    } else {
                        print("Deselected")
                        nextBtn.isEnabled = false
                    }
                } else {
                    btnTappedCount[n] = 0
                }
            }
        case .multiple:
//            print("Multiple")
            for n in 0..<self.optionBtns.count {
                let btn = self.optionBtns[n]
                if btn.tag == sender.tag {
                    btnTappedCount[n] += 1
                    if btnTappedCount[n] % 2 == 0 {
                        btn.backgroundColor = UIColor.clear
                    } else {
                        btn.backgroundColor = UIColor.green
                    }
                }
            }
        case .none:
            print("None Selected")
        }
    }
    
    private func settingCoreData() {
        let myHistoryGame = NewHistoryGame(context: context)
        let myGame = NewGame(context: context)
        let myQuestion = NewGameQuestions(context: context)
        let myOption = NewOptions(context: context)
        
        myOption.title = "Some title."
        
        myQuestion.options = [myOption]
        
        myQuestion.title = questionBank[currentQuestionNumber].title
        
        myGame.questions = [myQuestion]
        
        myGame.title = userName
        
        myHistoryGame.games = [myGame]
        
        myGame.parentHistoryGame = myHistoryGame
        
        myHistoryGame.num += 1
        
        historyArray.append(myHistoryGame)
        saveData()
    }
}
