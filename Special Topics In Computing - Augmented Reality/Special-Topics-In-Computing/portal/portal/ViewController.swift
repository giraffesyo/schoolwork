//
//  ViewController.swift
//  portal
//
//  Created by Michael McQuade on 3/20/19.
//  Copyright © 2019 Michael McQuade. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var portalInScene: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        
        // Create a new scene
        //let scene = SCNScene()
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // we should do nothing if we're not dealing with an anchor that can be cast to ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // we'll match this plane's width and height to the anchors detected width and height
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        // Create a SCNPlane using the anchors heights and widths we grabbed from above
        let plane = SCNPlane(width: width, height: height)
        
        // color the plane so we can see it, it has an alpha of 0.4 so it doesn't block whats behind it
        plane.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.4)
        
        
        // if debugging: the material should be double sided otherwise theres a chance we wont be able to see it
        //plane.materials.first?.isDoubleSided = false
        
        // Create the plane node from the geometry that we created above
        let planeNode = SCNNode(geometry: plane)
        // set rendering order high
        planeNode.renderingOrder = 100
        // position the plane node at the new anchor's origin
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        // roate the plane by 90 degrees because it is by default normal to the anchor, causing it to be horizontal
        planeNode.eulerAngles.x = -.pi/2
        // add the planeNode we created to be a child of the node plane detection is managing
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // we're going to update the position and dimensions of our plane whenever the anchor is updated
        // again we should do nothing if we're not dealing with an anchor that can be cast to the appropriate ARPlaneAnchor type
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane else {
                return
        }
        
        // match this plane's width and height to the anchors detected width and height
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        // position the plane node at the new anchor's origin
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // dont handle non plane nodes
        guard anchor is ARPlaneAnchor else { return }
        // clean up nodes that arent in use anymore
        node.enumerateChildNodes {(node, _ ) in
            node.removeFromParentNode()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    @IBAction func viewWasTapped(_ sender: UITapGestureRecognizer) {
        //do nothing if the portal was already added to the scene
        if(portalInScene){
            return
        }
        // get the location of the tap
        let tappedLocation = sender.location(in: sceneView)
        // detect if the tap was on a plane (thanks Apple!) https://developer.apple.com/documentation/arkit/arscnview/2875544-hittest
        // hitTest() returns an array of SCNHitTestResult objects, we just want the first one (and only one in our case since there shouldnt be any other nodes besides the plane intersecting the ray and we're only testing for planes added by plane detection)
        guard let hitTestResult = sceneView.hitTest(tappedLocation, types: .existingPlaneUsingExtent).first else {
            print("tap wasnt on a plane")
            return
        }
        // i dont believe the following unwrap is necessary since we guaranteed our hit test result previously, but guarding just in case and would be interesting to know what cases would make this nil
        guard let planeAnchor = hitTestResult.anchor as? ARPlaneAnchor else {
            print("Plane Anchor not found in hit test result")
            return
        }
        print("tap was on a detected plane" )
        
        let translation = hitTestResult.localTransform.columns.3
        addPortalToScene(localTranslation: translation ,planeAnchor: planeAnchor)
    }
    
    
    func addPortalToScene( localTranslation translation: simd_float4, planeAnchor anchor: ARPlaneAnchor){
        
        guard let portalScene = SCNScene(named: "art.scnassets/archway.scn"), let portalNode = portalScene.rootNode.childNode(withName: "root", recursively: false) else {
            print("Failed to load portal node from portal scene")
            return
        }
        
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        portalNode.position = SCNVector3(x,y,z)
        // child node added is normal to plane so we have to rotate it around x
        //portalNode.eulerAngles.x = -.pi/2
        //rotate entire portal around z by 180 degrees
        //portalNode.eulerAngles.z = .pi
        //
        guard let planeNode = sceneView.node(for: anchor) else {
            print("not able to get plane node from anchor")
            return
        }
        print("Adding Portal at (\(x),\(y),\(z)) ")
        
        portalNode.position = SCNVector3(x,y,z)
        planeNode.addChildNode(portalNode)
    }
}
