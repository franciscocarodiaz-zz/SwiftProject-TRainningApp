//
//  MapActivityViewController.swift
//  kyperion
//
//  Created by Francisco Caro Diaz on 10/09/15.
//  Copyright (c) 2015 kyperion. All rights reserved.
//

import UIKit
import MapKit

class MapActivityViewController: UIViewController,activityManagerDelegate,UITextFieldDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let regionRadius: CLLocationDistance = 500
    var tableData = NSArray()
    
    var mapManager = MapManager()
    var activityApiManager: ActivityManager?
    
    var locationManager: CLLocationManager!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func coordinateRegionForCoordinates(coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        var rect: MKMapRect = MKMapRectNull
        for coord in coords {
            let point: MKMapPoint = MKMapPointForCoordinate(coord)
            rect = MKMapRectUnion(rect, MKMapRectMake(point.x, point.y, 0, 0))
        }
        
        
        return MKCoordinateRegionForMapRect(rect)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 5.0, regionRadius * 5.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        let address = "1 Infinite Loop, CA, USA"
        
        self.mapView?.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsZero
        
        self.activityApiManager = ActivityManager()
        self.activityApiManager?.delegate = self
        
        paintRoute()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if (locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization"))) {
            
            locationManager.requestWhenInUseAuthorization() // add in plist NSLocationWhenInUseUsageDescription
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var hasAuthorised = false
            var locationStatus:NSString = ""
            var verboseKey = status
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access"
            case CLAuthorizationStatus.Denied:
                locationStatus = "Denied access"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Not determined"
            default:
                locationStatus = "Allowed access"
                hasAuthorised = true
            }
            
    }
    
    func paintRoute(){
        
        if currentActivity.hasLaps {
            
            // set initial location in Honolulu
            
            
            var arrayLaps = [MKPointAnnotation]()
            var counter = currentActivity.laps.count
            var index = 1
            var coords = [CLLocationCoordinate2D]()
            
            coords.append(currentActivity.firstLap.startLocation.location.coordinate)
            
            for item in currentActivity.laps {
                
                var pointOfOrigin = MKPointAnnotation()
                pointOfOrigin.coordinate = item.startLocation.location.coordinate
                pointOfOrigin.title = item.startLocation.locality
                pointOfOrigin.subtitle = item.startLocation.country
                
                var pointOfDst = MKPointAnnotation()
                pointOfDst.coordinate = item.endLocation.location.coordinate
                pointOfDst.title = item.endLocation.locality
                pointOfDst.subtitle = item.endLocation.country
                coords.append(item.endLocation.location.coordinate)
                
                arrayLaps.append(pointOfOrigin)
                arrayLaps.append(pointOfDst)
            }
            
            self.mapView!.addAnnotations(arrayLaps)
            
            mapView.setRegion(coordinateRegionForCoordinates(coords), animated: true)
            var lat = coords[coords.count/2].latitude
            var lng = coords[coords.count/2].longitude
            var location = CLLocation(latitude: lat, longitude: lng)
            //self.centerMapOnLocation(location)
            
            self.polyline = MKPolyline(coordinates: &coords, count: coords.count)
            
            self.mapView.addOverlay(self.polyline, level: MKOverlayLevel.AboveRoads)
          
        }else{
            self.activityApiManager?.getLaps()
        }
        
    }
    
    func goToAnnotation(annotation: MKPointAnnotation)
    {
        let span = MKCoordinateSpanMake(0.0002, 0.0002)
        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
        self.mapView!.setRegion(region, animated: true)
    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView!) {
        
    }
    
    var polyline: MKPolyline = MKPolyline()
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            println("done")
            return polylineRenderer
        }
        
        return nil
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
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
        
        if let web = self.mapView {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.removeAllPlacemarkFromMap(shouldRemoveUserLocation: true)
                web.removeOverlay(self.polyline)
                
                var arrayLaps = [MKPointAnnotation]()
                var counter = currentActivity.laps.count
                var index = 1
                var coords = [CLLocationCoordinate2D]()
                
                coords.append(lap.startLocation.location.coordinate)
                coords.append(lap.endLocation.location.coordinate)
                
                    
                    var pointOfOrigin = MKPointAnnotation()
                    pointOfOrigin.coordinate = lap.startLocation.location.coordinate
                    pointOfOrigin.title = lap.startLocation.locality
                    pointOfOrigin.subtitle = lap.startLocation.country
                
                    var pointOfDst = MKPointAnnotation()
                    pointOfDst.coordinate = lap.endLocation.location.coordinate
                    pointOfDst.title = lap.endLocation.locality
                    pointOfDst.subtitle = lap.endLocation.country
                    coords.append(lap.endLocation.location.coordinate)
                    
                    arrayLaps.append(pointOfOrigin)
                    arrayLaps.append(pointOfDst)
                
                
                web.addAnnotations(arrayLaps)
                
                
                web.setRegion(self.coordinateRegionForCoordinates(coords), animated: true)
                var lat = coords[coords.count/2].latitude
                var lng = coords[coords.count/2].longitude
                var location = CLLocation(latitude: lat, longitude: lng)
                self.centerMapOnLocation(location)
                
                self.polyline = MKPolyline(coordinates: &coords, count: coords.count)
                
                self.mapView.addOverlay(self.polyline, level: MKOverlayLevel.AboveRoads)
            }
            
        }
        
        
    }
    
    
    func removeAllPlacemarkFromMap(#shouldRemoveUserLocation:Bool){
        
        if let mapView = self.mapView {
            for annotation in mapView.annotations{
                if shouldRemoveUserLocation {
                    if annotation as? MKUserLocation !=  mapView.userLocation {
                        mapView.removeAnnotation(annotation as! MKAnnotation)
                    }
                }
                
                
            }
            
        }
        
        
    }
    
    // MARK: - Activity api manager delegate
    
    func ActivityManagerRespondLapsReceived() {
        print("ActivityManagerRespondLapsReceived")
        paintRoute()
        self.tableView.reloadData()
    }
    func ActivityManagerRespondFailure(msgError: String) {
        print("ActivityManagerRespondFailure")
    }
    
    // MARK: - location manager to authorize user location for Maps app
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView!.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}
