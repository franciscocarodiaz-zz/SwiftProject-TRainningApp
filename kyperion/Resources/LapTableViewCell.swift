//
//  LapTableViewCell.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 11/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class LapTableViewCell: UITableViewCell {

    @IBOutlet weak var column1: UILabel!
    @IBOutlet weak var column2: UILabel!
    @IBOutlet weak var column3: UILabel!
    @IBOutlet weak var column4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
