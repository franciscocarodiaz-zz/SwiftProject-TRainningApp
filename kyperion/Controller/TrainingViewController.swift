//
//  TrainingViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 22/08/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit
import CoreLocation

class TrainingViewController: UIViewController, SBPickerSelectorDelegate, trainingManagerDelegate {

    var trackingActivity = false
    var disableLocationManager = false
    
    var trainingManager: TrainingManager?
    
    //var coreLocationController:CoreLocationController?
    //var dataLocationController:CoreLocationController?
    
    let sportData = [LocalizedString_Sport_Swim, LocalizedString_Sport_Cyc, LocalizedString_Sport_Run]
    let lapData = ["100", "200", "500", "1000", "10000", LocalizedString_Sport_WithoutAutoLaps]
    let sportPicker: SBPickerSelector = SBPickerSelector.picker()
    let pickerDataImage = [AssetsManager.swimmingImage, AssetsManager.cyclingImage, AssetsManager.runningImage]
    
    let lapPicker: SBPickerSelector = SBPickerSelector.picker()
    
    var timersView : UIView = UIView()
    var tagTimersView = 1
    var totalTimesView : UIView = UIView()
    var tagTotalTimesView = 11
    var totalTimesView_Time : UIView = UIView()
    var tagTotalTimesView_Time = 111
    var totalTimesView_Distance : UIView = UIView()
    var tagTotalTimesView_Distance = 112
    var totalTimesView_Pace : UIView = UIView()
    var tagTotalTimesView_Pace = 113
    
    var timer = NSTimer()
    var timerLaps = NSTimer()
    var counterTotalTime = 0
    var counterLapTime = 0
    
    var lapTimesView : UIView = UIView()
    var tagLapTimesView = 12
    var totalCounterLabel = UILabel()
    var totalKmCounterLabel = UILabel()
    var lapKmCounterLabel = UILabel()
    var totalPaceCounterLabel = UILabel()
    var lapPaceCounterLabel = UILabel()
    var lapCounterLabel = UILabel()
    var lapTimesView_Time : UIView = UIView()
    var tagLapTimesView_Time = 121
    var lapTimesView_Distance : UIView = UIView()
    var tagLapTimesView_Distance = 122
    var lapTimesView_Pace : UIView = UIView()
    var tagLapTimesView_Pace = 123
    
    var actionsView : UIView = UIView()
    var tagActionsView = 2
    var optionsView : UIView = UIView()
    var optionsView_SportSelected : UIImageView = UIImageView()
    var optionsView_RowSportSelected : Int = 0
    var optionsView_LapSelected : UILabel = UILabel()
    var optionsView_RowLapSelected : Int = 3
    var tagOptionsView = 21
    var tagOptionsView_Start = 211
    var tagOptionsView_Finish = 212
    var tagOptionsView_Resume = 213
    var buttonsView : UIView = UIView()
    var tagButtonsView = 22
    var startButton: KYButton! = KYButton()
    var finishButtonX : CGFloat = 0
    var startButtonWidth : CGFloat = 0
    var startButtonHeight : CGFloat = 0
    var finishButton: KYButton! = KYButton()
    
    var totalTimer = NSTimer()
    var lapTimer = NSTimer()
    
    var sportLabel = UILabel()
    var lapLabel = UILabel()
    var lapButton: KYButton! = KYButton()
    
    var totalPaceUnitLabel = UILabel()
    var lapPaceUnitLabel = UILabel()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = LocalizedString_Sport_Training
        self.view.backgroundColor = UIColor.bgdTrainingVC()
        
        createViews()
        
        /*
        if DEBUG_MOD {
            paintBgd()
        }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalCounterLabel.text = counterTotalTime.formattedTime()
        lapCounterLabel.text = counterLapTime.formattedTime()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.trainingManager = nil
        stopTimer()
        stopTimerLap()
    }
    
    var cyclingIsSelected : Bool {
        return optionsView_RowSportSelected == 1
    }
    
    func dataLocationAvailable(notification:NSNotification) -> Void {
        
        let userInfo: NSDictionary
        if let userInfo = notification.userInfo {
            
            // 1. Get parameter
            let _differenceBetweenCurrentPositionAndFirstLap = userInfo["differenceBetweenCurrentPositionAndFirstLap"] as! Double
            let _differenceBetweenCurrentPositionAndStartLocationOfCurrentLap = userInfo["differenceBetweenCurrentPositionAndStartLocationOfCurrentLap"] as! Double
            
            // 2. Calculate distance and pace
            var totalDistance = _differenceBetweenCurrentPositionAndFirstLap
            var totalPace = 0.0
            
            var partialDistance = _differenceBetweenCurrentPositionAndStartLocationOfCurrentLap
            var partialPace = 0.0
            
            if cyclingIsSelected {
                totalPace = totalDistance / durationTotalInHours
                partialPace = partialDistance / durationLapInHours
            }else{
                totalPace = durationTotalInMinutes / totalDistance
                partialPace = durationLapInMinutes / partialDistance
            }
            
            // 3. Update screen
            
            updateTotalDistance(totalDistance.formattedCounter())
            updateLapDistance(partialDistance.formattedCounter())
            
            updateTotalPace(totalPace.formattedCounter())
            updateLapPace(partialPace.formattedCounter())
            
            
        }
    }
    
    func dataLocationAvailableFinish(notification:NSNotification) -> Void {
        
        let userInfo: NSDictionary
        if let userInfo = notification.userInfo {
            
            // 1. Get parameter
            let _differenceBetweenCurrentPositionAndFirstLap = userInfo["differenceBetweenCurrentPositionAndFirstLap"] as! Double
            let _differenceBetweenCurrentPositionAndStartLocationOfCurrentLap = userInfo["differenceBetweenCurrentPositionAndStartLocationOfCurrentLap"] as! Double
            
            // 2. Calculate distance and pace
            var totalDistance = _differenceBetweenCurrentPositionAndFirstLap
            var totalPace = 0.0
            
            var partialDistance = _differenceBetweenCurrentPositionAndStartLocationOfCurrentLap
            var partialPace = 0.0
            
            if cyclingIsSelected {
                totalPace = totalDistance / durationTotalInHours
                partialPace = partialDistance / durationLapInHours
            }else{
                totalPace = durationTotalInMinutes / totalDistance
                partialPace = durationLapInMinutes / partialDistance
            }
            
            // 3. Update screen
            
            updateTotalDistance(totalDistance.formattedCounter())
            updateLapDistance(partialDistance.formattedCounter())
            
            updateTotalPace(totalPace.formattedCounter())
            updateLapPace(partialPace.formattedCounter())
            
            TrackManager.sharedManager.sendTrack()
        }
        
        finishLocationManager()
    }
    
    
    
    func locationAvailable(notification:NSNotification) -> Void {
        
        let userInfo: NSDictionary
        if let userInfo = notification.userInfo {
            
            let locality = userInfo["locality"] as! String
            let country = userInfo["country"] as! String
            let altitude = userInfo["altitude"] as! Double
            let latitude = userInfo["latitude"] as! Double
            let longitude = userInfo["longitude"] as! Double
            let horizontalAccuracy = userInfo["horizontalAccuracy"] as! Double
            let verticalAccuracy = userInfo["verticalAccuracy"] as! Double
            let speed = userInfo["speed"] as! Double
            let timestamp = userInfo["timestamp"] as! NSDate
            let course = userInfo["speed"] as! Double
            let name = userInfo["name"] as! String
            let state = userInfo["state"] as! String
            let distance = userInfo["distance"] as! Double
            
            let today = NSDate.today()
            var coord = CLLocationCoordinate2DMake(latitude, longitude)
            var loc = CLLocation(coordinate: coord, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, speed: speed, timestamp: timestamp)
            let kylocation = KYLocation(location: loc, locality:locality, country:country, state:state, duration: durationTotal, name: name)
            
            if !currentActivity.isInit {
                currentActivity.startLocation = kylocation
            }
            currentActivity.endLocation = kylocation
            generateLapTime(userInfo)
            
            if disableLocationManager {
                if !lastLapEndLocationShouldBeFilled {
                    finishLocationManager()
                }
            }
            /*
            var totalDistance = String(stringInterpolationSegment: distance)
            updateTotalDistance(totalDistance)
            var totalPace = String(stringInterpolationSegment: speed)
            updateTotalPace(totalPace)
            */
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createViews(){
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.bounds.size.height
        let statusBarSizeHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = navigationBarHeight + statusBarSizeHeight
        let screenHeight = self.view.frame.size.height - navBarHeight
        
        // MARK: 1. Create TimersView
        let xTimersView: CGFloat = 0
        let yTimersView: CGFloat = navigationBarHeight + statusBarSizeHeight
        let widthTimersView: CGFloat = self.view.frame.size.width
        let heightTimersView: CGFloat = screenHeight/1.5
        
        createTimersView(x: xTimersView, y: yTimersView, width: widthTimersView, height: heightTimersView)
        
        // MARK: 2. Create ActionsView
        let xActionsView: CGFloat = 0
        let yActionsView: CGFloat = yTimersView + self.timersView.frame.size.height
        let widthActionsView: CGFloat = widthTimersView
        let heightActionsView: CGFloat = screenHeight - heightTimersView
        
        createActionsView(x: xActionsView, y: yActionsView, width: widthActionsView, height: heightActionsView)
    }
    
