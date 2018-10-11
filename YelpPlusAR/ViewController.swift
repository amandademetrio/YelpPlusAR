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

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var listOfRestaurants: NSArray = [];
    
    @IBOutlet weak var mainMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting Map
        mainMap.userTrackingMode = .follow
        //Setting up location manager
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self as CLLocationManagerDelegate
        let userLatitute = self.locationManager.location?.coordinate.latitude
        let userLongiture = self.locationManager.location?.coordinate.longitude

        YelpPlusARModel.getAllFood(completionHandler: { (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    self.listOfRestaurants = jsonResult["businesses"] as! NSArray
                    print(self.listOfRestaurants)
                }
            }
            catch {
                print("something went wrong")
            }
        }, userLatitute!, userLongiture!)
        
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    
}

