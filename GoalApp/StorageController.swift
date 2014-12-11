//
//  StorageController.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import Foundation

class StorageController {
    
    var user = User()
    let dateFormatter = NSDateFormatter()
    var selectedGoalIndex: Int?
    var selectedObjectiveIndex: Int?
    var selectedStepIndex: Int?
    
    class var sharedInstance : StorageController {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : StorageController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = StorageController()
        }
        return Static.instance!
    }
}