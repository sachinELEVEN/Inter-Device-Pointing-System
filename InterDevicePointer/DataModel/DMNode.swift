//
//  DMVectors.swift
//  InterDevicePointer
//
//  Created by sachin jeph on 28/04/20.
//  Copyright © 2020 sachin jeph. All rights reserved.
//

import Foundation
import ARKit



//Node refers to each device in the smart home system
class DMNodeCoordinates : ObservableObject {
    
    init(position : SCNVector3){
        self.Vx = position.x
               self.Vy = -(position.z)//since ARKit Mapping System takes -ve Z Axes IN front of camera
               self.Vz = position.y//Since in scene kit height is in Y axes
    }
    
   //Custom 3D Space System - coordinates
  // Get by ARKit
    @Published var Vx : Float = 0
    @Published var Vy : Float = 0
    @Published var Vz : Float = 0
    
    //Real World GPS - Coordinates
  /*  @Published var Rx : Float = 0
   @Published  var Ry : Float = 0
    @Published var Rz : Float = 0*/
}

//All smart devices and user devices are nodes
class DMNode  {
    internal init(nodeName: String, position: DMNodeCoordinates) {
        self.nodeName = nodeName
        self.position = position
    }
    
    
    var id = UUID.init().uuidString
    var nodeName : String
    var isNodeUser = false
    var position : DMNodeCoordinates
    
}

class DMSystemNodes : ObservableObject{
  @Published  var nodes = [DMNode]()
    @Published var userNode : DMNode? = nil
    var id = UUID.init().uuidString
    
    func addNode(newNode : DMNode){
        //First node will be userNode and the rest will be other nodes(systemNodes)
        
        if self.userNode == nil {
            //Save device's heading
            //Heading when initial map is layed out
            UserDefaults.standard.set(GloabalCurrentDeviceHeading, forKey: "initialheading")
            self.userNode = newNode
            
        }else{
            self.nodes.append(newNode)
        }
        
       
    }
  
    
    
    
    /// Handles new nodes created completely
    /// - Parameter position: Position where the node is placed received from ARKit
    static func handleNewNodes(nodeName: String,position:SCNVector3){
        
       //Creating now node coordinates
        let newNodeCoordinates = DMNodeCoordinates(position:position)
            
        //create a new node
             let newNode = DMNode(nodeName: nodeName, position: newNodeCoordinates)
        
        //Adding newly created node to GLSystemNodes
        GlobalSystemNodes.addNode(newNode: newNode)
    }
    
}
//Done39

/*
  -0.27676976i 0.058604397
  -0.14725803i 0.2225008j
 0.09499237i 0.07326437j
*/
