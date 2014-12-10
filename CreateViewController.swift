//
//  CreateViewController.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/8/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var type = kCreationType.Goal.rawValue
    

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.dataSource = self
        pickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(row) {
        case 0:
            type = kCreationType.Goal.rawValue
        case 1:
            type = kCreationType.Objective.rawValue
        default:
            type = kCreationType.Step.rawValue
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch(row) {
        case 0:
            return "Goal"
        case 1:
            return "Objective"
        default:
            return "Step"
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}
