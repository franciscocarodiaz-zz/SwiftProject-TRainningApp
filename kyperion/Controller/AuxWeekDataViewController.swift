//
//  WeekDataViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

class AuxWeekDataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    var dataObjectAux: String = ""
    
    var mondayDataObject = [UIImageView]()
    var tuesdayDataObject = [UIImageView]()
    var wednesdayDataObject = [UIImageView]()
    var thursdayDataObject = [UIImageView]()
    var fridayDataObject = [UIImageView]()
    var saturdayDataObject = [UIImageView]()
    var sundayDataObject = [UIImageView]()
    
    @IBOutlet weak var dataLabelAux: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
        self.dataLabelAux!.text = dataObject
        self.imageView = mondayDataObject[0]
        /*
        for item in mondayDataObject {
            self.mondayStackView.addSubview(item)
            self.mondayStackView.addArrangedSubview(item)
            self.imageView = item
        }
        self.mondayStackView.layoutIfNeeded()
        UIView.animateWithDuration(0.25, animations: {
            self.mondayStackView.layoutIfNeeded()
        })
        
        for item in tuesdayDataObject {
            self.tuesdayStackView.addSubview(item)
        }
        UIView.animateWithDuration(0.25, animations: {
            self.tuesdayStackView.layoutIfNeeded()
        })
        
        for item in wednesdayDataObject {
            self.wednesdayStackView.addArrangedSubview(item)
        }
        UIView.animateWithDuration(0.25, animations: {
            self.wednesdayStackView.layoutIfNeeded()
        })
        
        for item in thursdayDataObject {
            self.thursdayStackView.addArrangedSubview(item)
        }
        UIView.animateWithDuration(0.25, animations: {
            self.thursdayStackView.layoutIfNeeded()
        })
        
        for item in fridayDataObject {
            self.fridayStackView.addArrangedSubview(item)
        }
        UIView.animateWithDuration(0.25, animations: {
            self.fridayStackView.layoutIfNeeded()
        })
        
        for item in saturdayDataObject {
            self.saturdayStackView.addArrangedSubview(item)
        }
        UIView.animateWithDuration(0.25, animations: {
            self.saturdayStackView.layoutIfNeeded()
        })
        
        for item in sundayDataObject {
            self.sundayStackView.addArrangedSubview(item)
        }
        UIView.animateWithDuration(0.25, animations: {
            self.sundayStackView.layoutIfNeeded()
        })
        */
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
