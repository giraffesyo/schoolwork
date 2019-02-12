//
//  ViewController.swift
//  hole-in-the-wall
//
//  Created by Michael McQuade on 2/4/19.
//  Copyright © 2019 Michael McQuade. All rights reserved.
//

import UIKit
import ARKit

// make view controller a delegate so that we can access AR callbacks
class ViewController: UIViewController, ARSCNViewDelegate {
    
    var firstPlane: Plane?
    var planeCount = 0 // just important so we can see when we have our first plane
    var holeNode: SCNNode = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.session.run(configuration)
        sceneView.delegate = self
        let scene : SCNScene =  SCNScene(named: "Assets.scnassets/hole.scn")!
        holeNode = scene.rootNode.childNodes.first!
        sceneView.scene = scene
        holeNode.removeFromParentNode()
    }
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // we should do nothing if we're not dealing with an anchor that can be cast to ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // create our planeNode using the transform information of the plane anchor
        let planeNode = Plane(anchor: planeAnchor)
        
        if(planeCount == 0) {
            
            print("Found first plane at \(planeNode.position)")
            self.firstPlane = planeNode
            print("setting hole with mario's anchor node to position \(planeAnchor.center), camera position is \(sceneView.session.currentFrame!.camera.transform)")
            //holeNode.simdPosition = planeAnchor.center
            
            
      
            
            
            //holeNode.scale = SCNVector3(1, 1,1)
            
            
            // when i add it to a child of the plane, it moves with the phone
            planeNode.addChildNode(holeNode)
            
            //when i add it as a child of the scene, it does not move
            holeNode.simdTransform = planeAnchor.transform
            // the hole will be positioned normal to the plan so we need to rotate it
            //holeNode.eulerAngles = SCNVector3(-Double.pi, 0, 0)
            //flip on z axis ( so that it mario is right side up)
            holeNode.eulerAngles = SCNVector3(Double.pi,0,-Double.pi)
            sceneView.scene.rootNode.addChildNode(holeNode)
            print("adding hole with mario to scene")
        }
        
        // add node
        node.addChildNode(planeNode)
        self.planeCount += 1
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // again we should do nothing if we're not dealing with an anchor that can be cast to the appropriate ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes.first as? Plane else {return}
        planeNode.updateGeometry(anchor: planeAnchor)
        planeNode.updatePosition(anchor: planeAnchor)
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // dont handle non plane nodes
        guard anchor is ARPlaneAnchor else { return }
        // clean up nodes that arent in use anymore
        node.enumerateChildNodes {(node, _ ) in
            node.removeFromParentNode()
        }
    }
   
}
