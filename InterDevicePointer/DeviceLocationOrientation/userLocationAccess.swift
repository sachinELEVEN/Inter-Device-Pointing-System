////
////  userLocationAccess.swift
////  InterDevicePointer
////
////  Created by sachin jeph on 27/04/20.
////  Copyright © 2020 sachin jeph. All rights reserved.
////
//
import Foundation
import SwiftUI
import CoreLocation
//
//var locationsHistory = [[String:String]]()
////
struct AskForUserLocation : UIViewControllerRepresentable {


    func makeUIViewController(context:  UIViewControllerRepresentableContext<AskForUserLocation>) -> LocationAccess {
        return LocationAccess()
    }

    func updateUIViewController(_ uiViewController: LocationAccess, context:  UIViewControllerRepresentableContext<AskForUserLocation>) {

    }


   class LocationAccess : UIViewController,CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var rePoint = true

    override func viewDidLoad() {
          super.viewDidLoad()
        //Asks for user's location services
        locationManager.delegate = self
        
          locationManager.requestWhenInUseAuthorization()
        //Start the compass
         locationManager.startUpdatingHeading()
       
       }

   func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
           // print(newHeading.magneticHeading)
         //  print("Heading \(locationManager.heading?.description ?? "No Heading")")
    
    //Update pointing device
    //update global variable keeping track of heading // Bad practice
      
    let heading =  Float(self.locationManager.heading?.magneticHeading.description ?? "0" )!
    
    if (abs(heading-GloabalCurrentDeviceHeading)<1){
      //  print("not enough rotation")
        return
    }
    
    GloabalCurrentDeviceHeading = heading
    if self.rePoint && nodesAreAdded {
        
        self.rePoint = false
        
    GlobalUserGestureInteraction.setNodePointedByUser(heading : heading){
        //Now again pointing can be done
        self.rePoint = true
    }
    }
   
    
        }

   

    }
}






class LocationAccess : UIViewController,CLLocationManagerDelegate,ObservableObject {
 
var locationManager = CLLocationManager()
  
    @Published var locationsHistory = [[String:String]](){
        didSet{
            print("LocationsHistory updated")
        }
    }
    
    
override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.requestWhenInUseAuthorization()
    
    getLocation()
    
         }

    
  
   
    func getLocation(){
        if(CLLocationManager.locationServicesEnabled()) {
          guard let  currentLoc = locationManager.location else {
              print("Unable to get the location")
              return
          }
          let location = currentLoc.coordinate
            
            locationManager.startUpdatingHeading()
          
          print("Location Coordinates are")
            print(currentLoc.coordinate.longitude )
            print(currentLoc.coordinate.latitude )
         print("Heading \(locationManager.heading?.description ?? "No Heading")")
          
           
          
            
          let locDict :[String:String] = [
            "longitude": location.longitude.description ,
            "latitude": location.latitude.description ,
                     "heading": locationManager.heading?.trueHeading.description ?? "No Heading"
                 ]
                 
                 locationsHistory.append(locDict)
                 
          
          
        }

    }
    
    


func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("Location is updated")

    let location = manager.location?.coordinate
    print("Longitude \(location?.longitude)")
    print("Longitude \(location?.latitude)")
    print("Heading \(manager.heading?.description ?? "No Heading")")
    
    
    
    let locDict :[String:String] = [
        "longitude": location?.longitude.description ?? "Nothing",
        "longitude": location?.latitude.description ?? "Nothing",
        "heading": manager.heading?.trueHeading.description ?? "No Heading"
    ]
    
    locationsHistory.append(locDict)
    
    
}


}

//Done13
