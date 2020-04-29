//
//  DMVectorSystem.swift
//  InterDevicePointer
//
//  Created by sachin jeph on 29/04/20.
//  Copyright © 2020 sachin jeph. All rights reserved.
//

import Foundation

class Vector3{
   
    
    init(source : DMNode?, destination : DMNode?,isVectorNTN : Bool = true){
        self.source = source//User's device/node is always the source
      //Vector should have its tail at source and head at destination
        self.destination = destination
        self.isVectorNTN = isVectorNTN
        
        //Setup the x,y,z of the vector below
        guard let source = source, let destination = destination else {
            print("Vector Source and Nodes are nil")
            return
        }
        self.x = destination.position.Vx - source.position.Vx
        self.y = destination.position.Vy - source.position.Vy
        self.z = destination.position.Vz - source.position.Vz
    }
    
    init(vector : Vector3){
        self.x = vector.x
         self.y = vector.y
         self.z = vector.z
         self.source = vector.source
         self.destination = vector.destination
         self.isVectorNTN = vector.isVectorNTN
    }
    
    var x : Float = 0
    var y : Float = 0
    var z : Float = 0
    
    var source : DMNode?
    var destination : DMNode?
    var isVectorNTN : Bool//NTN means Node To Node, only other type of vector is UIV(User Interaction Vector)
    
    
    ///Creates a unit vector in same direction as self
    private static func getUnitVector(_ vector : Vector3)->Vector3{
      
       let unitVector = Vector3(vector: vector)
        let vectorMagnitude = powf((powf(vector.x, 2) + powf(vector.y, 2) + powf(vector.z, 2)),(1/2))
       
       
        unitVector.x /= vectorMagnitude
        unitVector.y /= vectorMagnitude
        unitVector.z /= vectorMagnitude
      
       return unitVector
    }
    
    
    ///Returns the cos(Theta) where Theta is the angle between both vectors
    public static func findCosBWVectors(_ vector1 : Vector3,_ vector2 : Vector3)->Float{
 
      
        let unitVector1 = getUnitVector(vector1)
       
      
        let unitVector2 = getUnitVector(vector2)
       
        //calculating dot product
        let dotProduct = unitVector1.x*unitVector2.x + unitVector1.y*unitVector2.y + unitVector1.z*unitVector2.z
       
    
    //since magnitude of unit vector is 1. Porduct of magnitude of both unit vector will also be 1
        
        let cos = dotProduct
        
        return cos
    }
    
}


class UserGestureInteraction : ObservableObject{
   
    /*How to use this class
    Create class instance
    Whenver you want to get Node pointed by device
    call .createNTUVectors() method
    call .setupUserInteractionVector() method
    After Above setup steps
    call .getNodePointedByUser() to get the pointed node
    */
    
  private  func setupUserInteractionVector(currentHeading:Float){
        //User interaction vector does not have any source or destination. Here we are concerned only about its direction
        //Creating User Interaction vector based on the heading(Direction user is facing)
      
        //currentHeading is the angle with NORTH
        
        //STEP1 - Creating UIV wrt to NORTH Heading(Taking NORTH as +ve Y Axes)
        //STEP2 - After Getting UIV -> Rotate H(saved when initial devices were setup) degrees anticlockwise -> to align the UIV with rest of the system
       
        
        
        let UIV = Vector3(source: nil, destination: nil,isVectorNTN: false)
        UIV.x = sinf(currentHeading *  Float.pi / 180)
        UIV.y = cosf(currentHeading *  Float.pi / 180)
        
        
        //Rotating Vector ( H-currentHeading degress. H degrees - heading when initial device mapping was done, saved at that time)
    let initialReadingHeading : Float = UserDefaults.standard.object(forKey: "initialheading") as! Float
        let rotationDegrees : Float = 360-initialReadingHeading //Add rotation degrees here
        let a = UIV.x
        let b = UIV.y
  
    print("Initial Head")
   print(initialReadingHeading)
        
        UIV.x = a*cosf(rotationDegrees * Float.pi / 180) + b*sinf(rotationDegrees *  Float.pi / 180)
        UIV.y = -a*sinf(rotationDegrees *  Float.pi / 180) + b*cosf(rotationDegrees *  Float.pi / 180)
      
    print("uivstart")
    print(UIV.x)
    print(UIV.y)
    print("UIVends")
        
        self.userInteractionVector = UIV
        
    }
    
    ///User interaction vector does not have any source or destination. Here we are concerned only about its direction
    var userInteractionVector : Vector3? = nil
    var NTUVectors = [Vector3]()
    @Published var currentPointedNode : DMNode? = nil
    
    
    ///Gets the most appropriate Node To User Vector( by appropriate we mean to which node the userInteractionVector is pointing)
  private  func getMostAppropriateNTUVector(NTUVectors : [Vector3])->Vector3?{
     
    var mostAptNTUVector : Vector3? = nil
    
    //Since  cos varies from -1 to 1, we want the vector that has the max cos value(idealy = 1), since then
    //the angle between userInteractionVector and NTUVector will be 0 degrees
    
    //Finding Cos(Theta) b/w userInteractionVector and each of NTUVectors
    var maxCos : Float = -2;
   
    
   for NTUVector in NTUVectors{
    
      let cos =  Vector3.findCosBWVectors(userInteractionVector!, NTUVector)
       print("Cos is \(cos)")
    if cos > maxCos {
           maxCos = cos
            mostAptNTUVector = NTUVector
        }
    
    }
    
    
    return mostAptNTUVector
    }
    
   private func getNodePointedByUser()->DMNode?{
        
        let aptVector = getMostAppropriateNTUVector(NTUVectors: self.NTUVectors)
      
        
        return aptVector?.destination ?? nil
        
       
    }
    
   //Creates Node To User Vectors using Node
   private func createNTUVectors(userNode : DMNode,systemNodes : [DMNode]){
        
        
        for systemNode in systemNodes{
            
            let NTUVector = Vector3(source: userNode, destination: systemNode, isVectorNTN: true)
            self.NTUVectors.append(NTUVector)
            
        }
        
        
        //PRINTING NTUVectors
        for vec in self.NTUVectors{
             print("NTU Vector \(vec.x)i \(vec.y)j \(vec.z)k")
        }
        
    }
    
  
    //Sets the node that is currenly being pointed by the device
    func setNodePointedByUser(heading : Float,completion : @escaping ()->()){
        
        guard let userNode = GlobalSystemNodes.userNode else {
            print("User Node is not Setup")
             completion()
            return
        }
        
        if GlobalUserGestureInteraction.NTUVectors.count == 0 {
        GlobalUserGestureInteraction.createNTUVectors(userNode: userNode, systemNodes: GlobalSystemNodes.nodes)
        }
        
        let currentHeading : Float = heading
        GlobalUserGestureInteraction.setupUserInteractionVector(currentHeading: currentHeading)
        
     guard let nodeRec = GlobalUserGestureInteraction.getNodePointedByUser()
        else {
            print("Error - No Node is being returned")
             completion()
            return
        }
        
       // print("Node being Pointed is found")
        print("Node Name \(nodeRec.nodeName)")
       //  print("Position Vector \(nodeRec.position.Vx)i \(nodeRec.position.Vy)j \(nodeRec.position.Vz)k")
        
        self.currentPointedNode = nodeRec
        completion()
    }
    
    
}

//Done109
