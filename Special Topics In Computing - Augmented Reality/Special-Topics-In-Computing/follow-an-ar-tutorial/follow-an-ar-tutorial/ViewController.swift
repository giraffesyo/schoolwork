//
//  ViewController.swift
//  follow-an-ar-tutorial
//
//  Created by Michael McQuade on 1/21/19.
//  Copyright © 2019 Michael McQuade. All rights reserved.
//

import UIKit
import ARKit // we need this to use AR features, otherwise our types won't be recognized (e.g. ARSCNView

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    // config which holds the correspondence between the real world and the virtual 3d plane that we will be working with
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup options that allow drawing debug info onto scene
        // we're drawing the feature points and the 3d world's origin/coordinate system.
        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    
        // start the sceneview with our configuration
        sceneView.session.run(config)
    }
    
    
}

