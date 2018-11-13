//
//  ProgressView.swift
//  kyperion
//
//  Copyright © 2015 Kyperion SL. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    private var animated : Bool = false
    private var lineWidth: CGFloat = 14
    
    private let progressLayerRun: CAShapeLayer = CAShapeLayer()
    private let progressLayerCyc: CAShapeLayer = CAShapeLayer()
    private let progressLayerSwim: CAShapeLayer = CAShapeLayer()
    private let progressLayerGym: CAShapeLayer = CAShapeLayer()
    
    private var progressLabelRun: UILabel
    private var progressLabelCyc: UILabel
    private var progressLabelSwim: UILabel
    private var progressLabelGym: UILabel
    
    private var colors : [UIColor] = []
    private var percent : [Int] = []
    
    required init(coder aDecoder: NSCoder) {
        progressLabelRun = UILabel()
        progressLabelCyc = UILabel()
        progressLabelSwim = UILabel()
        progressLabelGym = UILabel()
        super.init(coder: aDecoder)
        //createProgressLayer()
    }
    
    override init(frame: CGRect) {
        progressLabelRun = UILabel()
        progressLabelCyc = UILabel()
        progressLabelSwim = UILabel()
        progressLabelGym = UILabel()
        super.init(frame: frame)
        //createProgressLayer()
    }
    
    func createProgressLayer(maxLengthProgressView : CGFloat, longerWorkoutOfTheWeekInHours: Float, swimTotalHoursWorkout: Float, cycTotalHoursWorkout: Float, runTotalHoursWorkout: Float) {
        
        // 1. Total number of hours of the day workout
        let totalNumberHoursWorkout = swimTotalHoursWorkout + cycTotalHoursWorkout + runTotalHoursWorkout
        
        if totalNumberHoursWorkout > longerWorkoutOfTheWeekInHours {
            print("Number of totalNumberHoursWorkout couldn't be bigger than longerWorkoutOfTheWeekInHours")
        }
        
        // 2. Percent of time related to the 'longerWorkoutOfTheWeekInHours'
        let percentTimeRelatedToTongerWorkoutOfTheWeekInHours = (totalNumberHoursWorkout * 100)/longerWorkoutOfTheWeekInHours
        
        // 3. Total of the progress bar view to be filled related
        let totalWidthProgressView = (maxLengthProgressView * CGFloat(percentTimeRelatedToTongerWorkoutOfTheWeekInHours)) / 100
        
        // 4. Width of each hour for this day
        var widthTimeHour : CGFloat = 0
        if (totalWidthProgressView == 0 || totalNumberHoursWorkout == 0){
            widthTimeHour = 0
        }else{
            widthTimeHour = CGFloat(totalWidthProgressView) / CGFloat(totalNumberHoursWorkout);
        }
        
        // 5. Calculate partial points for each sport
        
        // 5.1 Swim
        let swimInitialPoint : CGFloat = 0
        let swimWidth : CGFloat = CGFloat(swimTotalHoursWorkout) * widthTimeHour
        let swimEndPoint : CGFloat = swimInitialPoint + swimWidth
        let swimInitialMoveToPoint = CGPointMake(swimInitialPoint, 0)
        let swimLineToPoint = CGPointMake(swimEndPoint, 0)
        
        // 5.1 Cyc
        let cycInitialPoint : CGFloat = swimEndPoint
        let cycWidth : CGFloat = CGFloat(cycTotalHoursWorkout) * widthTimeHour
        let cycEndPoint : CGFloat = cycInitialPoint + cycWidth
        let cycInitialMoveToPoint = CGPointMake(cycInitialPoint, 0)
        let cycLineToPoint = CGPointMake(cycEndPoint, 0)
        
        // 5.1 Run
        let runInitialPoint : CGFloat = cycEndPoint
        let runWidth : CGFloat = CGFloat(runTotalHoursWorkout) * widthTimeHour
        let runEndPoint : CGFloat = runInitialPoint + runWidth
        let runInitialMoveToPoint = CGPointMake(runInitialPoint, 0)
        let runLineToPoint = CGPointMake(runEndPoint, 0)
        
        // 6. Generate progress view for each sport
        
        // 6.1 Swimming
        let gradientMaskLayer1 = gradientMask(UIColor.swimmingColor().CGColor)
        let swimBezierPath = UIBezierPath()
        swimBezierPath.moveToPoint(swimInitialMoveToPoint)
        swimBezierPath.addLineToPoint(swimLineToPoint)
        UIColor.whiteColor().setStroke()
        swimBezierPath.lineWidth = lineWidth
        swimBezierPath.stroke()
        
        progressLayerSwim.path = swimBezierPath.CGPath
        progressLayerSwim.backgroundColor = UIColor.whiteColor().CGColor
        progressLayerSwim.fillColor = nil
        progressLayerSwim.strokeColor = UIColor.blackColor().CGColor
        progressLayerSwim.lineWidth = CGFloat(lineWidth)
        progressLayerSwim.strokeStart = 0.0
        progressLayerSwim.strokeEnd = 0.0
        
        gradientMaskLayer1.mask = progressLayerSwim
        layer.addSublayer(gradientMaskLayer1)
        
        
        // 6.2 Cycling
        let gradientMaskLayer2 = gradientMask(UIColor.cyclingColor().CGColor)
        let cycBezierPath = UIBezierPath()
        cycBezierPath.moveToPoint(cycInitialMoveToPoint)
        cycBezierPath.addLineToPoint(cycLineToPoint)
        UIColor.blueColor().setStroke()
        cycBezierPath.lineWidth = lineWidth
        cycBezierPath.stroke()
        
        progressLayerCyc.path = cycBezierPath.CGPath
        progressLayerCyc.backgroundColor = UIColor.whiteColor().CGColor
        progressLayerCyc.fillColor = nil
        progressLayerCyc.strokeColor = UIColor.blackColor().CGColor
        progressLayerCyc.lineWidth = CGFloat(lineWidth)
        progressLayerCyc.strokeStart = 0.0
        progressLayerCyc.strokeEnd = 0.0
        
        gradientMaskLayer2.mask = progressLayerCyc
        layer.addSublayer(gradientMaskLayer2)
        
        
        // 6.3 Swimming
        let gradientMaskLayer3 = gradientMask(UIColor.runningColor().CGColor)
        let runBezierPath = UIBezierPath()
        runBezierPath.moveToPoint(runInitialMoveToPoint)
        runBezierPath.addLineToPoint(runLineToPoint)
        UIColor.blueColor().setStroke()
        runBezierPath.lineWidth = lineWidth
        runBezierPath.stroke()
        
        progressLayerRun.path = runBezierPath.CGPath
        progressLayerRun.backgroundColor = UIColor.whiteColor().CGColor
        progressLayerRun.fillColor = nil
        progressLayerRun.strokeColor = UIColor.blackColor().CGColor
        progressLayerRun.lineWidth = CGFloat(lineWidth)
        progressLayerRun.strokeStart = 0.0
        progressLayerRun.strokeEnd = 0.0
        
        gradientMaskLayer3.mask = progressLayerRun
        layer.addSublayer(gradientMaskLayer3)
        
    }
    
    private func gradientMask(color : CGColor) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = color
        let colorBottom: AnyObject = UIColor.whiteColor().CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    private func gradientMask1() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds

        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = UIColor.mainAppColor().CGColor
        let colorBottom: AnyObject = UIColor.whiteColor().CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        /*
        var arrayOfColors: [AnyObject] = [UIColor.blueColor(),UIColor.greenColor(),UIColor.yellowColor()]
        if self.colors.count > 0 {
            arrayOfColors = self.colors
        }
        */
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    private func gradientMask2() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = UIColor.blueColor().CGColor
        let colorBottom: AnyObject = UIColor.whiteColor().CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        /*
        var arrayOfColors: [AnyObject] = [UIColor.blueColor(),UIColor.greenColor(),UIColor.yellowColor()]
        if self.colors.count > 0 {
        arrayOfColors = self.colors
        }
        */
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    private func gradientMask3() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.locations = [0.0, 1.0]
        
        let colorTop: AnyObject = UIColor.greenColor().CGColor
        let colorBottom: AnyObject = UIColor.whiteColor().CGColor
        let arrayOfColors: [AnyObject] = [colorTop, colorBottom]
        /*
        var arrayOfColors: [AnyObject] = [UIColor.blueColor(),UIColor.greenColor(),UIColor.yellowColor()]
        if self.colors.count > 0 {
        arrayOfColors = self.colors
        }
        */
        gradientLayer.colors = arrayOfColors
        
        return gradientLayer
    }
    
    private func hideProgressView(layer: CAShapeLayer) {
        layer.strokeColor = UIColor.whiteColor().CGColor
        layer.strokeEnd = 0.0
        layer.removeAllAnimations()
    }
    
    private func animateProgressView(layer: CAShapeLayer) {
        layer.strokeEnd = 0.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 0.5
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        layer.addAnimation(animation, forKey: "strokeEnd")
    }
    
    func animateProgressView() {
        
        animateProgressView(progressLayerSwim)
        animateProgressView(progressLayerCyc)
        animateProgressView(progressLayerRun)
        
        
        /*
        progressLayerSwim.strokeEnd = 0.0
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue = CGFloat(1.0)
        animation.duration = 1.0
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.additive = true
        animation.fillMode = kCAFillModeForwards
        layer.addAnimation(animation, forKey: "strokeEnd")
        */
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //print("Done")
    }
}
