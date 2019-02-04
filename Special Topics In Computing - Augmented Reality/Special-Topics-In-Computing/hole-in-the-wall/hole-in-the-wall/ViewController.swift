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
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.session.run(configuration)
        sceneView.delegate = self
        
    }
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // we should do nothing if we're not dealing with an anchor that can be cast to ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        // create our planeNode using the transform information of the plane anchor
        let planeNode = Plane(anchor: planeAnchor)
        // add node
        node.addChildNode(planeNode)
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
    
    
    
    
    //    // this is called when a node is added
    //    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    //        // lets ignore all nodes that are added except those that are found
    //        // by the vertical plane detection
    //        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    //        // at this point we can guarantee that planeAnchor is an indeed a vertical plane
    //
    //        // create a Plane instance with our plane anchor
    //        let plane = Plane(anchor: planeAnchor)
    //        // color the plane blue
    //        // Add the plane to the scene
    //        node.addChildNode(plane)
    //        print("plane added")
    //
    //    }
    //
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //        // we need to update our plane information with the new anchor information
    //        // but, first lets make sure that we're dealing with a plane anchor
    //        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    //        guard let plane = node.childNodes[0] as? Plane else { return }
    //
    //        let newWidth: CGFloat = CGFloat(planeAnchor.extent.x)
    //        let newHeight: CGFloat = CGFloat(planeAnchor.extent.z)
    //        let newPosition: simd_float3 = planeAnchor.center
    //
    //        plane.geometry = SCNPlane(width: newWidth, height: newHeight)
    //        plane.simdPosition = newPosition
    //        print("plane updated")
    //
    //    }
    //
    //    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    //        // dont handle non plane nodes
    //        guard anchor is ARPlaneAnchor else { return }
    //        // clean up nodes that arent in use anymore
    //        node.enumerateChildNodes {(node, _ ) in
    //            node.removeFromParentNode()
    //        }
    //    }
    /*
     func createHole(anchor: ARPlaneAnchor) -> SCNNode {
     // we'll make this one meter wide and one meter high
     let holeNode = SCNNode(geometry: SCNPlane(width: 100.0, height: 100.0))
     // we'll put the hole at the center of the plane anchor we're passed in
     
     
     // should be parallel to the plane
     holeNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
     //set the material to the image of the hole
     let holeImage = #imageLiteral(resourceName: "hole")
     holeNode.geometry?.firstMaterial?.diffuse.contents = holeImage
     
     return holeNode
     }*/
    
    
}

