//
//  Step.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class Step {
    var step: String
    var dueDate: String
    
    init(step: String, date: String) {
        self.step = step
        self.dueDate = date
    }
}