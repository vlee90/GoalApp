//
//  MainViewController.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/5/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var goalTableOpen = true
    var objectiveTableOpen = true
    var stepTableOpen = true
    
    
    let storageController = StorageController.sharedInstance
    var user = User()
    var goalArray = [Goal]()
    var objectiveArray = [Objective]()
    var stepArray = [Step]()
    var selectedGoalIndexPath: NSIndexPath?
    var selectedObjectiveIndexPath: NSIndexPath?
    var selectedStepIndexPath: NSIndexPath?
    
//  MARK: - Start Up
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setupValues()
        tableView.allowsMultipleSelection = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "enterEditMode")

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupValues()
        let range: NSRange = NSMakeRange(0, 3)
        let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath]
        tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Fade)
        if selectedRows != nil {
            for index in selectedRows! {
                tableView.selectRowAtIndexPath(index, animated: false, scrollPosition: UITableViewScrollPosition.None)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func enterEditMode() {
//        tableView.setEditing(true, animated: true)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitEditMode")
//    }
//    
//    func exitEditMode() {
//        tableView.setEditing(false, animated: true)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Bordered, target: self, action: "enterEditMode")
//    }
    
//  MARK: - TableView
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            //  Save the selected goal's indexPath
            selectedGoalIndexPath = indexPath
            storageController.selectedGoalIndexPath = selectedGoalIndexPath
            //  Loads objectives from the selected goal.
            let selectedGoal = goalArray[selectedGoalIndexPath!.row]
            objectiveArray = selectedGoal.objectiveArray
            //  Loads steps from first objective
            if objectiveArray.isEmpty == true {
                stepArray = []
                let range = NSMakeRange(1, 2)
                tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            else if objectiveArray.isEmpty == false {
                selectedObjectiveIndexPath = NSIndexPath(forRow: 0, inSection: 1)
                stepArray = objectiveArray[selectedObjectiveIndexPath!.row].stepArray
                let range = NSMakeRange(1, 2)
                tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
            else {
                println("objectiveArray is nil when goal is selected.")
            }
        case 1:
            //  Save the selected objective's indexPath
            selectedObjectiveIndexPath = indexPath
            storageController.selectedObjectiveIndexPath = selectedObjectiveIndexPath
            //  Loads steps from the selected objective
            let selectedObjective = objectiveArray[selectedObjectiveIndexPath!.row]
            stepArray = selectedObjective.stepArray
            selectedObjectiveIndexPath = indexPath
            tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            // Save the selected step's indexPath
            selectedStepIndexPath = indexPath
            storageController.selectedStepIndexPath = selectedStepIndexPath
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            selectedGoalIndexPath = nil
            objectiveArray = []
            stepArray = []
            let range = NSMakeRange(1, 2)
            tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            println("Goal was deselected")
        case 1:
            selectedObjectiveIndexPath = nil
            stepArray = []
            tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
            println("Objective was deselected")
        default:
            println("Step was deselected")
        }
    }
    
    // Used to deselect cell when new cell is selected in the same section.
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // Grabs an array of all indexPaths for all selected Rows in the tableview.
        if let indexPaths = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
            // Create a dummy array to fill and swap in for selectedRows later
            var newIndexPathArray = [NSIndexPath]()
            // Search through array of all indexPaths for each selected row in the tableView.
            for selectedIndexPath in indexPaths {
                // Will only look at selected indexes within the section in question.
                if selectedIndexPath.section == indexPath.section {
                    // deselects row that was selected before from the table.
                    tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
                }
            }
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TABLE_CELL", forIndexPath: indexPath) as TableCell
        if indexPath.section == 0 {
            cell.detailLabel.text = goalArray[indexPath.row].goal
            let date = goalArray[indexPath.row].dueDate
            cell.dateLabel.text = date
        }
        else if indexPath.section == 1 {
            cell.detailLabel.text = objectiveArray[indexPath.row].objective
            cell.dateLabel.text = objectiveArray[indexPath.row].dueDate
        }
        else {
            cell.detailLabel.text = stepArray[indexPath.row].step
            cell.dateLabel.text = stepArray[indexPath.row].dueDate
        }
        cell.detailLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return goalArray.count
        }
        else if section == 1 {
            return objectiveArray.count
        }
        else {
            return stepArray.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit") { (action, indexPath) -> Void in
            println("Edit Action")
        }
        editAction.backgroundColor = UIColor.greenColor()
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete") { (action, indexPath) -> Void in
            switch indexPath.section {
            case 0:
                self.goalArray.removeAtIndex(indexPath.row)
                self.objectiveArray = []
                self.stepArray = []
                self.storageController.user.goalArray = self.goalArray
                self.selectedGoalIndexPath = nil
                self.storageController.selectedGoalIndexPath = self.selectedGoalIndexPath
                let range = NSMakeRange(0, 3)
                tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            case 1:
                self.objectiveArray.removeAtIndex(indexPath.row)
                self.stepArray = []
                self.storageController.user.goalArray[self.selectedGoalIndexPath!.row].objectiveArray = self.objectiveArray
                self.selectedObjectiveIndexPath = nil
                self.storageController.selectedObjectiveIndexPath = self.selectedObjectiveIndexPath
                let range = NSMakeRange(1, 2)
                tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            default:
                self.stepArray.removeAtIndex(indexPath.row)
                self.storageController.user.goalArray[self.selectedGoalIndexPath!.row].objectiveArray[self.selectedObjectiveIndexPath!.row].stepArray = self.stepArray
                self.selectedStepIndexPath = nil
                self.storageController.selectedStepIndexPath = self.selectedStepIndexPath
                tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
            }

        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [editAction, deleteAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            switch indexPath.section {
            case 0:
                goalArray.removeAtIndex(indexPath.row)
                objectiveArray = []
                stepArray = []
                storageController.user.goalArray = goalArray
                selectedGoalIndexPath = nil
                storageController.selectedGoalIndexPath = selectedGoalIndexPath
                let range = NSMakeRange(0, 3)
                tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            case 1:
                objectiveArray.removeAtIndex(indexPath.row)
                stepArray = []
                println("Section \(indexPath.section) Row: \(indexPath.row)")
                storageController.user.goalArray[selectedGoalIndexPath!.row].objectiveArray = objectiveArray
                selectedObjectiveIndexPath = nil
                storageController.selectedObjectiveIndexPath = selectedObjectiveIndexPath
                let range = NSMakeRange(1, 2)
                tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Automatic)
            default:
                stepArray.removeAtIndex(indexPath.row)
                storageController.user.goalArray[selectedGoalIndexPath!.row].objectiveArray[selectedObjectiveIndexPath!.row].stepArray = stepArray
                selectedStepIndexPath = nil
                storageController.selectedStepIndexPath = selectedStepIndexPath
                tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
        else if editingStyle == UITableViewCellEditingStyle.Insert {
            println("SUP")
        }
        else {
            println("ERROR: commitEditingStyle editingStyle is neither Delete or Insert")
        }

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Create View
        var sectionView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, tableView.frame.height * 0.05))
        
        //Create sectionButton
        let sectionButton = UIButton(frame: sectionView.frame)
        sectionButton.backgroundColor = UIColor.yellowColor()
        sectionButton.userInteractionEnabled = true
        sectionButton.addTarget(self, action: "sectionButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        sectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        sectionButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        sectionView.addSubview(sectionButton)
        
        //Create createButton
        let createButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        createButton.frame = CGRectMake(sectionButton.frame.width * 0.9, sectionButton.frame.height * 0.25, sectionButton.frame.height * 0.5, sectionButton.frame.height * 0.5)
        createButton.addTarget(self, action: "createButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        createButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        createButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        
        //Populate Sections
        //Only can create Goal
        if section == 0 {
            sectionView.addSubview(createButton)
            createButton.tag = 0
            sectionButton.setTitle(kCreationType.Goal.rawValue, forState: UIControlState.Normal)
            return sectionView
        }
        else if section == 1 {
            sectionView.addSubview(createButton)
            createButton.tag = 1
            sectionButton.setTitle(kCreationType.Objective.rawValue, forState: UIControlState.Normal)
            return sectionView
        }
        else {
            sectionView.addSubview(createButton)
            createButton.tag = 2
            sectionButton.setTitle(kCreationType.Step.rawValue, forState: UIControlState.Normal)
            return sectionView
        }
    }
    
// MARK: - UIButton Actions
    
    func sectionButtonPressed(sender: UIButton) {
        //  Switch on button title.
        switch sender.titleLabel!.text! {
        case kCreationType.Goal.rawValue:
            //Code that collapses tableView section.
            if goalTableOpen == true && goalArray.count != 0 && tableView.indexPathsForSelectedRows() != nil {
                //  Checks all selecteds indexPaths.
                for selectedIndexPath in tableView.indexPathsForSelectedRows() as [NSIndexPath] {
                    //  Check if indexPath is in goal section.
                    if selectedIndexPath.section == 0 {
                        //  Setup goalArray to only display selected cell.
                        goalArray = [goalArray[selectedIndexPath.row]]
                    }
                }
                //  Displays only selected cell and automatically selects it.
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
                goalTableOpen = false
            }
            //  Code that expands tableView section.
            else if goalTableOpen == false {
                // Setup goalArray to display original goals.
                goalArray = user.goalArray
                //  Displays all goals.
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.selectRowAtIndexPath(selectedGoalIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
                goalTableOpen = true
            }
            else {
                println("ERROR: Goal Section will not expand or collapse")
            }
        case kCreationType.Objective.rawValue:
            if objectiveTableOpen == true && objectiveArray.count != 0 && tableView.indexPathsForSelectedRows() != nil {
                for selectedIndexPath in tableView.indexPathsForSelectedRows() as [NSIndexPath] {
                    if selectedIndexPath.section == 1 {
                        objectiveArray = [objectiveArray[selectedIndexPath.row]]
                    }
                }
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), animated: false, scrollPosition: UITableViewScrollPosition.None)
                objectiveTableOpen = false
            }
            else if objectiveTableOpen == false {
                objectiveArray = user.goalArray[selectedGoalIndexPath!.row].objectiveArray
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.selectRowAtIndexPath(selectedObjectiveIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
                objectiveTableOpen = true
            }
            else {
                println("ERROR: Objective Section will not expand or collapse")
            }
        default:
            println("step")
        }
    }
    
    func createButtonPressed(sender: UIButton) {
        let toVC = self.storyboard?.instantiateViewControllerWithIdentifier(kStoryboardID.CreateVC.rawValue) as CreateViewController
        switch (sender.tag) {
        case 0:
//            selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath]
            toVC.type = kCreationType.Goal.rawValue
            navigationController?.pushViewController(toVC, animated: true)
        case 1:
            if selectedGoalIndexPath != nil {
//                selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath]
                toVC.type = kCreationType.Objective.rawValue
                navigationController?.pushViewController(toVC, animated: true)
            }
            else {
                let alertController = UIAlertController(title: "Attention", message: "Select a goal to add an objective to.", preferredStyle: UIAlertControllerStyle.Alert)
                let alertCancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(alertCancel)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        default:
            if selectedGoalIndexPath != nil && selectedObjectiveIndexPath != nil {
//                selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath]
                toVC.type = kCreationType.Step.rawValue
                navigationController?.pushViewController(toVC, animated: true)
            }
            else {
                let alertController = UIAlertController(title: "Attention", message: "Select an objective to add a step to.", preferredStyle: UIAlertControllerStyle.Alert)
                let alertCancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Cancel, handler: nil)
                alertController.addAction(alertCancel)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //  Sets table delegation/dataSource/Nibs
    func setUpTable() {
        tableView.dataSource = self
        tableView.delegate = self
        let tableCell = UINib(nibName: "TableCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(tableCell, forCellReuseIdentifier: "TABLE_CELL")
    }
    
    //  Pulls values from storageController
    func setupValues() {
        user = storageController.user
        goalArray = user.goalArray
        selectedGoalIndexPath = storageController.selectedGoalIndexPath
        selectedObjectiveIndexPath = storageController.selectedObjectiveIndexPath
        selectedStepIndexPath = storageController.selectedStepIndexPath
        if selectedGoalIndexPath != nil {
            objectiveArray = goalArray[selectedGoalIndexPath!.row].objectiveArray
        }
        if selectedObjectiveIndexPath != nil && objectiveArray.isEmpty == false {
            stepArray = objectiveArray[selectedObjectiveIndexPath!.row].stepArray
        }
    }
}
