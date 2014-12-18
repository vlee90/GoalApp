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
    
    
    var goalCellSelected = false
    var objectiveCellSelected = false
    
    let storageController = StorageController.sharedInstance
    var user = User()
    var goalArray = [Goal]()
    var objectiveArray = [Objective]()
    var stepArray = [Step]()
    var selectedGoalIndexPath: NSIndexPath?
    var selectedObjectiveIndexPath: NSIndexPath?
    var selectedStepIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setupValues()
        tableView.allowsMultipleSelection = true

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupValues()
        let range: NSRange = NSMakeRange(0, 3)
        tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            println("IndexPath \(indexPath.row)")
            selectedGoalIndexPath = indexPath
            storageController.selectedGoalIndexPath = selectedGoalIndexPath
            let selectedGoal = goalArray[selectedGoalIndexPath!.row]
            objectiveArray = selectedGoal.objectiveArray
            goalCellSelected = true
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
        case 1:
            println("IndexPath \(indexPath.row)")
            selectedObjectiveIndexPath = indexPath
            storageController.selectedObjectiveIndexPath = selectedObjectiveIndexPath
            let selectedObjective = objectiveArray[selectedObjectiveIndexPath!.row]
            stepArray = selectedObjective.stepArray
            objectiveCellSelected = true
            tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            println("step")
        }
    }
    
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
                    tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
                }
            }
        }
        return indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GOAL_CELL", forIndexPath: indexPath) as GoalTableViewCell
            cell.goalLabel.text = goalArray[indexPath.row].goal
            cell.dateLabel.text = goalArray[indexPath.row].dueDate
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OBJECTIVE_CELL", forIndexPath: indexPath) as ObjectiveTableViewCell
            cell.objectiveLabel.text = objectiveArray[indexPath.row].objective
            cell.dateLabel.text = objectiveArray[indexPath.row].dueDate
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("STEP_CELL", forIndexPath: indexPath) as StepTableViewCell
            cell.stepLabel.text = stepArray[indexPath.row].step
            cell.dateLabel.text = stepArray[indexPath.row].dueDate
            return cell
        }
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
        let createButton = UIButton(frame: CGRectMake(sectionButton.frame.width * 0.9, sectionButton.frame.height * 0.25, sectionButton.frame.height * 0.5, sectionButton.frame.height * 0.5))
        createButton.backgroundColor = UIColor.greenColor()
        createButton.addTarget(self, action: "createButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        createButton.setTitle("+", forState: UIControlState.Normal)
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
    
    func sectionButtonPressed(sender: UIButton) {
        if sender.titleLabel!.text! == kCreationType.Goal.rawValue {
            if goalTableOpen == true && goalArray.count != 0 && tableView.indexPathsForSelectedRows() != nil {
                    for selectedIndexPath in tableView.indexPathsForSelectedRows() as [NSIndexPath] {
                        if selectedIndexPath.section == 0 {
                            selectedGoalIndexPath = selectedIndexPath
                            goalArray = [goalArray[selectedIndexPath.row]]
                        }
                    }
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
                goalTableOpen = false
            }
            else if goalTableOpen == false {
                goalArray = user.goalArray
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.selectRowAtIndexPath(selectedGoalIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
                goalTableOpen = true
            }
            else {
                println("ERROR: goalTableOpen == nil")
            }
            println("goalTableOpen == \(goalTableOpen)")
        }
        else if sender.titleLabel!.text! == kCreationType.Objective.rawValue {
            if objectiveTableOpen == true && objectiveArray.count != 0 {
                if let indexPaths = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
                    for selectedIndexPath in indexPaths {
                        if selectedIndexPath.section == 1 {
                            objectiveArray = [objectiveArray[selectedIndexPath.row]]
                        }
                    }
                }
                else {
                    objectiveArray = []
                }
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
                objectiveTableOpen = false
            }
            else if objectiveTableOpen == false {
                objectiveArray = user.goalArray[selectedGoalIndexPath!.row].objectiveArray
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Automatic)
                objectiveTableOpen = true
            }
        }
        else {
            //add
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
            if goalCellSelected == true {
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
            if goalCellSelected == true && objectiveCellSelected == true {
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
        let goalNib = UINib(nibName: "GoalTableViewCell", bundle: NSBundle.mainBundle())
        let objectiveNib = UINib(nibName: "ObjectiveTableViewCell", bundle: NSBundle.mainBundle())
        let stepNib = UINib(nibName: "StepTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(goalNib, forCellReuseIdentifier: "GOAL_CELL")
        tableView.registerNib(objectiveNib, forCellReuseIdentifier: "OBJECTIVE_CELL")
        tableView.registerNib(stepNib, forCellReuseIdentifier: "STEP_CELL")
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
        if selectedObjectiveIndexPath != nil {
            stepArray = objectiveArray[selectedObjectiveIndexPath!.row].stepArray
        }
    }
}
