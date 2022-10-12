//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 7.10.2022.
//

import Foundation

struct AlertPresenter: AlertPresenterProtocol{
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showEndGameAlert(quiz quizModel: QuizResultsViewModel) {
        
        delegate?.show(quiz: quizModel)
        
    }
    
}
