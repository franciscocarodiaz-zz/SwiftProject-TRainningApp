//
//  GraphicVelocityViewController.swift
//  kyperion
//
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit

class GraphicVelocityViewController: UIViewController, APChartViewDelegate, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var chart: APChartView!
    @IBOutlet var lblPoint: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chart.delegate = self
        
        createLine()
    }
    
    func createLine(){
        chart.collectionLines = []
        var line = APChartLine(chartView: chart, title: "altimetria", lineWidth: 0.0, lineColor: UIColor.grayColor())
        var x:CGFloat = 1
        var y:CGFloat = 1
        
        var altimetryPoints = currentActivity.altimetryArrayLapsSorted()
        for item in altimetryPoints {
            y = CGFloat(item)
            x = x+1
            line.addPoint( CGPoint(x: x, y: y))
        }
        line.showMeanValueProgressive = false
        line.showMeanValue = false
        chart.showLabelsX = false
        chart.showLabelsY = false
        chart.areaUnderLinesVisible = true
        chart.addLine(line)
        
        line = APChartLine(chartView: chart, title: "data", lineWidth: 2.0, lineColor: UIColor.blueColor())
        x = 1
        
        var velocityPoints = currentActivity.velocityArrayLapsSorted()
        for item in velocityPoints {
            y = CGFloat(item)
            x = x+1
            line.addPoint( CGPoint(x: x, y: y))
        }
        line.showMeanValueProgressive = false
        line.showMeanValue = false
        chart.showDots = false
        chart.showLabelsX = false
        chart.showLabelsY = false
        
        chart.addLine(line)
        
        chart.setNeedsDisplay()
        
    }
    
    func didSelectNearDataPoint(selectedDots: [String : APChartPoint]) {
        var txt = ""
        for (title,value) in selectedDots {
            txt = "\(txt)\(title): \(value.dot)\n"
        }
        lblPoint.text = txt
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chartV = chart {
            chartV.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentActivity.laps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let lapCell = tableView.dequeueReusableCellWithIdentifier("LapCell") as! LapTableViewCell
        
        lapCell.frame.size.width = self.view.frame.size.width
        
        var width = lapCell.frame.width / 4
        var height = lapCell.frame.height
        
        lapCell.column1.frame = CGRectMake(0, 0, width, height)
        lapCell.column2.frame = CGRectMake(width, 0, width, height)
        lapCell.column3.frame = CGRectMake(width*2, 0, width, height)
        lapCell.column4.frame = CGRectMake(width*4, 0, width, height)
        
        
        var idx:Int = indexPath.row
        
        var lap = currentActivity.lapsSorted()[idx]
        
        if idx % 2 == 0 {
            lapCell.backgroundColor = UIColor.rowCell()
        }else{
            lapCell.backgroundColor = UIColor.whiteColor()
        }
        lapCell.column1.text = "\(lap.order)"
        lapCell.column1.adjustsFontSizeToFitWidth = true
        lapCell.column2.text = lap.totalTimerTime.formattedTime()
        lapCell.column3.text = "\(lap.distanceFormatted)"
        lapCell.column4.text = "\(lap.avgSpeed) \(currentActivity.paceUnit)"
        lapCell.column4.adjustsFontSizeToFitWidth = true
        
        return lapCell
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderLapCell") as! HeaderLapTableViewCell
        
        headerCell.frame.size.width = self.view.frame.size.width
        
        var width = headerCell.frame.width / 4
        var height = headerCell.frame.height
        
        headerCell.column1.frame = CGRectMake(0, 0, width, height)
        headerCell.column2.frame = CGRectMake(width, 0, width, height)
        headerCell.column3.frame = CGRectMake(width*2, 0, width, height)
        headerCell.column4.frame = CGRectMake(width*4, 0, width, height)
        
        headerCell.backgroundColor = UIColor.headerCell()
        headerCell.column1.text = LocalizedString_Column_1
        headerCell.column2.text = LocalizedString_Column_2
        headerCell.column3.text = LocalizedString_Column_3
        headerCell.column4.text = LocalizedString_Column_4
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.mainAppColor(0.7)
        
        var idx:Int = indexPath.row
        
        var lap = currentActivity.lapsSorted()[idx]
        chart.updateDots(idx, reset: true)
        
        
    }

}
