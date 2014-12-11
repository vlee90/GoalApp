//
//  CreateViewController.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    var type: String!
    let dateFormatter = StorageController.sharedInstance.dateFormatter
    let storageController = StorageController.sharedInstance
    var user = User()
    var goalArray = [Goal]()
    var objectiveArray = [Objective]()
    var stepArray = [Step]()
    var selectedGoalIndex: Int?
    var selectedObjectiveIndex: Int?
    var selectedStepIndex: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupValues()
        setTextFieldText()
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createButtonPressed(sender: AnyObject) {
        let formattedDate = dateFormatter.stringFromDate(datePicker.date)
        if type == kCreationType.Goal.rawValue {
            let goal = Goal(goal: textField.text, date: formattedDate)
            goalArray.append(goal)
        }
        else if type == kCreationType.Objective.rawValue {
            let objective = Objective(objective: textField.text, date: formattedDate)
            objectiveArray.append(objective)
        }
        else {
            let step = Step(step: textField.text, date: formattedDate)
            stepArray.append(step)
        }
        saveValues()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func setTextFieldText() {
        if type == "Goal" {
            textField.placeholder = "Type Goal Here:"
        }
        else if type == "Objective" {
            textField.placeholder = "Type Objective Here:"
        }
        else {
            textField.placeholder = "Type Step Here:"
        }
    }
    
    func setupValues() {
        user = storageController.user
        goalArray = user.goalArray
        selectedGoalIndex = storageController.selectedGoalIndex
        selectedObjectiveIndex = storageController.selectedObjectiveIndex
        selectedStepIndex = storageController.selectedStepIndex
        if selectedGoalIndex != nil {
            objectiveArray = goalArray[selectedGoalIndex!].objectiveArray
        }
        if selectedObjectiveIndex != nil {
            stepArray = objectiveArray[selectedObjectiveIndex!].stepArray
        }
    }
    
    func saveValues() {
        storageController.user = user
        storageController.user.goalArray = goalArray
        storageController.selectedGoalIndex = selectedGoalIndex
        storageController.selectedObjectiveIndex = selectedObjectiveIndex
        storageController.selectedStepIndex = selectedStepIndex
        if selectedGoalIndex != nil {
            storageController.user.goalArray[selectedGoalIndex!].objectiveArray = objectiveArray
        }
        if selectedObjectiveIndex != nil && selectedGoalIndex != nil {
            storageController.user.goalArray[selectedGoalIndex!].objectiveArray[selectedObjectiveIndex!].stepArray = stepArray
        }
        
    }
}
