//
//  positioningScreen.swift
//  InterDevicePointer
//
//  Created by sachin jeph on 28/04/20.
//  Copyright © 2020 sachin jeph. All rights reserved.
//

import Foundation
import SwiftUI



struct PositioningScreen : View{
    
    var body  : some View {
        ZStack(alignment : .bottom){
            PresentPositioningARKitView()
            
            Text("Tap on the smart devices that you have added, update the device positions whenever you move your smart devices")
                .fontWeight(.bold)
                .padding()
         .background(CustomBlur(style: .systemUltraThinMaterial))
            .cornerRadius(10, antialiased: true)
                .padding(.bottom,5)
            //CustomBlur
            
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .background(Color.init("appdefaultbgcolor"))
    }

 struct PresentPositioningARKitView : UIViewControllerRepresentable {


func makeUIViewController(context:  UIViewControllerRepresentableContext<PresentPositioningARKitView>) -> PositioningControllerARKit {
    return PositioningControllerARKit()
}

func updateUIViewController(_ uiViewController: PositioningControllerARKit, context:  UIViewControllerRepresentableContext<PresentPositioningARKitView>) {

}

}


}
//Done7