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
    // Redoing without the custom Plane class
    //    var firstPlane: Plane?
    var planeCount = 0 // just important so we can see when we have our first plane
    var holeNode: SCNNode = SCNNode()
    var holeAdded: Bool = false
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.session.run(configuration)
        sceneView.delegate = self
        
        // extract the holeNode from the scene and save it into our view controller  instance variable 'holeNode'
        let scene : SCNScene =  SCNScene(named: "Assets.scnassets/hole.scn")!
        holeNode = scene.rootNode.childNodes.first!
        sceneView.scene = scene
        holeNode.removeFromParentNode()
    }
    
    
    
    
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
        //
        //        if(planeCount == 0) {
        //
        //            print("Found first plane at \(planeNode.position)")
        //            self.firstPlane = planeNode
        //            print("setting hole with mario's anchor node to position \(planeAnchor.center), camera position is \(sceneView.session.currentFrame!.camera.transform)")
        //            //holeNode.simdPosition = planeAnchor.center
        //
        //
        //
        //
        //
        //            //holeNode.scale = SCNVector3(1, 1,1)
        //
        //
        //            // when i add it to a child of the plane, it moves with the phone
        //            planeNode.addChildNode(holeNode)
        //
        //            //when i add it as a child of the scene, it does not move
        //            holeNode.simdTransform = planeAnchor.transform
        //            // the hole will be positioned normal to the plan so we need to rotate it
        //            //holeNode.eulerAngles = SCNVector3(-Double.pi, 0, 0)
        //            //flip on z axis ( so that it mario is right side up)
        //            holeNode.eulerAngles = SCNVector3(Double.pi,0,-Double.pi)
        //            sceneView.scene.rootNode.addChildNode(holeNode)
        //            print("adding hole with mario to scene")
        //        }
        //
        // increment plane counter (not using this in current branch)
        self.planeCount += 1
        
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
    
    @IBAction func sceneTapped(_ sender: UITapGestureRecognizer) {
        // do nothing if we already added the hole to the scene
        if(holeAdded) {
            print("tap detected but hole was already added")
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
        
        
//         translation is in the last column of the local transform
//        let translation = hitTestResult.worldTransform.columns.3
        // i dont believe the following unwrap is necessary since we guaranteed our hit test result previously, but guarding just in case and would be interesting to know what cases would make this nil
        guard let planeAnchor = hitTestResult.anchor as? ARPlaneAnchor else {
            print("Plane Anchor not found in hit test result")
            return
        }
        print("tap was on a detected plane" )
        
        //        let anchor = ARAnchor(transform: hitTestResult.worldTransform)
//        addHole(worldTransform: translation)
//        hitTestResult.anchor.
        guard let holeScene = SCNScene(named: "Assets.scnassets/hole.scn"), let holeNode2 = holeScene.rootNode.childNode(withName: "hole", recursively: false) else {
            print("Failed to load hole node from hole scene")
            return
        }
        let translation = hitTestResult.localTransform.columns.3
        let x = translation.x
        let y = translation.y
        let z = translation.z
        print("Adding hole at (\(x),\(y),\(z)) ")

        holeNode2.position = SCNVector3(x,y,z)
        // child node added is normal to plane so we have to rotate it around x
        holeNode2.eulerAngles.x = -.pi/2
        //rotate entire hole around z by 180 degrees so that mario is face up
        holeNode2.eulerAngles.z = .pi
//
        guard let planeNode = sceneView.node(for: planeAnchor) else {
            print("not able to get plane node from anchor")
            return
        }
        print("Adding hole to scene")
        holeNode2.position = SCNVector3(x,y,z)
        planeNode.addChildNode(holeNode2)
    }
    
    
    
    // FUTURE USE:
    // Apple has a great write up on user control https://github.com/gao0122/ARKit-Example-by-Apple
    
    
    func addHole( worldTransform translation: simd_float4){
        // position our hole using the local translation and the anchor for the plane that was tapped
        // the position vector is the fourth column of a transform matrix
        guard let holeScene = SCNScene(named: "Assets.scnassets/hole.scn"), let holeNode2 = holeScene.rootNode.childNode(withName: "hole", recursively: false) else {
            print("Failed to get hole node from hole scene")
            return
        }
        
        let x = translation.x
        let y = translation.y
        let z = translation.z
        print("Adding mario at (\(x),\(y),\(z)) ")
        
        holeNode2.position = SCNVector3(x,y,z)
        
        sceneView.scene.rootNode.addChildNode(holeNode2)
        
    }
    
}
