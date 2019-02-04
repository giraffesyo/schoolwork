//
//  Plane.swift
//  hole-in-the-wall
//
//  Created by Michael McQuade on 2/4/19.
//  Copyright © 2019 Michael McQuade. All rights reserved.
//

import UIKit
import ARKit


// Moved this into its own class instead of a function so we can type check for Planes
class Plane: SCNNode {
    
    // https://developer.apple.com/documentation/arkit/building_your_first_ar_experience
    
    init(anchor: ARPlaneAnchor){
        super.init()
        self.updateGeometry(anchor: anchor)
        self.updatePosition(anchor: anchor)
        //self.simdPosition = anchor.center
        
        // the orientation is "up" in its coordinate space, which is normal to the plane,
        // rotate to make it parallel with the plane
        self.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        
    }
    
    func updateGeometry(anchor: ARPlaneAnchor){
        // get the anchor's width and height information
        let newWidth: CGFloat = CGFloat(anchor.extent.x)
        let newHeight: CGFloat = CGFloat(anchor.extent.z)
        // create a SCNPlane object with the width and height of the anchor
        self.geometry = SCNPlane(width: newWidth, height: newHeight)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        // If you don't render both sides and it ends up that the material is facing the other way
        // then you will be left with nothing visible ( not super necessary but very useful
        // to see what is going on
        self.geometry?.firstMaterial?.isDoubleSided = true
    }
    
    func updatePosition(anchor: ARPlaneAnchor)
    {
        // set the position of the plane to be at the position of the anchor
        self.simdPosition = anchor.center    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
