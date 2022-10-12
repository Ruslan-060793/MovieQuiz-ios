//
//  AlertPresentedDelegate.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 7.10.2022.
//

import Foundation


protocol AlertPresenterDelegate: class{
    
    func show(quiz result: QuizResultsViewModel)
}
