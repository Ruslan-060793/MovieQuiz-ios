//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 11.10.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {case correct, total, bestGame, gamesCount}
    
    
    func store(correct count: Int, total amount: Int) {
        if userDefaults.integer(forKey: Keys.correct.rawValue) != nil, userDefaults.integer(forKey: Keys.total.rawValue) != nil{
            
            let correct = userDefaults.integer(forKey: Keys.correct.rawValue) + count
            userDefaults.set(correct, forKey: Keys.correct.rawValue)
            
            let total = userDefaults.integer(forKey: Keys.total.rawValue) + amount
            userDefaults.set(total, forKey: Keys.total.rawValue)
            
        }else{
            userDefaults.set(count, forKey: Keys.correct.rawValue)
            userDefaults.set(amount,forKey: Keys.total.rawValue)
        }
            
    }
    
    var totalAccuracy: Double{
        get{
            if userDefaults.integer(forKey: Keys.correct.rawValue) == nil, userDefaults.integer(forKey: Keys.total.rawValue) == nil{
                return 0.0
            }
            
            return Double(userDefaults.integer(forKey: Keys.correct.rawValue))/Double( userDefaults.integer(forKey: Keys.total.rawValue))
        }
    }
    
    var gamesCount: Int{
        get{
            if userDefaults.integer(forKey: Keys.gamesCount.rawValue) != nil{
                let value = userDefaults.integer(forKey: Keys.gamesCount.rawValue) + 1
                userDefaults.set(value, forKey: Keys.gamesCount.rawValue)
            }else{
                userDefaults.set(0, forKey: Keys.gamesCount.rawValue)
            }
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            //GameRecord - текущая сессия игры
            let record = try? JSONDecoder().decode(GameRecord.self, from: data)
            
            if userDefaults.data(forKey: Keys.bestGame.rawValue) == nil{
                userDefaults.set(data, forKey: Keys.bestGame.rawValue)
            }else{
                //получаем данные лучшей игры
                guard let oldData = userDefaults.data(forKey: Keys.bestGame.rawValue) else {return}
                let oldRecord = try? JSONDecoder().decode(GameRecord.self, from: oldData)
                
                //сравниваем текущую игру с последней лучшей игры
                guard let record = record, let oldRecord = oldRecord else {return}
                let value = bestGame.compare(left: record, right: oldRecord)
                let dataValue = try? JSONEncoder().encode(value)
                
                //сохраняем лучшую игру
                userDefaults.set(dataValue, forKey: Keys.bestGame.rawValue)
            }
        }
    }
}