    // MARK: Create Sections
    
    func createTimersView(x xTimersView: CGFloat, y yTimersView:CGFloat, width widthTimersView:CGFloat, height heightTimersView:CGFloat){
        
        timersView = UIView(frame: CGRectMake(xTimersView, yTimersView, widthTimersView, heightTimersView))
        
        
        // MARK: 1.1. Create TotalTimesView
        let xTotalTimesView: CGFloat = 0
        let yTotalTimesView: CGFloat = 0
        let widthTotalTimesView: CGFloat = widthTimersView/2
        let heightTotalTimesView: CGFloat = heightTimersView
        
        createTotalTimesView(x: xTotalTimesView, y: yTotalTimesView, width: widthTotalTimesView, height: heightTotalTimesView)
        
        // MARK: 1.2. Create LapTimesView
        let xLapTimesView: CGFloat = widthTotalTimesView
        let yLapTimesView: CGFloat = 0
        let widthLapTimesView: CGFloat = widthTimersView/2
        let heightLapTimesView: CGFloat = heightTimersView
        
        createLapTimesView(x: xLapTimesView, y: yLapTimesView, width: widthLapTimesView, height: heightLapTimesView)
        
        timersView.tag = tagTimersView
        self.view.addSubview(timersView)
    }
    
    func createTotalTimesView(x xTotalTimesView: CGFloat, y yTotalTimesView:CGFloat, width widthTotalTimesView:CGFloat, height heightTotalTimesView:CGFloat){
        
        totalTimesView = UIView(frame: CGRectMake(xTotalTimesView, yTotalTimesView, widthTotalTimesView, heightTotalTimesView))
        
        // MARK: 1.1.1. Create TotalTimes: Time View
        let xTotalTimesView_Time: CGFloat = xTotalTimesView
        let yTotalTimesView_Time: CGFloat = yTotalTimesView
        let widthTotalTimesView_Time: CGFloat = widthTotalTimesView
        let heightTotalTimesView_Time: CGFloat = heightTotalTimesView/3
        
        createTotalTimesView_Time(x: xTotalTimesView_Time, y: yTotalTimesView_Time, width: widthTotalTimesView_Time, height: heightTotalTimesView_Time)
        
        // MARK: 1.1.1. Create TotalTimes: Distance View
        let xTotalTimesView_Distance: CGFloat = xTotalTimesView
        let yTotalTimesView_Distance: CGFloat = heightTotalTimesView_Time
        let widthTotalTimesView_Distance: CGFloat = widthTotalTimesView
        let heightTotalTimesView_Distance: CGFloat = heightTotalTimesView/3
        
        createTotalTimesView_Distance(x: xTotalTimesView_Distance, y: yTotalTimesView_Distance, width: widthTotalTimesView_Distance, height: heightTotalTimesView_Distance)
        
        // MARK: 1.1.1. Create TotalTimes: Time View
        let xTotalTimesView_Pace: CGFloat = xTotalTimesView
        let yTotalTimesView_Pace: CGFloat = heightTotalTimesView_Distance*2
        let widthTotalTimesView_Pace: CGFloat = widthTotalTimesView
        let heightTotalTimesView_Pace: CGFloat = heightTotalTimesView/3
        
        createTotalTimesView_Pace(x: xTotalTimesView_Pace, y: yTotalTimesView_Pace, width: widthTotalTimesView_Pace, height: heightTotalTimesView_Pace)
        
        totalTimesView.tag = tagTotalTimesView
        self.timersView.addSubview(totalTimesView)
    }
    
