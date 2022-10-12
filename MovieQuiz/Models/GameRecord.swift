//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 11.10.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    
    func compare(left newGameRecord:GameRecord, right oldGameRecord:GameRecord)->GameRecord{
        
        if newGameRecord.correct > oldGameRecord.correct{
            
            return newGameRecord
        }else{
            
            return oldGameRecord
        }
        
    }
}
