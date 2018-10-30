//
//  ARViewController.swift
//  YelpPlusAR
//
//  Created by Amanda Demetrio on 10/12/18.
//  Copyright © 2018 Amanda Demetrio. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit
import ARCL
import CoreData

class MainARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    //this will be loaded with the current places list
    var listOfPlaces: NSArray = []
    var arLocationManager: CLLocationManager = CLLocationManager()
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        for place in self.listOfPlaces {
            let placeDict = place as! NSDictionary
            let placeCoord = placeDict["coordinates"] as! NSDictionary
            let lat = placeCoord["latitude"]! as! Double
            let long = placeCoord["longitude"]! as! Double
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            print(coordinate)
            let location = CLLocation(coordinate: coordinate, altitude: 0)
            let image = UIImage(named: "location")
            
            let annotationNode = LocationAnnotationNode(location: location, image: image!)
            
            let placeName = placeDict["name"] as! String
            let textGeometry = SCNText()
            textGeometry.string = placeName
            textGeometry.font = UIFont(name: "Arial", size: 3)
            textGeometry.firstMaterial?.diffuse.contents = UIColor.black
            
            let textNode = SCNNode(geometry: textGeometry)
            textNode.position = SCNVector3(-15.0, -15.5, 2.0)
            
            annotationNode.addChildNode(textNode)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneLocationView.pause()
        //removing all nodes when scene disapeers, check if this works
        sceneLocationView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
            print("removed child nodes")
        }
        //store users last known location
    }
}
