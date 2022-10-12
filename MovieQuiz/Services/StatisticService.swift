//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 11.10.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    
}
