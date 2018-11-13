//
//  ActivityTableViewCell.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateActivity: UILabel!
    @IBOutlet weak var imageActivity: UIImageView!
    @IBOutlet weak var usernameActivity: UILabel!
    @IBOutlet weak var dataActivity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
