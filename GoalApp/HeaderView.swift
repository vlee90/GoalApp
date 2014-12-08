//
//  HeaderView.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/7/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet weak var sectionButton: UIButton!
    
    @IBAction func sectionButtonPressed(sender: UIButton) {
        if sender.titleLabel!.text! == "Goals" {
            println("Pressed on Goals")
        }
        else if sender.titleLabel!.text! == "Objectives" {
            println("Pressed on Objectives")
        }
        else {
            println("Pressed on Steps")
        }
    }
}
