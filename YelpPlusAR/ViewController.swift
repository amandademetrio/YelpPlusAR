//
//  ViewController.swift
//  YelpPlusAR
//
//  Created by Amanda Demetrio on 10/10/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import ARKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var listOfRestaurants: NSArray = [];
    
    @IBOutlet weak var mainMap: MKMapView!
    
    @IBOutlet weak var arSwitch: UISwitch!
    
    @IBAction func arSwitchChanged(_ sender: UISwitch) {
        performSegue(withIdentifier: "switchToAR", sender: nil)
        self.arSwitch.isOn = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting Map
        mainMap.userTrackingMode = .follow
        //Setting up location manager
        self.locationManager.requestAlwaysAuthorization()
        let userLatitute = self.locationManager.location?.coordinate.latitude
        let userLongiture = self.locationManager.location?.coordinate.longitude

        YelpPlusARModel.getAllFood(completionHandler: { (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    self.listOfRestaurants = jsonResult["businesses"] as! NSArray
                    for restaurant in self.listOfRestaurants {
                        let restDict = restaurant as! NSDictionary
                        //getting coordinates for pins
                        let restCoord = restDict["coordinates"]! as! NSDictionary
                        let restLat = restCoord["latitude"]! as! Double
                        let restLong = restCoord["longitude"]! as! Double
                        //getting name
                        let restName = restDict["name"]! as! String
                        self.createMapMark(restLat, restLong, restName)
                    }
                }
            }
            catch {
                print("something went wrong")
            }
        }, userLatitute!, userLongiture!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ARViewController
        destination.listOfRestaurants = self.listOfRestaurants
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.arSwitch.isOn = false
    }
    
    func createMapMark(_ latitude: Double, _ longitude: Double, _ restaurantName: String) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let mapPoint = MKPointAnnotation()
        mapPoint.coordinate = coordinates
        mapPoint.title = restaurantName
        self.mainMap.addAnnotation(mapPoint)
    }
    
}