    func createTotalTimesView_Time(x xTotalTimesView_Time: CGFloat, y yTotalTimesView_Time:CGFloat, width widthTotalTimesView_Time:CGFloat, height heightTotalTimesView_Time:CGFloat){
        
        totalTimesView_Time = UIView(frame: CGRectMake(xTotalTimesView_Time, yTotalTimesView_Time, widthTotalTimesView_Time, heightTotalTimesView_Time))
        
        var titleLabel = UILabel(frame: CGRectMake(xTotalTimesView_Time, yTotalTimesView_Time, widthTotalTimesView_Time, heightTotalTimesView_Time/4))
        titleLabel.text = NSLocalizedString("Total", comment: "Total string")
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(16.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        self.totalTimesView_Time.addSubview(titleLabel)
        
        var counterLabelView = UIView(frame: CGRectMake(xTotalTimesView_Time, titleLabel.frame.height, widthTotalTimesView_Time, heightTotalTimesView_Time/2))
        
        totalCounterLabel = UILabel(frame: CGRectMake(0, 6, counterLabelView.frame.width, counterLabelView.frame.height - 20))
        totalCounterLabel.text = durationTotal
        totalCounterLabel.textColor = UIColor.whiteColor()
        totalCounterLabel.font = UIFont.boldSystemFontOfSize(30.0)
        totalCounterLabel.textAlignment = NSTextAlignment.Center
        
        counterLabelView.addSubview(totalCounterLabel)
        self.totalTimesView_Time.addSubview(counterLabelView)
        
        var timeLabelView = UIView(frame: CGRectMake(xTotalTimesView_Time, titleLabel.frame.height + totalCounterLabel.frame.size.height, widthTotalTimesView_Time, heightTotalTimesView_Time/4))
        
        var timeLabel = UILabel(frame: CGRectMake(0, 0, timeLabelView.frame.width, 20))
        timeLabel.text = NSLocalizedString("Time", comment: "Time string")
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(12.0)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        timeLabelView.addSubview(timeLabel)
        self.totalTimesView_Time.addSubview(timeLabelView)
        
        
        totalTimesView_Time.tag = tagTotalTimesView_Time
        self.totalTimesView.addSubview(totalTimesView_Time)
    }
    
    func createTotalTimesView_Distance(x xTotalTimesView_Distance: CGFloat, y yTotalTimesView_Distance:CGFloat, width widthTotalTimesView_Distance:CGFloat, height heightTotalTimesView_Distance:CGFloat){
        
        totalTimesView_Distance = UIView(frame: CGRectMake(xTotalTimesView_Distance, yTotalTimesView_Distance, widthTotalTimesView_Distance, heightTotalTimesView_Distance))
        
        var counterLabelView = UIView(frame: CGRectMake(xTotalTimesView_Distance, 10, widthTotalTimesView_Distance, heightTotalTimesView_Distance/2))
        totalKmCounterLabel = UILabel(frame: CGRectMake(0, 15, counterLabelView.frame.width, counterLabelView.frame.height - 20))
        updateTotalDistance("000.00")
        totalKmCounterLabel.textColor = UIColor.whiteColor()
        totalKmCounterLabel.font = UIFont.boldSystemFontOfSize(30.0)
        totalKmCounterLabel.textAlignment = NSTextAlignment.Center
        totalKmCounterLabel.sizeToFit()
        
        counterLabelView.addSubview(totalKmCounterLabel)
        totalTimesView_Distance.addSubview(counterLabelView)
        totalKmCounterLabel.center = counterLabelView.center
        
        var unitLabel = UILabel()
        unitLabel.text = NSLocalizedString("km", comment: "Km string")
        unitLabel.textColor = UIColor.whiteColor()
        unitLabel.font = UIFont.boldSystemFontOfSize(14.0)
        unitLabel.textAlignment = NSTextAlignment.Center
        unitLabel.frame = CGRectMake(totalKmCounterLabel.center.x + totalKmCounterLabel.frame.width/2, totalKmCounterLabel.frame.height/2 + 7, totalKmCounterLabel.frame.width/2 - 5, totalKmCounterLabel.frame.height)
        counterLabelView.addSubview(unitLabel)
        
        var timeLabelView = UIView(frame: CGRectMake(xTotalTimesView_Distance, counterLabelView.frame.height + 10, widthTotalTimesView_Distance, heightTotalTimesView_Distance/4))
        
        var timeLabel = UILabel(frame: CGRectMake(0, 0, timeLabelView.frame.width, 20))
        timeLabel.text = NSLocalizedString("Distance", comment: "Distance string")
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(12.0)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        timeLabelView.addSubview(timeLabel)
        totalTimesView_Distance.addSubview(timeLabelView)
        
        totalTimesView_Distance.tag = tagTotalTimesView_Distance
        self.totalTimesView.addSubview(totalTimesView_Distance)
    }
    
    func createTotalTimesView_Pace(x xTotalTimesView_Pace: CGFloat, y yTotalTimesView_Pace:CGFloat, width widthTotalTimesView_Pace:CGFloat, height heightTotalTimesView_Pace:CGFloat){
        
        totalTimesView_Pace = UIView(frame: CGRectMake(xTotalTimesView_Pace, yTotalTimesView_Pace, widthTotalTimesView_Pace, heightTotalTimesView_Pace))
        
        var counterLabelView = UIView(frame: CGRectMake(xTotalTimesView_Pace, 10, widthTotalTimesView_Pace - 12, heightTotalTimesView_Pace/2))
        totalPaceCounterLabel = UILabel(frame: CGRectMake(0, 15, counterLabelView.frame.width, counterLabelView.frame.height - 20))
        updateTotalPace("00:00")
        totalPaceCounterLabel.textColor = UIColor.whiteColor()
        totalPaceCounterLabel.font = UIFont.boldSystemFontOfSize(30.0)
        totalPaceCounterLabel.textAlignment = NSTextAlignment.Center
        totalPaceCounterLabel.sizeToFit()
        
        counterLabelView.addSubview(totalPaceCounterLabel)
        totalTimesView_Pace.addSubview(counterLabelView)
        totalPaceCounterLabel.center = counterLabelView.center
        
        totalPaceUnitLabel.text = LocalizedString_MinKm
        totalPaceUnitLabel.textColor = UIColor.whiteColor()
        totalPaceUnitLabel.font = UIFont.boldSystemFontOfSize(10.0)
        totalPaceUnitLabel.textAlignment = NSTextAlignment.Center
        //unitLabel.sizeToFit()
        totalPaceUnitLabel.frame = CGRectMake(totalPaceCounterLabel.center.x + totalPaceCounterLabel.frame.width/2 + 5, totalPaceCounterLabel.frame.height/2 + 7, totalPaceCounterLabel.frame.width/2 + 10, totalPaceCounterLabel.frame.height)
        counterLabelView.addSubview(totalPaceUnitLabel)
        
        var timeLabelView = UIView(frame: CGRectMake(xTotalTimesView_Pace, counterLabelView.frame.height + 10, widthTotalTimesView_Pace, heightTotalTimesView_Pace/4))
        
        var timeLabel = UILabel(frame: CGRectMake(0, 0, timeLabelView.frame.width, 20))
        timeLabel.text = NSLocalizedString("Pace", comment: "Pace string")
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(12.0)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        timeLabelView.addSubview(timeLabel)
        totalTimesView_Pace.addSubview(timeLabelView)
        
        totalTimesView_Pace.tag = tagTotalTimesView_Pace
        self.totalTimesView.addSubview(totalTimesView_Pace)
    }
    
    func createLapTimesView(x xLapTimesView: CGFloat, y yLapTimesView:CGFloat, width widthLapTimesView:CGFloat, height heightLapTimesView:CGFloat){
        
        lapTimesView = UIView(frame: CGRectMake(xLapTimesView, yLapTimesView, widthLapTimesView, heightLapTimesView))
        
        // MARK: 1.1.1. Create TotalTimes: Time View
        let xLapTimesView_Time: CGFloat = xLapTimesView
        let yLapTimesView_Time: CGFloat = yLapTimesView
        let widthLapTimesView_Time: CGFloat = widthLapTimesView
        let heightLapTimesView_Time: CGFloat = heightLapTimesView/3
        
        createLapTimesView_Time(x: xLapTimesView_Time, y: yLapTimesView_Time, width: widthLapTimesView_Time, height: heightLapTimesView_Time)
        
        // MARK: 1.1.2. Create TotalTimes: Distance View
        let xLapTimesView_Distance: CGFloat = xLapTimesView
        let yLapTimesView_Distance: CGFloat = heightLapTimesView_Time
        let widthLapTimesView_Distance: CGFloat = widthLapTimesView
        let heightLapTimesView_Distance: CGFloat = heightLapTimesView/3
        
        createLapTimesView_Distance(x: xLapTimesView_Distance, y: yLapTimesView_Distance, width: widthLapTimesView_Distance, height: heightLapTimesView_Distance)
        
        // MARK: 1.1.3. Create TotalTimes: Time View
        let xLapTimesView_Pace: CGFloat = xLapTimesView
        let yLapTimesView_Pace: CGFloat = heightLapTimesView_Time*2
        let widthLapTimesView_Pace: CGFloat = widthLapTimesView
        let heightLapTimesView_Pace: CGFloat = heightLapTimesView/3
        
        createLapTimesView_Pace(x: xLapTimesView_Pace, y: yLapTimesView_Pace, width: widthLapTimesView_Pace, height: heightLapTimesView_Pace)
        
        lapTimesView.tag = tagLapTimesView
        self.timersView.addSubview(lapTimesView)
    }
    
    func createLapTimesView_Time(x xLapTimesView_Time: CGFloat, y yLapTimesView_Time:CGFloat, width widthLapTimesView_Time:CGFloat, height heightLapTimesView_Time:CGFloat){
        
        lapTimesView_Time = UIView(frame: CGRectMake(0, yLapTimesView_Time, widthLapTimesView_Time, heightLapTimesView_Time))
        
        var titleLabel = UILabel(frame: CGRectMake(0, yLapTimesView_Time, widthLapTimesView_Time, heightLapTimesView_Time/4))
        titleLabel.text = NSLocalizedString("Last partial", comment: "Last partial string")
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(16.0)
        titleLabel.textAlignment = NSTextAlignment.Center
        self.lapTimesView_Time.addSubview(titleLabel)
        
        var counterLabelView = UIView(frame: CGRectMake(0, titleLabel.frame.height, widthLapTimesView_Time, heightLapTimesView_Time/2))
        
        lapCounterLabel = UILabel(frame: CGRectMake(0, 6, counterLabelView.frame.width, counterLabelView.frame.height - 20))
        lapCounterLabel.text = durationLap
        lapCounterLabel.textColor = UIColor.whiteColor()
        lapCounterLabel.font = UIFont.boldSystemFontOfSize(30.0)
        lapCounterLabel.textAlignment = NSTextAlignment.Center
        
        counterLabelView.addSubview(lapCounterLabel)
        self.lapTimesView_Time.addSubview(counterLabelView)
        
        var timeLabelView = UIView(frame: CGRectMake(0, titleLabel.frame.height + lapCounterLabel.frame.size.height, widthLapTimesView_Time, heightLapTimesView_Time/4))
        
        var timeLabel = UILabel(frame: CGRectMake(0, 0, timeLabelView.frame.width, 20))
        timeLabel.text = NSLocalizedString("Time", comment: "Time string")
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(12.0)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        timeLabelView.addSubview(timeLabel)
        self.lapTimesView_Time.addSubview(timeLabelView)
        
        
        lapTimesView_Time.tag = tagLapTimesView_Time
        self.lapTimesView.addSubview(lapTimesView_Time)
    }
    
    func createLapTimesView_Distance(x xLapTimesView_Distance: CGFloat, y yLapTimesView_Distance:CGFloat, width widthLapTimesView_Distance:CGFloat, height heightLapTimesView_Distance:CGFloat){
        
        lapTimesView_Distance = UIView(frame: CGRectMake(0, yLapTimesView_Distance, widthLapTimesView_Distance, heightLapTimesView_Distance))
        
        var counterLabelView = UIView(frame: CGRectMake(0, 10, widthLapTimesView_Distance, heightLapTimesView_Distance/2))
        lapKmCounterLabel = UILabel(frame: CGRectMake(0, 15, counterLabelView.frame.width, counterLabelView.frame.height - 20))
        updateLapDistance("000.00")
        lapKmCounterLabel.textColor = UIColor.whiteColor()
        lapKmCounterLabel.font = UIFont.boldSystemFontOfSize(30.0)
        lapKmCounterLabel.textAlignment = NSTextAlignment.Center
        lapKmCounterLabel.sizeToFit()
        
        counterLabelView.addSubview(lapKmCounterLabel)
        lapTimesView_Distance.addSubview(counterLabelView)
        lapKmCounterLabel.center = counterLabelView.center
        
        var unitLabel = UILabel()
        unitLabel.text = NSLocalizedString("km", comment: "Km string")
        unitLabel.textColor = UIColor.whiteColor()
        unitLabel.font = UIFont.boldSystemFontOfSize(14.0)
        unitLabel.textAlignment = NSTextAlignment.Center
        unitLabel.frame = CGRectMake(lapKmCounterLabel.center.x + lapKmCounterLabel.frame.width/2, lapKmCounterLabel.frame.height/2 + 7, lapKmCounterLabel.frame.width/2 - 5, lapKmCounterLabel.frame.height)
        counterLabelView.addSubview(unitLabel)
        
        var timeLabelView = UIView(frame: CGRectMake(0, counterLabelView.frame.height + 10, widthLapTimesView_Distance, heightLapTimesView_Distance/4))
        
        var timeLabel = UILabel(frame: CGRectMake(0, 0, timeLabelView.frame.width, 20))
        timeLabel.text = NSLocalizedString("Distance", comment: "Distance string")
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(12.0)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        timeLabelView.addSubview(timeLabel)
        lapTimesView_Distance.addSubview(timeLabelView)
        
        
        lapTimesView_Distance.tag = tagLapTimesView_Distance
        self.lapTimesView.addSubview(lapTimesView_Distance)
    }
    
    func createLapTimesView_Pace(x xLapTimesView_Pace: CGFloat, y yLapTimesView_Pace:CGFloat, width widthLapTimesView_Pace:CGFloat, height heightLapTimesView_Pace:CGFloat){
        
        lapTimesView_Pace = UIView(frame: CGRectMake(0, yLapTimesView_Pace, widthLapTimesView_Pace, heightLapTimesView_Pace))
        
        var counterLabelView = UIView(frame: CGRectMake(0, 10, widthLapTimesView_Pace - 10, heightLapTimesView_Pace/2))
        lapPaceCounterLabel = UILabel(frame: CGRectMake(0, 15, counterLabelView.frame.width, counterLabelView.frame.height - 20))
        updateLapPace("00:00")
        lapPaceCounterLabel.textColor = UIColor.whiteColor()
        lapPaceCounterLabel.font = UIFont.boldSystemFontOfSize(30.0)
        lapPaceCounterLabel.textAlignment = NSTextAlignment.Center
        lapPaceCounterLabel.sizeToFit()
        
        counterLabelView.addSubview(lapPaceCounterLabel)
        lapTimesView_Pace.addSubview(counterLabelView)
        lapPaceCounterLabel.center = counterLabelView.center
        
        lapPaceUnitLabel.text = LocalizedString_MinKm
        lapPaceUnitLabel.textColor = UIColor.whiteColor()
        lapPaceUnitLabel.font = UIFont.boldSystemFontOfSize(10.0)
        lapPaceUnitLabel.textAlignment = NSTextAlignment.Center
        //unitLabel.sizeToFit()
        lapPaceUnitLabel.frame = CGRectMake(lapPaceCounterLabel.center.x + lapPaceCounterLabel.frame.width/2 + 5, lapPaceCounterLabel.frame.height/2 + 7, lapPaceCounterLabel.frame.width/2 + 10, lapPaceCounterLabel.frame.height)
        counterLabelView.addSubview(lapPaceUnitLabel)
        
        var timeLabelView = UIView(frame: CGRectMake(0, counterLabelView.frame.height + 10, widthLapTimesView_Pace, heightLapTimesView_Pace/4))
        
        var timeLabel = UILabel(frame: CGRectMake(0, 0, timeLabelView.frame.width, 20))
        timeLabel.text = NSLocalizedString("Pace", comment: "Pace string")
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.boldSystemFontOfSize(12.0)
        timeLabel.textAlignment = NSTextAlignment.Center
        
        timeLabelView.addSubview(timeLabel)
        lapTimesView_Pace.addSubview(timeLabelView)
        
        lapTimesView_Pace.tag = tagLapTimesView_Pace
        self.lapTimesView.addSubview(lapTimesView_Pace)
    }
    
    func createActionsView(x xActionsView: CGFloat, y yActionsView:CGFloat, width widthActionsView:CGFloat, height heightActionsView:CGFloat){
        
        actionsView = UIView(frame: CGRectMake(xActionsView, yActionsView, widthActionsView, heightActionsView))
        
        // MARK: 2.1. Create OptionsView
        let xOptionsView: CGFloat = 0
        let yOptionsView: CGFloat = 0
        let widthOptionsView: CGFloat = widthActionsView
        let heightOptionsView: CGFloat = heightActionsView/1.5
        
        createOptionsView(x: xOptionsView, y: yOptionsView, width: widthOptionsView, height: heightOptionsView)
        
        // MARK: 2.2. Create ButtonsView
        let xButtonsView: CGFloat = xActionsView
        let yButtonsView: CGFloat = heightOptionsView
        let widthButtonsView: CGFloat = widthActionsView
        let heightButtonsView: CGFloat = heightActionsView - heightOptionsView
        
        createButtonsView(x: xButtonsView, y: yButtonsView, width: widthButtonsView, height: heightButtonsView)
        
        actionsView.tag = tagActionsView
        self.view.addSubview(actionsView)
    }
    
    func createOptionsView(x xOptionsView: CGFloat, y yOptionsView:CGFloat, width widthOptionsView:CGFloat, height heightOptionsView:CGFloat){
        
        optionsView = UIView(frame: CGRectMake(xOptionsView, yOptionsView, widthOptionsView, heightOptionsView))
        
        // MARK: 2.1.1. Create OptionsView: Sport selector
        let xView: CGFloat = 0
        let yView: CGFloat = 0
        let widthView: CGFloat = widthOptionsView/2
        let heightView: CGFloat = heightOptionsView
        
        var optionsView_SportSelectorView = UIView(frame: CGRectMake(0, 0, widthView, heightView/1.5))
        
        optionsView_SportSelected.frame = CGRectMake(0, 15, widthView, heightView - 20)
        optionsView_SportSelected = AssetsManager.runningImageVw
        
        optionsView_SportSelectorView.addSubview(optionsView_SportSelected)
        optionsView_SportSelected.center = optionsView_SportSelectorView.center
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "sportSelectorAction:")
        optionsView_SportSelected.addGestureRecognizer(gestureRecognizer)
        optionsView_SportSelected.userInteractionEnabled = true
        
        sportLabel = UILabel(frame: CGRectMake(0, optionsView_SportSelectorView.frame.origin.y + optionsView_SportSelectorView.frame.height - 15, widthView, 20))
        sportLabel.text = NSLocalizedString("Sport", comment: "Sport string")
        sportLabel.textColor = UIColor.whiteColor()
        sportLabel.font = UIFont.boldSystemFontOfSize(12.0)
        sportLabel.textAlignment = NSTextAlignment.Center
        optionsView_SportSelectorView.addSubview(sportLabel)

        self.optionsView.addSubview(optionsView_SportSelectorView)
        
        // MARK: 2.1.2. Create OptionsView: Lap selector
        var optionsView_LapSelectorView = UIView(frame: CGRectMake(widthView, 0, widthView, heightView/1.5))
        
        var lapButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        lapButton.configureButtonWithHightlightedShadowAndZoom(true)
        var image = AssetsManager.lapImage
        lapButton.frame = CGRectMake(0, 0, widthView, heightView/1.5)
        lapButton.setImage(AssetsManager.lapImage, forState: UIControlState.Normal)
        lapButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        let gestureRecognizerLap = UITapGestureRecognizer(target: self, action: "lapSelectorAction:")
        lapButton.addGestureRecognizer(gestureRecognizerLap)
        lapButton.userInteractionEnabled = true
        optionsView_LapSelectorView.addSubview(lapButton)
        
        /*
        button.addTarget(self, action: "buttonTouchDown:", forControlEvents: .TouchDown)
        func buttonTouchDown(sender:UIButton!){
            println("button Touch Down")
        }
        */
        
        optionsView_LapSelected.frame = CGRectMake(0, heightView/1.5, widthView, heightView - heightView/1.5)
        
        var root = NSLocalizedString("Lap", comment: "Lap string")
        optionsView_LapSelected.text = "\(root) : \(lapData[optionsView_RowLapSelected])"
        
        optionsView_LapSelected.textColor = UIColor.whiteColor()
        optionsView_LapSelected.font = UIFont.boldSystemFontOfSize(12.0)
        optionsView_LapSelected.textAlignment = NSTextAlignment.Center
        optionsView_LapSelectorView.addSubview(optionsView_LapSelected)
        
        self.optionsView.addSubview(optionsView_LapSelectorView)
        
        optionsView.tag = tagOptionsView
        self.actionsView.addSubview(optionsView)
    }
    
