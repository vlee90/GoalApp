//
//  Goal.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class Goal {
    var goal: String?
    var objectiveArray: [Objective]?
    var dueDate: NSDate?
    
    init(goal: String, objectives: [Objective], date: NSDate) {
        self.goal = goal
        self.objectiveArray = objectives
        self.dueDate = date
    }
}