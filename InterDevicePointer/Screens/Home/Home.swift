//
//  ContentView.swift
//  InterDevicePointer
//
//  Created by sachin jeph on 27/04/20.
//  Copyright © 2020 sachin jeph. All rights reserved.
//

import SwiftUI


struct Home: View {
   
   @State var addNewDeviceScreen = false
    
    var body: some View {
   NavigationView {
       VStack{
        
        
        HStack{
            Text("Home")
                           .fontWeight(.black)
                           .font(.largeTitle)
                .padding(.leading)
                .padding(.top,40)
            Spacer()
        }
        
        ScrollView(.vertical,showsIndicators:false){
            
          headerText()
                    
           HStack{
              
            
            NavigationLink(destination : PositioningScreen(),isActive: self.$addNewDeviceScreen){
                Button(action:{self.addNewDeviceScreen = true}){
                               UILabel(text : "Add New devices",buttonFGColor: .white)
                           }
            }
           
                
            UILabel(text : "Turn off Bedroom Lights",buttonFGColor: .white, buttonBGColor: .blue)
                
            }
            
            HStack{
                NavigationLink(destination : SystemNodeList()){
                    UILabel(text : "See All Devices",buttonFGColor: .white, buttonBGColor: .purple)
                                         
                           }
                
                Spacer()
            }
            
              AskForUserLocation()
            
        } .padding()
            
        
        
     
        
   
       }.background(Color.init("appdefaultbgcolor"))
    .navigationBarTitle("")
    .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
        
    }
    
}



func headerText()->some View{
    return VStack{
        Text("Start building your smart home by adding lights, fans, and other smart accessories")
                      .fontWeight(.bold)
                      .font(.headline)
                      .frame(height:50)
                      .padding(.bottom)
                      
    }
}

struct UILabel:View{
    var text : String
    var imgName : String = ""
    var buttonFGColor = Color.primary
    var buttonBGColor = Color.orange
    var radius : CGFloat = 10
    var width = fullWidth/3.2
    var height = fullWidth/3.2
  
    var body : some View{
    VStack{
        Text(text)
            .fontWeight(.bold)
    }.frame(width:self.width,height:self.height)
        .modifier(bgDepthEffect(color:self.buttonBGColor))
        .foregroundColor(self.buttonFGColor)
        //.padding()
        //.background(self.buttonBGColor)
        //.cornerRadius(self.radius)
        //.padding(.horizontal)
        
}
}
//Done23