    func sportSelectorAction(sender: UIPanGestureRecognizer!) {
        
        if !trackingActivity {
            sportPicker.pickerData = sportData
            sportPicker.tag = 1
            sportPicker.delegate = self
            sportPicker.pickerType = SBPickerSelectorType.Text
            sportPicker.doneButtonTitle = LocalizedString_Select
            sportPicker.cancelButtonTitle = ""
            sportPicker.doneButton.tintColor = UIColor.mainAppColor()
            
            let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
            var frame: CGRect = self.view.frame
            frame.origin = point
            sportPicker.showPickerIpadFromRect(frame, inView: view)
        }
        
    }
    var markCurrentLap = false
    func lapSelectorAction(sender: UIPanGestureRecognizer!) {
        
        if !trackingActivity {
            lapPicker.pickerData = lapData
            lapPicker.tag = 2
            lapPicker.delegate = self
            lapPicker.pickerType = SBPickerSelectorType.Text
            lapPicker.doneButtonTitle = LocalizedString_Select
            lapPicker.cancelButtonTitle = ""
            lapPicker.doneButton.tintColor = UIColor.mainAppColor()
        
            let point: CGPoint = view.convertPoint(self.view.frame.origin, fromView: self.view.superview)
                var frame: CGRect = self.view.frame
            frame.origin = point
            lapPicker.showPickerIpadFromRect(frame, inView: view)
        }else{
            // Mark lap
            markCurrentLap = true
            self.trainingManager?.startTracking()
        }
    }
    
