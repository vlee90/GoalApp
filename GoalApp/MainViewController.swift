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
            return 3
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
        var viewsInNib = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: self, options: nil)
        var returnView: HeaderView
        for view in viewsInNib {
            if let view = view as? HeaderView {
                returnView = view
                if section == 0 {
                    returnView.sectionButton.setTitle("Goals", forState: UIControlState.Normal)
                    return returnView
                }
                else if section == 1 {
                    returnView.sectionButton.setTitle("Objectives", forState: UIControlState.Normal)
                    return returnView
                }
                else {
                    returnView.sectionButton.setTitle("Steps", forState: UIControlState.Normal)
                    return returnView
                }
                
            }
        }
        return nil
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
