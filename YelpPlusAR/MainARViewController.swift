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

class MainARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    //this will be loaded with the current places list
    var listOfPlaces: NSArray = []
    @IBOutlet weak var mapSwitch: UISwitch!
    
    var sceneLocationView = SceneLocationView()
    
    @IBAction func mapSwitchPressed(_ sender: UISwitch) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSwitch.isOn = true
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
            let image = UIImage(named: "cosmopolitan")
            
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
    }
}

//open class LocationTextNode: LocationNode {
//    public let label: UILabel
//    public let textNode: SCNNode
//    public var scaleRelativeToDistance = false
//
//    public init(location: CLLocation?, label: UILabel) {
//        self.label = label
//        let plane = SCNPlane(width: label.size.width / 100, height: label.size.height / 100)
//        plane.firstMaterial!.diffuse.contents = label
//        plane.firstMaterial!.lightingModel = .constant
//
//        textNode = SCNNode()
//        textNode.geometry = plane
//
//        super.init(location: location)
//
//        let billboardConstraint = SCNBillboardConstraint()
//        billboardConstraint.freeAxes = SCNBillboardAxis.Y
//        constraints = [billboardConstraint]
//
//        addChildNode(textNode)
//   }
//}