    func initLocationManager(){
        trackingActivity = true
        
        self.trainingManager = TrainingManager()
        self.trainingManager?.delegate = self
        
        if lapDataEnabled {
            self.trainingManager?.locationManager.distanceFilter = distanceFilter
        }else{
            self.trainingManager?.enableFilterNone()
        }
    }
    
    
    func finishLocationManager(){
        trackingActivity = false
        self.trainingManager?.stopTracking()
    }
    
    func createButtonsView(x xButtonsView: CGFloat, y yButtonsView:CGFloat, width widthButtonsView:CGFloat, height heightButtonsView:CGFloat){
        
        buttonsView = UIView(frame: CGRectMake(xButtonsView, yButtonsView, widthButtonsView, heightButtonsView))
        
        startButtonWidth = widthButtonsView/2
        startButtonHeight = heightButtonsView
        startButton.frame = CGRectMake(0, 0, self.view.frame.width, startButtonHeight)
        startButton.configureButtonWithHightlightedShadowAndZoom(true)
        startButton.setTitle(LocalizedString_Start, forState: UIControlState.Normal)
        startButton.titleLabel!.font = UIFont.boldSystemFontOfSize(36.0)
        startButton.titleLabel?.textColor = UIColor.whiteColor()
        startButton.tag = tagOptionsView_Start
        
        let startButtonTapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("startButtonPressed:"))
        startButton.addGestureRecognizer(startButtonTapGestureRecognizer)
        startButton.userInteractionEnabled = true
        
