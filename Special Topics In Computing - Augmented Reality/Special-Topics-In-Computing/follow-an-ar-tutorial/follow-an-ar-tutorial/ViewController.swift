//
//  ViewController.swift
//  follow-an-ar-tutorial
//
//  Created by Michael McQuade on 1/21/19.
//  Copyright © 2019 Michael McQuade. All rights reserved.
//

import UIKit
import ARKit // we need this to use AR features, otherwise our types won't be recognized (e.g. ARSCNView

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    // config which holds the correspondence between the real world and the virtual 3d plane that we will be working with
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup options that allow drawing debug info onto scene
        // we're drawing the feature points and the 3d world's origin/coordinate system.
        sceneView.debugOptions = [ ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        
        // only look for horizontal planes
        config.planeDetection = .horizontal
        
        // start the sceneview with our configuration
        sceneView.session.run(config)
        
        // set our view controller as the sceneview delegate
        sceneView.delegate = self
        
        // code for adding capsule to scene
        /*
         let capsuleNode = SCNNode(geometry: SCNCapsule(capRadius: 0.03, height: 0.1))
         //0.1 meter left of the world origin, 0.1 meter above the world origin, and 0.1 meter away from the world origin
         capsuleNode.position = SCNVector3(0.1, 0.1, -0.1)
         
         // set material of the capsule to blue
         capsuleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
         //rotate capsule 90 degrees
         capsuleNode.eulerAngles = SCNVector3(0,0, Double.pi/2)
         
         // add node to root node of the scene
         sceneView.scene.rootNode.addChildNode(capsuleNode)
         */
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // we should do nothing if we're not dealing with an anchor that can be cast to ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // create our floorNode with this anchor by calling createFloorNode
        let planeNode = createFloorNode(anchor: planeAnchor)
        // add node
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // again we should do nothing if we're not dealing with an anchor that can be cast to the appropriate ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        // delete all floor nodes, as we're going to readd the floor since the node has been changed
        node.enumerateChildNodes({(node, _ ) in node.removeFromParentNode()
        })
        
        let planeNode = createFloorNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // dont handle non plane nodes
        guard anchor is ARPlaneAnchor else { return }
        // clean up nodes that arent in use anymore
        node.enumerateChildNodes {(node, _ ) in
            node.removeFromParentNode()
        }
    }
    
    func createFloorNode (anchor: ARPlaneAnchor) -> SCNNode {
        // define floorNode as a generic sc node with the geometry of a plane. The width and height will be defined by the parameters anchor point. Anchor points get joined together when they are detected to be as part of the same object, thus we get an anchor node that can be very large if we are dealing with an object that ARKit determines to be very large.
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        // set position of node, with y locked at 0
        floorNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        // make floor blue
        //floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        //use lava texture to make floor hot
        let lava: UIImage = #imageLiteral(resourceName: "lava")
        floorNode.geometry?.firstMaterial?.diffuse.contents = lava
        // render both sides of node (probably not necessary since it is a floor)
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        // rotate it around x so its horizontal
        floorNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        
        return floorNode
    }
    
    
}

// not following the tutorials suggestion of extending view controller...
