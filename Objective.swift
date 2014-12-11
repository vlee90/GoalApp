//
//  Objective.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class Objective {
    var objective: String
    var stepArray = [Step]()
    var dueDate: String
    
    init(objective: String, date: String) {
        self.objective = objective
        self.dueDate = date
    }
}