        finishButtonX = widthButtonsView/2
        finishButton.frame = CGRectMake(finishButtonX, 0, startButtonWidth, startButtonHeight)
        finishButton.configureButtonWithHightlightedShadowAndZoom(true)
        finishButton.setTitle(LocalizedString_Stop, forState: UIControlState.Normal)
        finishButton.titleLabel?.textColor = UIColor.whiteColor()
        finishButton.titleLabel!.font = UIFont.boldSystemFontOfSize(36.0)
        finishButton.tag = tagOptionsView_Finish
        finishButton.hidden = true
        
        let finishButtonTapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("finishButtonPressed:"))
        finishButton.addGestureRecognizer(finishButtonTapGestureRecognizer)
        finishButton.userInteractionEnabled = true
        
        startButton.fadeIn()
        finishButton.fadeIn()
        buttonsView.addSubview(startButton)
        buttonsView.addSubview(finishButton)
        
        buttonsView.tag = tagButtonsView
        self.actionsView.addSubview(buttonsView)
    }
    
    // MARK: Aux functions
    
    func generateLapTime(userInfo: [NSObject : AnyObject]){
        
        // GPS Info
        let locality = userInfo["locality"] as! String
        let country = userInfo["country"] as! String
        let altitude = userInfo["altitude"] as! Double
        let latitude = userInfo["latitude"] as! Double
        let longitude = userInfo["longitude"] as! Double
        let horizontalAccuracy = userInfo["horizontalAccuracy"] as! Double
        let verticalAccuracy = userInfo["verticalAccuracy"] as! Double
        let speed = userInfo["speed"] as! Double
        let timestamp = userInfo["timestamp"] as! NSDate
        let course = userInfo["course"] as! Double
        let name = userInfo["name"] as! String
        let distance = userInfo["distance"] as! Double
        
        TrackManager.sharedManager.addLap(durationLap, distanceUnit: distanceUnit, distanceValue: kmLap, locality: locality, country: country, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, speed: speed, timestamp: timestamp, course: course, name: name, locationLatitude: latitude, locationLongitude: longitude)
        
        if !timerLaps.valid{
            startTimerLap()
        }
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateCounters"), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func startTimerLap(){
        counterLapTime = 0
        AudioManager.sharedInstance.playBeepSound()
        timerLaps = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: Selector("resetLapTimers"), userInfo: nil, repeats: false)
    }
    
    func stopTimerLap(){
        print("\n stopTimerLap()")
        timerLaps.invalidate()
    }
    
    func updateCounters() {
        counterTotalTime++
        updateTotalCountersLabel()
        counterLapTime++
        updateLapCountersLabel()
    }
    
    // MARK: Update total view labels
    
    func updateTotalCountersLabel() {
        totalCounterLabel.text = counterTotalTime.formattedTime()
    }
    
    func updateTotalDistance(totalDistance: String){
        totalKmCounterLabel.text = totalDistance
    }
    
    func updateTotalPace(pace: String){
        totalPaceCounterLabel.text = pace
    }
    
    // MARK: Update lap view labels
    
    func updateLapCountersLabel() {
        if timerLaps.valid {
            print("\n LapCountersLabel NOT updated")
        }else{
            print("\n LapCountersLabel updated")
            lapCounterLabel.text = counterLapTime.formattedTime()
        }
    }
    
    func updateLapDistance(lapDistance: String) {
        lapKmCounterLabel.text = lapDistance
    }
    
    func updateLapPace(pace: String){
        lapPaceCounterLabel.text = pace
    }
    
    func updatePaceUnitLabel(){
        if cyclingIsSelected {
            var label = LocalizedString_KmH
            totalPaceUnitLabel.text = label
            lapPaceUnitLabel.text = label
        }else{
            var label = LocalizedString_MinKm
            totalPaceUnitLabel.text = LocalizedString_MinKm
            lapPaceUnitLabel.text = LocalizedString_MinKm
        }
    }
    
    func updateTracking(){
        self.trainingManager?.startTracking()
    }
    
    
    func resetLapTimers(){
        
        lapTimesView.animate()
        
        lapCounterLabel.text = durationLap
        
        //updateLapDistance("0")
        //updateLapPace("0")
        
        //stopTimerLap()
    }
    
    var distanceUnit : String = "Km"
    
    var kmLap : String {
        return lapKmCounterLabel.text!
    }
    
    var kmTotal : String {
        return totalKmCounterLabel.text!
    }
    
    var lastLapHasEndLocation : Bool {
        return TrackManager.sharedManager.lastLapHasEndLocation
    }
    
    var lastLapEndLocationShouldBeFilled : Bool {
        return TrackManager.sharedManager.lastLapEndLocationShouldBeFilled
    }
    
    var durationLap : String {
        return String(counterLapTime)
    }
    
    var durationTotal : String {
        return String(counterTotalTime)
    }
    
    var durationTotalInMinutes : Double {
        return Double(counterTotalTime.formattedTimeInMinutes())
    }
    
    var durationTotalInSeconds : Double {
        return Double(counterTotalTime.formattedTimeInseconds())
    }
    
    var durationLapInSeconds : Double {
        return Double(counterLapTime.formattedTimeInseconds())
    }
    
    var durationLapInMinutes : Double {
        return Double(counterLapTime.formattedTimeInMinutes())
    }
    
    var durationTotalInHours : Double {
        return Double(counterTotalTime.formattedTimeInHours())
    }
    
    var durationLapInHours : Double {
        return Double(counterLapTime.formattedTimeInHours())
    }
    
    
    
    var distanceFilter : Double {
        let dFilter = lapData[optionsView_RowLapSelected].toDouble()!
        return dFilter
    }
    
    var lapDataEnabled : Bool {
        var optionDisabledLocation = lapData.count-1
        var enabledDataLocation = (optionDisabledLocation != optionsView_RowLapSelected)
        if !enabledDataLocation {
            print("Location data received is not actived when NO AUTOLAPS is marked.")
        }
        return enabledDataLocation
    }
    
    /*
    func actionButtonPressed(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        
        if let buttonView = gesture.view as? KYButton {
            if buttonView.tag == tagOptionsView_Start {
                print("Tapped Start button")
                
                startTracking()
                startTimer()
                
                startButton.setTitle(LocalizedString_Pause, forState: UIControlState.Normal)
                startButton.tag = tagOptionsView_Resume
                if startButton.titleLabel?.text == LocalizedString_Start {
                    totalCounterLabel.animate()
                    lapCounterLabel.animate()
                }
                finishButtonHidden(false)
            }else if buttonView.tag == tagOptionsView_Finish {
                print("Tapped Finish button")
                
                stopTracking()
                startButton.tag = tagOptionsView_Start
                
                finishButtonHidden(true)
                startButton.setTitle(LocalizedString_Start, forState: UIControlState.Normal)
            }else if buttonView.tag == tagOptionsView_Resume {
                print("Tapped Resume button")
                startButton.animate()
                startButton.tag = tagOptionsView_Start
                startButton.setTitle(LocalizedString_Resume, forState: UIControlState.Normal)
                
                NSNotificationCenter.defaultCenter().removeObserver(self)
                timer.invalidate()
            }
        }
    }
    */
    func finishButtonHidden(hide: Bool){
        finishButton.hidden = hide
        if hide {
            startButton.frame = CGRectMake(0, 0, self.view.frame.width, startButtonHeight)
        }else{
            startButton.frame = CGRectMake(0, 0, startButtonWidth, startButtonHeight)
            finishButton.frame = CGRectMake(finishButtonX, 0, startButtonWidth, startButtonHeight)
            
            //finishButton.frame.size = startButton.frame.size
        }
        startButton.configureButtonWithHightlightedShadowAndZoom(true)
        finishButton.configureButtonWithHightlightedShadowAndZoom(true)
    }
    
    //MARK: SBPickerSelectorDelegate
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        if contains(sportData, value) {
            optionsView_RowSportSelected = idx
            optionsView_SportSelected.image = pickerDataImage[optionsView_RowSportSelected]
            var root = NSLocalizedString("Sport", comment: "Sport string")
            sportLabel.text = "\(root) : \(value)"
            updatePaceUnitLabel()
            
        }else{
            //optionsView_LapSelected.text = value
            
            var root = NSLocalizedString("Lap", comment: "Lap string")
            if idx == lapData.count-1 {
                optionsView_LapSelected.text = NSLocalizedString("No autolaps", comment: "No autolaps")
                if trackingActivity {
                    stopTracking()
                    stopTimer()
                }
            }else{
                optionsView_LapSelected.text = "\(root) : \(value)"
            }
            optionsView_RowLapSelected = idx
        }
    }
    
    
    func pickerSelector(selector: SBPickerSelector!, cancelPicker cancel: Bool) {
        print("Cancel option pressed.")
    }
    
    func pickerSelector(selector: SBPickerSelector!, intermediatelySelectedValue value: AnyObject!, atIndex idx: Int) {
        pickerSelector(selector, selectedValue: value as! String, index: idx)
    }
    
    // MARK: - Remove Observer
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func paintBgd(){
        timersView.backgroundColor = UIColor.blueColor()
        totalTimesView.backgroundColor = UIColor.clearColor()
        totalTimesView_Time.backgroundColor = UIColor.redColor()
        totalCounterLabel.backgroundColor = UIColor.mainAppColor()
        totalTimesView_Distance.backgroundColor = UIColor.gymColor()
        totalKmCounterLabel.backgroundColor = UIColor.mainAppColor()
        totalTimesView_Pace.backgroundColor = UIColor.greenColor()
        totalPaceCounterLabel.backgroundColor = UIColor.mainAppColor()
        lapTimesView.backgroundColor = UIColor.grayColor()
        lapTimesView_Time.backgroundColor = UIColor.blueColor()
        lapCounterLabel.backgroundColor = UIColor.mainAppColor()
        lapTimesView_Distance.backgroundColor = UIColor.blueColor()
        lapKmCounterLabel.backgroundColor = UIColor.mainAppColor()
        lapTimesView_Pace.backgroundColor = UIColor.greenColor()
        lapPaceCounterLabel.backgroundColor = UIColor.mainAppColor()
        actionsView.backgroundColor = UIColor.redColor()
        optionsView.backgroundColor = UIColor.blueColor()
        sportLabel.backgroundColor = UIColor.blueColor()
        optionsView_LapSelected.backgroundColor = UIColor.blueColor()
        buttonsView.backgroundColor = UIColor.grayColor()
    }
    
    // MARK: - User api manager delegate
    
    func StartTracking() {
        
        startTimer()
        
        startButton.setTitle(LocalizedString_Pause, forState: UIControlState.Normal)
        startButton.tag = tagOptionsView_Resume
        if startButton.titleLabel?.text == LocalizedString_Start {
            totalCounterLabel.animate()
            lapCounterLabel.animate()
        }
        finishButtonHidden(false)
        
        finishButton.configureButtonWithHightlightedShadowAndZoom(true)
        startButton.configureButtonWithHightlightedShadowAndZoom(true)
        
        let currentLocation = currentActivity.startLocation
        currentActivity.altitude = currentLocation.location.altitude
        
        TrackManager.sharedManager.addFirstLap(durationLap, distanceUnit: distanceUnit, distanceValue: kmLap, location: currentLocation)
        
        self.trainingManager?.startTracking()
        
    }
    
    func StopTracking() {
        let currentLocation = currentActivity.endLocation
        
        // Update height
        var currentAltitude = currentLocation.location.altitude
        var diff = abs(currentAltitude - currentActivity.altitude)
        if diff > 0 {
            if currentAltitude > currentActivity.altitude {
                currentActivity.height.gain = currentActivity.height.gain + diff
            }else{
                currentActivity.height.lost = currentActivity.height.lost + diff
            }
        }
        generateLapTime(currentLocation)
        
        currentActivity.duration = durationTotal
        currentActivity.distance = kmTotal
        TrackManager.sharedManager.sendTrack()
        
        totalCounterLabel.animate()
        lapCounterLabel.animate()
        
        totalKmCounterLabel.animate()
        lapKmCounterLabel.animate()
        
        totalPaceCounterLabel.animate()
        lapPaceCounterLabel.animate()
        
        stopTimer()
        
        counterTotalTime = 0
        counterLapTime = 0
        totalCounterLabel.text = durationTotal
        lapCounterLabel.text = durationLap
        
        
    }
    
    func TraickingNotAuthorized(msgError: String){
        print("\(msgError)")
    }
    
    func CurrentLocation(userInfo :[NSObject : AnyObject]) {
        let currentLocation = currentActivity.endLocation
        var lapMarked = false
        if lapDataEnabled {
            var currentDistance = currentLocation.location.calculateDistanceBetweenTwoLocations(currentActivity.startLocation.location)
            var res = currentDistance % distanceFilter == 0
            if res && currentDistance > 0 {
                generateLapTime(currentLocation)
                startTimerLap()
                lapMarked = true
            }
        }
        
        if !lapMarked && markCurrentLap {
            markCurrentLap = false
            
            generateLapTime(currentLocation)
            startTimerLap()
        }
        
        self.trainingManager?.startTracking()
        
        
        // Update screen
        
        // 1. Get parameter
        let _differenceBetweenCurrentPositionAndFirstLap = userInfo["differenceBetweenCurrentPositionAndFirstLap"] as! Double
        let _differenceBetweenCurrentPositionAndStartLocationOfCurrentLap = userInfo["differenceBetweenCurrentPositionAndStartLocationOfCurrentLap"] as! Double
        
        // 2. Calculate distance and pace
        var totalDistance = _differenceBetweenCurrentPositionAndFirstLap
        var totalPace = 0.0
        
        var partialDistance = _differenceBetweenCurrentPositionAndStartLocationOfCurrentLap
        var partialPace = 0.0
        
        if cyclingIsSelected {
            totalPace = totalDistance / durationTotalInHours
            partialPace = partialDistance / durationLapInHours
        }else{
            if durationTotalInMinutes > 60 {
                totalPace = durationTotalInMinutes / totalDistance
            }
            if durationLapInMinutes > 60 {
                partialPace = durationLapInMinutes / partialDistance
            }
            
        }
        
        // 3. Update screen
        
        updateTotalDistance(totalDistance.formattedCounter())
        updateTotalPace(totalPace.formattedCounter())
        if !timerLaps.valid {
            updateLapDistance(partialDistance.formattedCounter())
            updateLapPace(partialPace.formattedCounter())
        }
        
        // Update height
        var currentAltitude = currentLocation.location.altitude
        var diff = abs(currentAltitude - currentActivity.altitude)
        if diff > 0 {
            if currentAltitude > currentActivity.altitude {
                currentActivity.height.gain = currentActivity.height.gain + diff
            }else{
                currentActivity.height.lost = currentActivity.height.lost + diff
            }
        }
        
        
    }
    
    func generateLapTime(currentLocation: KYLocation){
        
        TrackManager.sharedManager.addLap(durationLap, distanceUnit: distanceUnit, distanceValue: kmLap, location: currentLocation)
        
    }
    
    // MARK: Button actions
    
    func startButtonPressed(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        
        if let buttonView = gesture.view as? KYButton {
            if buttonView.tag == tagOptionsView_Start {
                
                startTracking()
                
            }else if buttonView.tag == tagOptionsView_Resume {
                startButton.animate()
                startButton.tag = tagOptionsView_Start
                startButton.setTitle(LocalizedString_Resume, forState: UIControlState.Normal)
                
                NSNotificationCenter.defaultCenter().removeObserver(self)
                timer.invalidate()
            }
            
        }
    }
    
    func finishButtonPressed(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        
        if let buttonView = gesture.view as? KYButton {
            stopTracking()
            
            startButton.tag = tagOptionsView_Start
            finishButtonHidden(true)
            startButton.setTitle(LocalizedString_Start, forState: UIControlState.Normal)
            
        }
    }
    
    func startTracking(){
        var sportType : SportType = SportType.RUNNING
        if optionsView_RowSportSelected == 0 {
            sportType = SportType.SWIMMING
        }else if optionsView_RowSportSelected == 1 {
            sportType = SportType.CYCLING
        }else if optionsView_RowSportSelected == 2 {
            sportType = SportType.RUNNING
        }
        
        TrackManager.sharedManager.createActivity(sportType)
        
        initLocationManager()
    }
    
    func stopTracking(){
        trackingActivity = false
        
        self.trainingManager?.stopTracking()
        
    }
    
    
}
