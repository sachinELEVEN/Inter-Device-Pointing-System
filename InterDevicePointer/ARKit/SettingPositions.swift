//
//  ViewController.swift
//  ARKitBasics
//
//  Created by Jared Davidson on 7/26/17.
//  Copyright © 2017 Archetapp. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PositioningControllerARKit: UIViewController, ARSCNViewDelegate {

    var sceneView = ARSCNView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add scene to view
        
        view.addSubview(sceneView)
                                    sceneView.translatesAutoresizingMaskIntoConstraints=false
                                  
                                 sceneView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:0).isActive = true
                                sceneView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: +0).isActive = true
                   sceneView.widthAnchor.constraint(equalToConstant: view.bounds.width/1).isActive = true
                   sceneView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/1).isActive = true
       // sceneView.clipsToBounds = true
        //sceneView.layer.cornerRadius = 20
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
       
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    //MY STUFF
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4.init(hitFeature.worldTransform) // <- if higher than beta 1, use just this -> hitFeature.worldTransform
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        createBall(hitPosition: hitPosition)
    }
    func createBall(hitPosition : SCNVector3) {
        
        
        print("Ball Added at ")
        print(hitPosition.x)
         print(hitPosition.y)
         print(hitPosition.z)
        
         //Adding the new Node to system Node
       let nodeName = "Device\(GlobalSystemNodes.nodes.count)"
        DMSystemNodes.handleNewNodes(nodeName: nodeName, position: hitPosition)
        
        
        
        let newBall = SCNSphere(radius: 0.01)
        let newBallNode = SCNNode(geometry: newBall)
        newBallNode.position = hitPosition
        self.sceneView.scene.rootNode.addChildNode(newBallNode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
