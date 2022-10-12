//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 7.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    
    // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
