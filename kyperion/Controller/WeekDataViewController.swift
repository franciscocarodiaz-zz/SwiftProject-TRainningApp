//
//  WeekDataViewController.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WeekDataViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: Properties week info resume
    ///  Returns the progress view for the controller.
    let xProgressViews : CGFloat = 40
    let heightProgressViews : CGFloat = 40
    var spaceBetweenProgressViews : CGFloat = 20
    
    var margin: CGFloat = 40
    
    var yMondayProgressView : CGFloat = 10
    var yTuesdayProgressView : CGFloat = 30
    var yWednesdayProgressView : CGFloat = 50
    var yThursdayProgressView : CGFloat = 70
    var yFridayProgressView : CGFloat = 90
    var ySaturdayProgressView : CGFloat = 110
    var ySundayProgressView : CGFloat = 130
    
    var yMondayLabel : CGFloat = 10
    var yTuesdayLabel : CGFloat = 30
    var yWednesdayLabel : CGFloat = 50
    var yThursdayLabel : CGFloat = 70
    var yFridayLabel : CGFloat = 90
    var ySaturdayLabel : CGFloat = 110
    var ySundayLabel : CGFloat = 130
    
    // Parameter default: Header table
    let defaultHeightLabel : CGFloat = 40
    var defaultColorBackgroundTextLblHeaderTable : UIColor = UIColor.clearColor()
    var defaultTextColorHeaderTable : UIColor = UIColor.whiteColor()
    var defaultTextSizeHeaderTable : CGFloat = CGFloat(16.0)
    
    // Parameter default: Label progressView
    var defaultColorBackgroundProgressView : UIColor = UIColor.clearColor()
    var defaultTextColorProgressView : UIColor = UIColor.grayColor()
    var defaultTextSizeLbl : CGFloat = CGFloat(14.0)
    
    // Parameter default: Resume view
    var defaultNumberOfRowInResume: Int = 3
    var defaultColorBackgroundTextLblResume : UIColor = UIColor.grayColor()
    var defaultTextColorResume : UIColor = UIColor.blackColor()
    var defaultTextSizeResume : CGFloat = CGFloat(10.0)
    
    var dataLabel: UILabel!
    
    var dataObject: String = ""
    var numColumn: Int = 1
    
    var weekIndex : Int = 1
    
    var requestCalendarWeek: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
            self.requestCalendarWeek?.responseJSON {
                (request, response, data, error) -> Void in
                
                if(error == nil){
                    /*
                    if let calendarEventArray = data!.array {
                        for calendarEventItem in calendarEventArray {
                            let event : KYCalendarEvent = KYCalendarEvent(calendarEventItem)
                            if (currentUser.calendarEvents.filter { $0.id == event.id }).isEmpty {
                                currentUser.calendarEvents.append(event)
                            }
                            
                        }
                        currentUser.calendarEvents.sort({ $0.getDate().compare($1.getDate()) == NSComparisonResult.OrderedDescending })
                    }
                    NSNotificationCenter.defaultCenter().postNotificationName(updateCalendarWeekNotificationKey, object: data)
                    */
                }

            }
        }
    }
    
    var hasPreviousWeek : Bool = false
    var hasNextWeek : Bool = false
    
    var daysDataObject = [[UIImageView]]()
    var dataObjectDays : [[UIImageView]] = []
    var weekDataObject : [[UIImageView]] = []
    
    var mondayDataObject : [UIImageView] = [AssetsManager.cyclingImageVw,AssetsManager.gymImageVw, AssetsManager.runningImageVw, AssetsManager.swimmingImageVw, AssetsManager.cyclingImageVw]
    var tuesdayDataObject : [UIImageView] = [AssetsManager.gymImageVw, AssetsManager.runningImageVw, AssetsManager.swimmingImageVw]
    var wednesdayDataObject : [UIImageView] = [AssetsManager.cyclingImageVw,AssetsManager.gymImageVw, AssetsManager.swimmingImageVw]
    var thursdayDataObject : [UIImageView] = [AssetsManager.cyclingImageVw]
    var fridayDataObject : [UIImageView] = [AssetsManager.cyclingImageVw,AssetsManager.runningImageVw, AssetsManager.swimmingImageVw]
    var saturdayDataObject : [UIImageView] = [AssetsManager.cyclingImageVw]
    var sundayDataObject : [UIImageView] = [AssetsManager.gymImageVw, AssetsManager.runningImageVw, AssetsManager.swimmingImageVw]
    
    let colors = [UIColor.redColor(),UIColor.yellowColor(),UIColor.blueColor(),UIColor.whiteColor(),UIColor.redColor(),UIColor.greenColor(),UIColor.redColor()]
    
    var scrollView: UIScrollView!
    
    var calendarView: UIView!
    var contentView: UIView!
    
    var buttonPrevious:UIButton!
    var buttonNext:UIButton!
    
    var mondayView : UIView = UIView()
    var tuesdayView : UIView = UIView()
    var wednesdayView : UIView = UIView()
    var thursdayView : UIView = UIView()
    var fridayView : UIView = UIView()
    var saturdayView : UIView = UIView()
    var sundayView : UIView = UIView()
    
    var defaultBackgroundColorDayView : UIColor = UIColor.whiteColor()
    
    var weekInfoResume: UIView!
    var progressView : UIView = UIView()
    var progressViewMonday: ProgressView!
    var progressViewTuesday: ProgressView!
    var progressViewWednesday: ProgressView!
    var progressViewThursday: ProgressView!
    var progressViewFriday: ProgressView!
    var progressViewSaturday: ProgressView!
    var progressViewSunday: ProgressView!
    
    var weekTableDataResume: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Defining the content size of the scrollview
        scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        //scrollView = UIScrollView(frame: CGRectMake(xScrollView, yScrollView, widthScrollView, heightScrollView))
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.scrollEnabled = true
        scrollView.alwaysBounceVertical = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        createViews()
    }
    
    func createViews(){
        
        // MARK: Create CalendarView
        let xCalendarView: CGFloat = 0
        let yCalendarView: CGFloat = 40
        let widthCalendarView: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? self.view.frame.size.width - 45 : self.view.frame.size.width
        let heightCalendarView: CGFloat = self.view.frame.size.height/3
        
        createCalendarView(x: xCalendarView, y: yCalendarView, width: widthCalendarView, height: heightCalendarView)
        
        
        // MARK: Create WeekInfoResume
        
        let xWeekInfoResume: CGFloat = 0
        let aux_y_WeekInfoResume: CGFloat = calendarView.frame.origin.y + calendarView.frame.size.height
        let yWeekInfoResume: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? aux_y_WeekInfoResume - 45 : aux_y_WeekInfoResume
        let widthWeekInfoResume: CGFloat = self.view.frame.size.width
        let heightWeekInfoResume: CGFloat = self.view.frame.size.height/3
        
        createWeekInfoResume(x:xWeekInfoResume, y: yWeekInfoResume, width:widthWeekInfoResume, height: heightWeekInfoResume)
        
        
        // MARK: Create WeekTableDataResume
        
        let xWeekTableDataResume: CGFloat = 10
        let yWeekTableDataResume: CGFloat = weekInfoResume.frame.origin.y + weekInfoResume.frame.size.height + 10
        let widthWeekTableDataResume: CGFloat = self.view.frame.size.width - 20
        let heightWeekTableDataResume: CGFloat = (self.view.frame.size.height/3) - 20
        
        createMonthlyYearlyTotalTable(x: xWeekTableDataResume, y: yWeekTableDataResume, width: widthWeekTableDataResume, height: heightWeekTableDataResume)
        
        self.scrollView.addSubview(weekTableDataResume)
        
        //Defining the content size of the scrollview
        let totalHeight = calendarView.frame.size.height + weekInfoResume.frame.size.height + weekTableDataResume.frame.size.height + 250
        let scrollHeight = scrollView.frame.size.height>totalHeight ? scrollView.frame.size.height : totalHeight
        scrollView.contentSize = CGSize(width: self.view.frame.size.width,
            height: scrollHeight)
        
        self.view.addSubview(self.scrollView)
    
    }
    
    // MARK: Icon tapped
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if let imageView = gesture.view as? UIImageView {
            print("Image \(imageView.frame)")
        }else if let buttonView = gesture.view as? UIButton {
            if buttonView.tag == 1 {
                print("Tapped left button")
            }else if buttonView.tag == 2 {
                print("Tapped right button")
            }
        }
    }

    // MARK: - Auxiliar function
    
    func refreshViewWithData(){
        
        var numDay = CGFloat(0.0)
        var intNumDay = 0
        let widthItem = CGFloat(25)
        let xItem = widthItem/2
        let heightItem = CGFloat(25)
        
        // Monday
        var numAct = CGFloat(0.0)
        var numActCounter = 0
        var arrayObjs = Array(self.weekDataObject[0])
        var numItemColumn = CGFloat(arrayObjs.count)
        var totalHeight = mondayView.frame.size.height
        var totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            mondayView.addSubview(itemIv)
            mondayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        
        // Tuesday
        numAct = CGFloat(0.0)
        numActCounter = 0
        arrayObjs = Array(self.weekDataObject[1])
        numItemColumn = CGFloat(arrayObjs.count)
        totalHeight = tuesdayView.frame.size.height
        totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            tuesdayView.addSubview(itemIv)
            tuesdayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        // Wednesday
        numAct = CGFloat(0.0)
        numActCounter = 0
        arrayObjs = Array(self.weekDataObject[2])
        numItemColumn = CGFloat(arrayObjs.count)
        totalHeight = wednesdayView.frame.size.height
        totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            wednesdayView.addSubview(itemIv)
            wednesdayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        // Thursday
        numAct = CGFloat(0.0)
        numActCounter = 0
        arrayObjs = Array(self.weekDataObject[3])
        numItemColumn = CGFloat(arrayObjs.count)
        totalHeight = thursdayView.frame.size.height
        totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            thursdayView.addSubview(itemIv)
            thursdayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        // Friday
        numAct = CGFloat(0.0)
        numActCounter = 0
        arrayObjs = Array(self.weekDataObject[4])
        numItemColumn = CGFloat(arrayObjs.count)
        totalHeight = fridayView.frame.size.height
        totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            fridayView.addSubview(itemIv)
            fridayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        // Saturday
        numAct = CGFloat(0.0)
        numActCounter = 0
        arrayObjs = Array(self.weekDataObject[5])
        numItemColumn = CGFloat(arrayObjs.count)
        totalHeight = saturdayView.frame.size.height
        totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            saturdayView.addSubview(itemIv)
            saturdayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        
        // Sunday
        numAct = CGFloat(0.0)
        numActCounter = 0
        arrayObjs = Array(self.weekDataObject[6])
        numItemColumn = CGFloat(arrayObjs.count)
        totalHeight = sundayView.frame.size.height
        totalHeightForItem = totalHeight / numItemColumn
        for item in arrayObjs {
            let itemIv = item as UIImageView
            let dividendo = ((2*numActCounter)+1)
            let res = Float(dividendo)/Float(2)
            let yItem = CGFloat(res) * CGFloat(totalHeightForItem)
            itemIv.frame = CGRectMake(xItem, yItem - 12, widthItem, heightItem)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
            itemIv.addGestureRecognizer(tapGestureRecognizer)
            itemIv.userInteractionEnabled = true
            sundayView.addSubview(itemIv)
            sundayView.backgroundColor = UIColor.whiteColor()
            numAct = numAct + 1.0
            numActCounter++
        }
        numDay = numDay + 1.0
        intNumDay++
        
        
    }
    
    func calculateMaxLengthProgressView() -> CGFloat {
        let initialPoint : CGPoint = CGPointMake(xProgressViews, yMondayProgressView)
        let endPoint : CGPoint = CGPointMake(progressView.frame.origin.x + progressView.frame.width, yMondayProgressView)
        
        let xDist : CGFloat = (endPoint.x - initialPoint.x);
        let yDist : CGFloat = (endPoint.y - initialPoint.y);
        let maxLengthProgressView : CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return maxLengthProgressView
    }
    
    // MARK: Create Sections Week tab
    
    func createCalendarView(x xCalendarView: CGFloat, y yCalendarView:CGFloat, width widthCalendarView:CGFloat, height heightCalendarView:CGFloat){
        
        // 1: Header calendar table
        
        self.dataLabel = UILabel(frame: CGRectMake(0, 10, self.view.frame.width, 30))
        self.dataLabel!.text = dataObject
        dataLabel.textColor = UIColor.mainAppColor()
        dataLabel.font = UIFont.boldSystemFontOfSize(16.0)
        dataLabel.textAlignment = NSTextAlignment.Center
        dataLabel.backgroundColor = UIColor.whiteColor()
        self.scrollView.addSubview(self.dataLabel)
        
        let tapGestureRecognizerLeftButton = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        buttonPrevious = UIButton(frame: CGRectMake(40, 15, 20, 20))
        buttonPrevious.backgroundColor = UIColor.mainAppColor()
        buttonPrevious.setTitle("<", forState: UIControlState.Normal)
        buttonPrevious.addGestureRecognizer(tapGestureRecognizerLeftButton)
        buttonPrevious.userInteractionEnabled = true
        buttonPrevious.tag = 1;
        if hasPreviousWeek {
            self.scrollView.addSubview(buttonPrevious)
        }
        
        let tapGestureRecognizerRightButton = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        buttonNext = UIButton(frame: CGRectMake(self.scrollView.frame.origin.x + self.scrollView.frame.width-50, 15, 20, 20))
        buttonNext.backgroundColor = UIColor.mainAppColor()
        buttonNext.setTitle(">", forState: UIControlState.Normal)
        buttonNext.tag = 2;
        buttonNext.addGestureRecognizer(tapGestureRecognizerRightButton)
        buttonNext.userInteractionEnabled = true
        if hasNextWeek {
            self.scrollView.addSubview(buttonNext)
        }
        
        // MARK: 2: Calendar table
        
        calendarView = UIView(frame: CGRectMake(xCalendarView, yCalendarView, widthCalendarView, heightCalendarView))
        //calendarView.layoutMargins = UIEdgeInsets(top: margin, left: margin,bottom: margin, right: margin)
        contentView = UIView(frame: CGRectMake(0, 40, widthCalendarView, (self.view.frame.size.height/3)))
        
        let width = contentView.frame.size.width
        let nColum = CGFloat(7.0)
        let columnWidth = width / nColum
        let height = contentView.frame.size.height
        
        
        // Monday
        mondayView = UIView(frame: CGRectMake(0 + 2, 2, columnWidth-4, height-4))
        //mondayView.layoutMargins = UIEdgeInsets(top: margin, left: margin,bottom: margin, right: margin)
        mondayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(mondayView)
        
        var frameLbl = CGRectMake(0, 0, columnWidth, defaultHeightLabel)
        var textLbl = LocalizedString_Day_M
        var textColorLbl = defaultTextColorHeaderTable
        var textSizeLbl = defaultTextSizeHeaderTable
        var textBackgroundColorLbl = defaultColorBackgroundTextLblHeaderTable
        
        let lblMonday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblMonday)
        
        // Tuesday
        tuesdayView = UIView(frame: CGRectMake(columnWidth + 2, 2, columnWidth-4, height-4))
        //tuesdayView.layoutMargins = UIEdgeInsets(top: margin, left: margin,bottom: margin, right: margin)
        tuesdayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(tuesdayView)
        
        frameLbl = CGRectMake(columnWidth, 0, columnWidth, defaultHeightLabel)
        textLbl = LocalizedString_Day_T
        
        let lblTuesday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblTuesday)
        
        // Wednesday
        wednesdayView = UIView(frame: CGRectMake(columnWidth*2 + 2, 2, columnWidth-4, height-4))
        //wednesdayView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        wednesdayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(wednesdayView)
        
        frameLbl = CGRectMake(columnWidth*2, 0, columnWidth, defaultHeightLabel)
        textLbl = LocalizedString_Day_W
        
        let lblWednesday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblWednesday)
        
        // Thursday
        thursdayView = UIView(frame: CGRectMake(columnWidth*3 + 2, 2, columnWidth-4, height-4))
        //thursdayView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        thursdayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(thursdayView)
        
        frameLbl = CGRectMake(columnWidth*3, 0, columnWidth, defaultHeightLabel)
        textLbl = LocalizedString_Day_TH
        
        let lblThursday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblThursday)
        
        // Friday
        fridayView = UIView(frame: CGRectMake(columnWidth*4 + 2, 2, columnWidth-4, height-4))
        //fridayView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        fridayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(fridayView)
        
        frameLbl = CGRectMake(columnWidth*4, 0, columnWidth, defaultHeightLabel)
        textLbl = LocalizedString_Day_F
        
        let lblFriday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblFriday)
        
        // Saturday
        saturdayView = UIView(frame: CGRectMake(columnWidth*5 + 2, 2, columnWidth-4, height-4))
        //saturdayView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        saturdayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(saturdayView)
        
        frameLbl = CGRectMake(columnWidth*5, 0, columnWidth, defaultHeightLabel)
        textLbl = LocalizedString_Day_Sa
        
        let lblSaturday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblSaturday)
        
        // Sunday
        sundayView = UIView(frame: CGRectMake(columnWidth*6 + 2, 2, columnWidth-4, height-4))
        //sundayView.layoutMargins = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        sundayView.backgroundColor = defaultBackgroundColorDayView
        contentView.addSubview(sundayView)
        
        frameLbl = CGRectMake(columnWidth*6, 0, columnWidth, defaultHeightLabel)
        textLbl = LocalizedString_Day_S
        
        let lblSunday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        calendarView.addSubview(lblSunday)
        
        
        calendarView.addSubview(contentView)
        calendarView.backgroundColor = UIColor.mainAppColor()
        refreshViewWithData()
        
        let heightCalendar : CGFloat = contentView.frame.height + lblMonday.frame.height
        let cgrectCalendar = CGRectMake(calendarView.frame.origin.x, calendarView.frame.origin.y, calendarView.frame.size.width, heightCalendar)
        calendarView.frame = cgrectCalendar
        self.scrollView.addSubview(calendarView)
    }
    
    func createWeekInfoResume(x xWeekInfoResume: CGFloat, y yWeekInfoResume:CGFloat, width widthWeekInfoResume:CGFloat, height heightWeekInfoResume:CGFloat){
        
        weekInfoResume = UIView(frame: CGRectMake(xWeekInfoResume, yWeekInfoResume, widthWeekInfoResume, heightWeekInfoResume))
        
        // MARK: Create WeekInfoResume : Progress view
        
        let xWeekInfoResume_ProgressViewSection: CGFloat = xWeekInfoResume
        let yWeekInfoResume_ProgressViewSection: CGFloat = 0
        let widthWeekInfoResume_ProgressViewSection: CGFloat = widthWeekInfoResume/2
        let heightWeekInfoResume_ProgressViewSection: CGFloat = heightWeekInfoResume
        
        createProgressViewSection(x:xWeekInfoResume_ProgressViewSection, y:yWeekInfoResume_ProgressViewSection, width:widthWeekInfoResume_ProgressViewSection, height:heightWeekInfoResume_ProgressViewSection)
        
        
        
        // MARK: Create WeekInfoResume : Resume view
        
        let xWeekInfoResume_ResumeViewSection: CGFloat = weekInfoResume.frame.origin.x + widthWeekInfoResume/2
        let yWeekInfoResume_ResumeViewSection: CGFloat = 0
        let widthWeekInfoResume_ResumeViewSection: CGFloat = widthWeekInfoResume/2
        let heightWeekInfoResume_ResumeViewSection: CGFloat = heightWeekInfoResume
        
        createResumeViewSection(x:xWeekInfoResume_ResumeViewSection, y:yWeekInfoResume_ResumeViewSection, width:widthWeekInfoResume_ResumeViewSection, height:heightWeekInfoResume_ResumeViewSection)
        
        weekInfoResume.backgroundColor = UIColor.whiteColor()
        
        self.scrollView.addSubview(weekInfoResume)
    }
    
    func createProgressViewSection(x xProgressViewSection: CGFloat, y yProgressViewSection:CGFloat, width widthProgressViewSection:CGFloat, height heightProgressViewSection:CGFloat){
    
        // 3.1: Progress bar
        progressView = UIView(frame: CGRectMake(xProgressViewSection, yProgressViewSection, widthProgressViewSection, heightProgressViewSection))
        
        // maxLengthProgressView: Calculate max length of any progress bar view;
        
        var maxLengthProgressView = calculateMaxLengthProgressView()
        
        var longerWorkoutOfTheWeekInHours : Float = 0
        var (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(1, weekOfYear: weekIndex)
        var (swimHourCounterMonday,cycHourCounterMonday,runHourCounterMonday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfMondayInHours : Float = swimHourCounterMonday + cycHourCounterMonday + runHourCounterMonday
        if workoutOfMondayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfMondayInHours
        }
        
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(2, weekOfYear: weekIndex)
        var (swimHourCounterTuesday,cycHourCounterTuesday,runHourCounterTuesday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfTuesdayInHours : Float = swimHourCounterTuesday + cycHourCounterTuesday + runHourCounterTuesday
        if workoutOfTuesdayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfTuesdayInHours
        }
        
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(3, weekOfYear: weekIndex)
        var (swimHourCounterWednesday,cycHourCounterWednesday,runHourCounterWednesday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfWednesdayInHours : Float = swimHourCounterWednesday + cycHourCounterWednesday + runHourCounterWednesday
        if workoutOfWednesdayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfWednesdayInHours
        }
        
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(4, weekOfYear: weekIndex)
        var (swimHourCounterThursday,cycHourCounterThursday,runHourCounterThursday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfThursdayInHours : Float = swimHourCounterThursday + cycHourCounterThursday + runHourCounterThursday
        if workoutOfThursdayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfThursdayInHours
        }
        
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(5, weekOfYear: weekIndex)
        var (swimHourCounterFriday,cycHourCounterFriday,runHourCounterFriday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfFridayInHours : Float = swimHourCounterFriday + cycHourCounterFriday + runHourCounterFriday
        if workoutOfFridayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfFridayInHours
        }
        
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(6, weekOfYear: weekIndex)
        var (swimHourCounterSaturday,cycHourCounterSaturday,runHourCounterSaturday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfSaturdayInHours : Float = swimHourCounterSaturday + cycHourCounterSaturday + runHourCounterSaturday
        if workoutOfSaturdayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfSaturdayInHours
        }
        
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(7, weekOfYear: weekIndex)
        var (swimHourCounterSunday,cycHourCounterSunday,runHourCounterSunday) = (swimHourCounter,cycHourCounter,runHourCounter)
        var workoutOfSundayInHours : Float = swimHourCounterSunday + cycHourCounterSunday + runHourCounterSunday
        if workoutOfSundayInHours > longerWorkoutOfTheWeekInHours {
            longerWorkoutOfTheWeekInHours = workoutOfSundayInHours
        }
        
        spaceBetweenProgressViews = heightProgressViewSection / 7
        var firstProgresViewYPosition = spaceBetweenProgressViews / 2
        
        yMondayProgressView = firstProgresViewYPosition
        yTuesdayProgressView = yMondayProgressView + spaceBetweenProgressViews
        yWednesdayProgressView = yTuesdayProgressView + spaceBetweenProgressViews
        yThursdayProgressView = yWednesdayProgressView + spaceBetweenProgressViews
        yFridayProgressView = yThursdayProgressView + spaceBetweenProgressViews
        ySaturdayProgressView = yFridayProgressView + spaceBetweenProgressViews
        ySundayProgressView = ySaturdayProgressView + spaceBetweenProgressViews
        
        yMondayLabel = 0
        yTuesdayLabel = yMondayLabel + spaceBetweenProgressViews
        yWednesdayLabel = yTuesdayLabel + spaceBetweenProgressViews
        yThursdayLabel = yWednesdayLabel + spaceBetweenProgressViews
        yFridayLabel = yThursdayLabel + spaceBetweenProgressViews
        ySaturdayLabel = yFridayLabel + spaceBetweenProgressViews
        ySundayLabel = ySaturdayLabel + spaceBetweenProgressViews
        
        // 3.1.1: Monday label and progress
        
        // Label
        var frameLbl = CGRect(x: 0, y: yMondayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        var textLbl = LocalizedString_Day_M
        var textColorLbl = defaultTextColorProgressView
        var textSizeLbl = defaultTextSizeLbl
        var textBackgroundColorLbl = defaultColorBackgroundProgressView
        
        var progressLblMonday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        
        
        var rectMondayProgress = CGRect(x: xProgressViews, y: yMondayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewMonday = ProgressView(frame: rectMondayProgress)
        progressViewMonday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterMonday, cycTotalHoursWorkout: cycHourCounterMonday, runTotalHoursWorkout: runHourCounterMonday)
        progressViewMonday.animateProgressView()
        
        // 3.1.2: Tuesday label and progress
        
        // Label
        frameLbl = CGRect(x: 0, y: yTuesdayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        textLbl = LocalizedString_Day_T
        
        var progressLblTuesday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(2, weekOfYear: weekIndex)
        
        var rectTuesdayProgress = CGRect(x: xProgressViews, y: yTuesdayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewTuesday = ProgressView(frame: rectTuesdayProgress)
        progressViewTuesday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterTuesday, cycTotalHoursWorkout: cycHourCounterTuesday, runTotalHoursWorkout: cycHourCounterTuesday)
        progressViewTuesday.animateProgressView()
        
        // 3.1.3: Wednesday label and progress
        
        // Label
        frameLbl = CGRect(x: 0, y: yWednesdayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        textLbl = LocalizedString_Day_W
        
        var progressLblWednesday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(3, weekOfYear: weekIndex)
        
        var rectWednesdayProgress = CGRect(x: xProgressViews, y: yWednesdayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewWednesday = ProgressView(frame: rectWednesdayProgress)
        progressViewWednesday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterWednesday, cycTotalHoursWorkout: cycHourCounterWednesday, runTotalHoursWorkout: runHourCounterWednesday)
        progressViewWednesday.animateProgressView()
        
        // 3.1.2: Thursday label and progress
        
        // Label
        frameLbl = CGRect(x: 0, y: yThursdayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        textLbl = LocalizedString_Day_TH
        
        var progressLblThursday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(4, weekOfYear: weekIndex)
        
        var rectThursdayProgress = CGRect(x: xProgressViews, y: yThursdayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewThursday = ProgressView(frame: rectThursdayProgress)
        progressViewThursday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterThursday, cycTotalHoursWorkout: cycHourCounterThursday, runTotalHoursWorkout: runHourCounterThursday)
        progressViewThursday.animateProgressView()
        
        // 3.1.2: Friday label and progress
        
        // Label
        frameLbl = CGRect(x: 0, y: yFridayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        textLbl = LocalizedString_Day_F
        
        var progressLblFriday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(5, weekOfYear: weekIndex)
        
        var rectFridayProgress = CGRect(x: xProgressViews, y: yFridayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewFriday = ProgressView(frame: rectFridayProgress)
        progressViewFriday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterFriday, cycTotalHoursWorkout: cycHourCounterFriday, runTotalHoursWorkout: runHourCounterFriday)
        progressViewFriday.animateProgressView()
        
        // 3.1.2: Saturday label and progress
        
        // Label
        frameLbl = CGRect(x: 0, y: ySaturdayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        textLbl = LocalizedString_Day_Sa
        
        var progressLblSaturday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(6, weekOfYear: weekIndex)
        
        var rectSaturdayProgress = CGRect(x: xProgressViews, y: ySaturdayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewSaturday = ProgressView(frame: rectSaturdayProgress)
        progressViewSaturday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterSaturday, cycTotalHoursWorkout: cycHourCounterSaturday, runTotalHoursWorkout: runHourCounterSaturday)
        progressViewSaturday.animateProgressView()
        
        // 3.1.2: Sunday label and progress
        
        // Label
        frameLbl = CGRect(x: 0, y: ySundayLabel, width: xProgressViews, height: spaceBetweenProgressViews)
        textLbl = LocalizedString_Day_S
        
        var progressLblSunday = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        
        // Progress
        (swimHourCounter,cycHourCounter,runHourCounter) = currentUser.totalNumberWorkoutByWeekDayAndDay(7, weekOfYear: weekIndex)
        
        var rectSundayProgress = CGRect(x: xProgressViews, y: ySundayProgressView, width: maxLengthProgressView, height: heightProgressViews)
        progressViewSunday = ProgressView(frame: rectSundayProgress)
        progressViewSunday.createProgressLayer(maxLengthProgressView, longerWorkoutOfTheWeekInHours: longerWorkoutOfTheWeekInHours, swimTotalHoursWorkout: swimHourCounterSunday, cycTotalHoursWorkout: cycHourCounterSunday, runTotalHoursWorkout: runHourCounterSunday)
        progressViewSunday.animateProgressView()
        
        
        // Add days progress view
        // Labels
        progressView.addSubview(progressLblMonday)
        progressView.addSubview(progressLblTuesday)
        progressView.addSubview(progressLblWednesday)
        progressView.addSubview(progressLblThursday)
        progressView.addSubview(progressLblFriday)
        progressView.addSubview(progressLblSaturday)
        progressView.addSubview(progressLblSunday)
        
        // Progress Views
        progressView.addSubview(progressViewMonday)
        progressView.addSubview(progressViewTuesday)
        progressView.addSubview(progressViewWednesday)
        progressView.addSubview(progressViewThursday)
        progressView.addSubview(progressViewFriday)
        progressView.addSubview(progressViewSaturday)
        progressView.addSubview(progressViewSunday)
        
        // Add progress view to weekInfoResume
        //progressView.backgroundColor = UIColor.redColor()
        weekInfoResume.addSubview(progressView)
        
    }
    
    func createResumeViewSection(x xResumeViewSection: CGFloat, y yResumeViewSection:CGFloat, width widthResumeViewSection:CGFloat, height heightResumeViewSection:CGFloat){
        let resumeView = UIView(frame: CGRectMake(xResumeViewSection, yResumeViewSection, widthResumeViewSection, heightResumeViewSection))
        let resumeViewContainer = UIView(frame: CGRectMake(5, 5, resumeView.frame.width-10, resumeView.frame.height-10))
        
        // Generate total row height (we'll add more row like GYM in the future)
        let heightRow = heightResumeViewSection / (CGFloat(defaultNumberOfRowInResume) + 1 )
        
        // Header Row: Total
        let resumeViewContainer_total = UIView(frame: CGRectMake(0, 0, resumeViewContainer.frame.width, heightRow))
        var widthItem = resumeViewContainer_total.frame.size.width / 3.0
        
        // Pos: 1
        var frameLbl = CGRectMake(0, 0, widthItem, heightRow)
        var textLbl = LocalizedString_Total
        var textColorLbl = defaultTextColorResume
        var textSizeLbl = defaultTextSizeResume
        var textBackgroundColorLbl = UIColor.clearColor()
        
        let lblTotal = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left)
        resumeViewContainer_total.addSubview(lblTotal)
        
        // Pos: 2
        frameLbl = CGRectMake(widthItem, 0, widthItem, heightRow)
        textLbl = "6h29min"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        let lblTotalMin = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        resumeViewContainer_total.addSubview(lblTotalMin)
        
        // Pos: 3
        frameLbl = CGRectMake(widthItem*2, 0, widthItem, heightRow)
        textLbl = "178km"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        let lblTotalKm = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        resumeViewContainer_total.addSubview(lblTotalKm)
        
        resumeViewContainer_total.backgroundColor = defaultColorBackgroundTextLblResume
        resumeViewContainer.addSubview(resumeViewContainer_total)
        
        // Swimming Row
        
        var resumeViewContainer_sport = UIView(frame: CGRectMake(0, heightRow, resumeViewContainer.frame.width, heightRow))
        var resumeViewContainer_sport_header = UIView(frame: CGRectMake(0, 0, resumeViewContainer_sport.frame.width, heightRow/2))
        var resumeViewContainer_sport_body = UIView(frame: CGRectMake(0, heightRow/2, resumeViewContainer_sport.frame.width, heightRow/2))
        
        var (timeResume, kmResume, velResume) = currentUser.resumeWorkoutBySportWeekDayAndDay(SportType.SWIMMING , weekOfYear: weekIndex)
        
        // Swimming Row: Header
        frameLbl = CGRectMake(5, 0, resumeViewContainer_sport_header.frame.size.width, resumeViewContainer_sport_header.frame.size.height)
        textLbl = LocalizedString_Sport_Swim
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        var lblHeaderSection = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left)
        resumeViewContainer_sport_header.addSubview(lblHeaderSection)
        
        resumeViewContainer_sport.addSubview(resumeViewContainer_sport_header)
        
        // Swimming Row: Body
        widthItem = resumeViewContainer_sport.frame.size.width / 3.0
        var heightItem = resumeViewContainer_sport_body.frame.size.height/2
        
        // Pos 1
        frameLbl = CGRectMake(0, 0, widthItem, heightItem)
        textLbl = timeResume
        
        var lblSportMin = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportMin)
        
        // Pos 2
        frameLbl = CGRectMake(widthItem, 0, widthItem, heightItem)
        textLbl = kmResume
        
        var lblSportKm = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportKm)
        
        // Pos 3
        frameLbl = CGRectMake(widthItem*2, 0, widthItem, heightItem)
        textLbl = velResume
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        var lblSportVelocity = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportVelocity)
        
        resumeViewContainer_sport.addSubview(resumeViewContainer_sport_body)
        resumeViewContainer.addSubview(resumeViewContainer_sport)
        
        
        // Cycling Row
        
        resumeViewContainer_sport = UIView(frame: CGRectMake(0, heightRow*2, resumeViewContainer.frame.width, heightRow))
        resumeViewContainer_sport_header = UIView(frame: CGRectMake(0, 0, resumeViewContainer_sport.frame.width, heightRow/2))
        resumeViewContainer_sport_body = UIView(frame: CGRectMake(0, heightRow/2, resumeViewContainer_sport.frame.width, heightRow/2))
        
        (timeResume, kmResume, velResume) = currentUser.resumeWorkoutBySportWeekDayAndDay(SportType.CYCLING , weekOfYear: weekIndex)
        
        // Cycling Row: Header
        frameLbl = CGRectMake(5, 0, resumeViewContainer_sport_header.frame.size.width, resumeViewContainer_sport_header.frame.size.height)
        textLbl = LocalizedString_Sport_Cyc
        
        lblHeaderSection = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left)
        resumeViewContainer_sport_header.addSubview(lblHeaderSection)
        
        resumeViewContainer_sport.addSubview(resumeViewContainer_sport_header)
        
        // Cycling Row: Body
        widthItem = resumeViewContainer_sport.frame.size.width / 3.0
        heightItem = resumeViewContainer_sport_body.frame.size.height/2
        
        // Pos 1
        frameLbl = CGRectMake(0, 0, widthItem, heightItem)
        textLbl = timeResume
        
        lblSportMin = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportMin)
        
        // Pos 2
        frameLbl = CGRectMake(widthItem, 0, widthItem, heightItem)
        textLbl = kmResume
        
        lblSportKm = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportKm)
        
        // Pos 3
        frameLbl = CGRectMake(widthItem*2, 0, widthItem, heightItem)
        textLbl = velResume
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        lblSportVelocity = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportVelocity)
        
        resumeViewContainer_sport.addSubview(resumeViewContainer_sport_body)
        resumeViewContainer.addSubview(resumeViewContainer_sport)
        
        
        // Running Row
        
        resumeViewContainer_sport = UIView(frame: CGRectMake(0, heightRow*3, resumeViewContainer.frame.width, heightRow))
        resumeViewContainer_sport_header = UIView(frame: CGRectMake(0, 0, resumeViewContainer_sport.frame.width, heightRow/2))
        resumeViewContainer_sport_body = UIView(frame: CGRectMake(0, heightRow/2, resumeViewContainer_sport.frame.width, heightRow/2))
        
        (timeResume, kmResume, velResume) = currentUser.resumeWorkoutBySportWeekDayAndDay(SportType.RUNNING , weekOfYear: weekIndex)
        
        // Running Row: Header
        frameLbl = CGRectMake(5, 0, resumeViewContainer_sport_header.frame.size.width, resumeViewContainer_sport_header.frame.size.height)
        textLbl = LocalizedString_Sport_Run
        
        lblHeaderSection = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left)
        resumeViewContainer_sport_header.addSubview(lblHeaderSection)
        
        resumeViewContainer_sport.addSubview(resumeViewContainer_sport_header)
        
        // Running Row: Body
        widthItem = resumeViewContainer_sport.frame.size.width / 3.0
        heightItem = resumeViewContainer_sport_body.frame.size.height/2
        
        // Pos 1
        frameLbl = CGRectMake(0, 0, widthItem, heightItem)
        textLbl = timeResume
        
        lblSportMin = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportMin)
        
        // Pos 2
        frameLbl = CGRectMake(widthItem, 0, widthItem, heightItem)
        textLbl = kmResume
        
        lblSportKm = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportKm)
        
        // Pos 3
        frameLbl = CGRectMake(widthItem*2, 0, widthItem, heightItem)
        textLbl = velResume
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        lblSportVelocity = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        resumeViewContainer_sport_body.addSubview(lblSportVelocity)
        
        resumeViewContainer_sport.addSubview(resumeViewContainer_sport_body)
        resumeViewContainer.addSubview(resumeViewContainer_sport)
        
        // Add all resume rows
        //resumeViewContainer.backgroundColor = UIColor.whiteColor()
        resumeView.addSubview(resumeViewContainer)
        resumeView.backgroundColor = UIColor.whiteColor()
        
        resumeViewContainer.animate()
        weekInfoResume.addSubview(resumeView)
    }
    
    func createMonthlyYearlyTotalTable(x xWeekTableDataResume: CGFloat, y yWeekTableDataResume: CGFloat, width widthWeekTableDataResume: CGFloat, height heightWeekTableDataResume: CGFloat){
        
        weekTableDataResume = UIView(frame: CGRectMake(xWeekTableDataResume, yWeekTableDataResume, widthWeekTableDataResume, heightWeekTableDataResume))
        
        let widthItemWeekTableDataResume = widthWeekTableDataResume / 4
        let heightItemWeekTableDataResume = heightWeekTableDataResume / 4
        
        // ROW 0
        var horizontalViewContainer = UIView(frame: CGRectMake(0, 0, widthWeekTableDataResume, heightItemWeekTableDataResume))
        
        // Pos 1
        var frameLbl = CGRectMake(widthItemWeekTableDataResume, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        var textLbl = "Mes"
        var textColorLbl = defaultTextColorResume
        var textSizeLbl = defaultTextSizeResume
        let textBackgroundColorLbl = UIColor.clearColor()
        
        var itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 2
        frameLbl = CGRectMake(widthItemWeekTableDataResume*2, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "2015"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 3
        frameLbl = CGRectMake(widthItemWeekTableDataResume*3, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "Total"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl)
        horizontalViewContainer.addSubview(itemTable)
        
        //Add the bar shadow (set to true or false with the horizontalViewContainerShadow var)
        horizontalViewContainer.addShadow()
        
        weekTableDataResume.addSubview(horizontalViewContainer)
        
        // ROW 1
        horizontalViewContainer = UIView(frame: CGRectMake(0, heightItemWeekTableDataResume, widthWeekTableDataResume, heightItemWeekTableDataResume))
        
        // Pos 0
        frameLbl = CGRectMake(0, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "Entrenamientos"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left, bold: true)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 1
        frameLbl = CGRectMake(widthItemWeekTableDataResume, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "5"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 2
        frameLbl = CGRectMake(widthItemWeekTableDataResume*2, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "30"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 3
        frameLbl = CGRectMake(widthItemWeekTableDataResume*3, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "159"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        //Add the bar shadow (set to true or false with the horizontalViewContainerShadow var)
        horizontalViewContainer.addShadow()
        
        weekTableDataResume.addSubview(horizontalViewContainer)
        
        
        // ROW 2
        horizontalViewContainer = UIView(frame: CGRectMake(0, heightItemWeekTableDataResume*2, widthWeekTableDataResume, heightItemWeekTableDataResume))
        
        // Pos 0
        frameLbl = CGRectMake(0, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "Tiempo"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left, bold: true)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 1
        frameLbl = CGRectMake(widthItemWeekTableDataResume, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "4h35m"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 2
        frameLbl = CGRectMake(widthItemWeekTableDataResume*2, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "24h12m"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 3
        frameLbl = CGRectMake(widthItemWeekTableDataResume*3, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "132h16m"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        //Add the bar shadow (set to true or false with the horizontalViewContainerShadow var)
        horizontalViewContainer.addShadow()
        
        weekTableDataResume.addSubview(horizontalViewContainer)
        
        
        // ROW 3
        horizontalViewContainer = UIView(frame: CGRectMake(0, heightItemWeekTableDataResume*3, widthWeekTableDataResume, heightItemWeekTableDataResume))
        
        // Pos 0
        frameLbl = CGRectMake(0, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "Distancia"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Left, bold: true)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 1
        frameLbl = CGRectMake(widthItemWeekTableDataResume, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "210km"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 2
        frameLbl = CGRectMake(widthItemWeekTableDataResume*2, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "1.020km"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        // Pos 3
        frameLbl = CGRectMake(widthItemWeekTableDataResume*3, 0, widthItemWeekTableDataResume, heightItemWeekTableDataResume)
        textLbl = "5.247km"
        textColorLbl = defaultTextColorResume
        textSizeLbl = defaultTextSizeResume
        
        itemTable = UILabel(frame: frameLbl, textLabel: textLbl, textColor: textColorLbl, textSize: textSizeLbl, textBackgroundColor: textBackgroundColorLbl, textAlignment: NSTextAlignment.Center, bold: false)
        horizontalViewContainer.addSubview(itemTable)
        
        //Add the bar shadow (set to true or false with the horizontalViewContainerShadow var)
        horizontalViewContainer.addShadow()
        
        weekTableDataResume.addSubview(horizontalViewContainer)
        weekTableDataResume.backgroundColor = UIColor.whiteColor()
        weekTableDataResume.animate()
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
