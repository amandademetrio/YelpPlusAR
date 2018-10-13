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

class MainARViewController: UIViewController {
    
    //this will be loaded with the current restaurant list
    var listOfRestaurants: NSArray = []
    var ARlocationManager: CLLocationManager = CLLocationManager()
    var restNodes: [MKMapPoint] = []
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var mapSwitch: UISwitch!
    
    @IBAction func mapSwitchPressed(_ sender: UISwitch) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARlocationManager.delegate = self
        mapSwitch.isOn = true
        
        //setting up sceneView
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        
        //setting up node
        let circleNode = createSphereNode(with: 0.2, color: .blue)
        circleNode.position = SCNVector3(0, 0, -1) // 1 meter in front
        sceneView.scene.rootNode.addChildNode(circleNode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravityAndHeading
        sceneView.session.run(config)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
    }
    
    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode {
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
    }
}

extension MainARViewController: ARSCNViewDelegate {
    
}

extension MainARViewController: CLLocationManagerDelegate {
    
}
