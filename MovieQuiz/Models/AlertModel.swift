//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Ruslan Pavlov on 7.10.2022.
//

import Foundation

struct AlertModel{
    let title: String
    let message: String
    let buttonText: String
    let completion: ()->()
}
