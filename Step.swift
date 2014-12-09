//
//  Step.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class Step {
    var step: String?
    var dueDate: NSDate?
    
    init(step: String, date: NSDate) {
        self.step = step
        self.dueDate = date
    }
}