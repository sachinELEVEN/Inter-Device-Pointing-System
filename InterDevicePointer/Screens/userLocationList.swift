//
//  userLocationList.swift
//  InterDevicePointer
//
//  Created by sachin jeph on 28/04/20.
//  Copyright © 2020 sachin jeph. All rights reserved.
//

import Foundation
import SwiftUI


struct userLocationsList : View {
     @ObservedObject  var userLocation :LocationAccess
    var body : some View {
        VStack{
        //  UserLocationAccess()- To get Location Access
          
        Text("Inter Device Pointer")
             
              List(self.userLocation.locationsHistory,id:\.self){element in
                 
                self.cell(dict : element)
                  
              }
          
         Button(action:{
                   self.userLocation.getLocation()
               }){
                   Text("Refresh")
               }
               
          
          
          }
    }
    
    
    func cell(dict : [String:String])->some View {
           return VStack{
            
                Text(dict["longitude"]!)
                Text(dict["latitude"]!)
                Text(dict["heading"]!)
                           Divider()
              
                     
               
               
               
           }
       }
    
}



struct SystemNodeList : View {
     @ObservedObject  var systemNodes = GlobalSystemNodes
    var body : some View {
        ScrollView(.vertical,showsIndicators: false){
        VStack{
        
          
            Text("You have \(systemNodes.nodes.count) devices. See their information below")
            .fontWeight(.bold)
                   .padding()
            .background(CustomBlur(style: .systemUltraThinMaterial))
               .cornerRadius(10, antialiased: true)
                   .padding(.bottom,5)
            
            
            Text("User")
                .fontWeight(.bold)
                
            self.cell(self.systemNodes.userNode!).padding(.vertical)
            
                
            
             HStack      {
            UIScreenHeader(title : "Devices")
                VStack(alignment : .leading){
                    Divider()
                }
             
            }
              ForEach(self.systemNodes.nodes,id:\.id){node in
                 
                self.cell(node)
                  
              }
          
        
          
          
          }.padding(.horizontal)
    }
    }
    
    
    func cell(_ node : DMNode)->some View {
        return VStack(alignment : .leading){
            
            Text("Device Name \(node.nodeName)")
            Text("Position Vector \(node.position.Vx)i \(node.position.Vy)j \(node.position.Vz)k")
            
               
        }.padding()
          .background(CustomBlur(style: .systemUltraThinMaterial))
            .cornerRadius(10, antialiased: true)
            .padding(.vertical,5)
       }
    
}

//Done38
