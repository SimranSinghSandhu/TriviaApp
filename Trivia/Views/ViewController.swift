//
//  ViewController.swift
//  Trivia
//
//  Created by Simran Singh Sandhu on 03/09/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class HistoryGame {
    var games: [Game]?
}

class Game {
    var title: String?
    var questions: [Question]?
}

class GameQuestion {
    var title: String?
    var type: QuestionType?
    var options: [Option]?
}

class Question: Decodable {
    var title: String?
    var type: QuestionType?
    var options: [Option]?
}

class Option: Decodable {
    var title: String?
}

enum QuestionType: String, Decodable {
    case single = "single"
    case multiple = "multiple"
}


class ViewController: UIViewController, UITextFieldDelegate {

    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Enter your name"
        textField.layer.cornerRadius = 10
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 1
        textField.layer.shadowOpacity = 0.5
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 1
        btn.layer.shadowOpacity = 0.5
        btn.backgroundColor = UIColor.systemBlue
        btn.addTarget(self, action: #selector(handleNextBtn), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        [nameTextField, nextBtn].forEach({view.addSubview($0)})
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
        
        settingConstraints()
    }
    
    private func settingConstraints() {
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nextBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        nextBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        nextBtn.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50).isActive = true
        nextBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleNextBtn() {
        print("Handle Next Button")
        if nameTextField.text!.count > 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "questionVC") as! QuestionViewController
                destinationVC.userName = nameTextField.text
            
            destinationVC.modalPresentationStyle = .fullScreen
            present(destinationVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func handleViewTap() {
        resignTextFieldResponder(textField: nameTextField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignTextFieldResponder(textField: textField)
        return true
    }
    
    private func resignTextFieldResponder(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}
