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
        let width: CGFloat = CGFloat(anchor.extent.x)
        let height: CGFloat = CGFloat(anchor.extent.z)
        self.geometry = SCNPlane(width: width, height: height)
        // set position of plane to be at center of the ARPlaneAnchor

        self.simdPosition = anchor.center
        
        // the orientation is "up" in its coordinate space, which is normal to the plane,
        // rotate to make it parallel with the plane
        self.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
