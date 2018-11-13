//
//  ProfileCustomHeaderTableViewCell.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 02/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class ProfileCustomHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func actionButtonPressed(sender: UIButton) {
    
    }
}
