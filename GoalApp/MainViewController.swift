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
    
    var goalArray = [1,2,3]
    var goalTableOpen = true
    var storageController = StorageController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GOAL_CELL", forIndexPath: indexPath) as GoalTableViewCell
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("OBJECTIVE_CELL", forIndexPath: indexPath) as ObjectiveTableViewCell
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("STEP_CELL", forIndexPath: indexPath) as StepTableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return goalArray.count
        }
        else if section == 1 {
            return 1
        }
        else {
            return 2
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var returnView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, self.tableView.frame.height * 0.1))
        returnView.backgroundColor = UIColor.redColor()
        var sectionButton = UIButton(frame: returnView.frame)
        sectionButton.userInteractionEnabled = true
        sectionButton.addTarget(self, action: "sectionButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(sectionButton)
        
        if section == 0 {
            sectionButton.setTitle("Goals", forState: UIControlState.Normal)
            return returnView
        }
        else if section == 1 {
            sectionButton.setTitle("Objectives", forState: UIControlState.Normal)
            return returnView
        }
        else {
            sectionButton.setTitle("Steps", forState: UIControlState.Normal)
            return returnView
        }
    }
    
    func sectionButtonPressed(sender: UIButton) {
        if sender.titleLabel!.text! == "Goals" {
            println("1")
            switch goalTableOpen {
            case true:
                goalArray = []
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                goalTableOpen = false
                println(goalTableOpen)
            case false:
                goalArray = [1,2,3]
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
                goalTableOpen = true
                println(goalTableOpen)
            default:
                println("ERROR: goalTableOpen = nil")
            }
        }
        else if sender.titleLabel!.text! == "Objectives" {
            println("2")
        }
        else {
            println("3")
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.height * 0.1
    }

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
    
}
