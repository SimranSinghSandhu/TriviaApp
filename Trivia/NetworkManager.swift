//
//  NetworkManager.swift
//  Trivia
//
//  Created by Simran Singh Sandhu on 04/09/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchQuestions(completion: @escaping(Result<[Question], Error>) ->()) {
        
        guard let path = Bundle.main.path(forResource: "QuestionBank", ofType: "json") else {return}
        
        let url = URL(fileURLWithPath: path)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let questionBank = try JSONDecoder().decode([Question].self, from: data)
                completion(.success(questionBank))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
