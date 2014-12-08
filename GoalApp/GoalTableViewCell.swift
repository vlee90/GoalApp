//
//  GoalTableViewCell.swift
//  GoalApp
//
//  Created by Vincent Lee on 12/5/14.
//  Copyright (c) 2014 VincentLee. All rights reserved.
//

import UIKit

class GoalTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
