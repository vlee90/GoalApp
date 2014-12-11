//
//  Goal.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class Goal {
    var goal: String
    var objectiveArray = [Objective]()
    var dueDate: String
    
    init(goal: String, date: String) {
        self.goal = goal
        self.dueDate = date
    }
}