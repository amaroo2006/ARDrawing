//
//  ViewController.swift
//  ARDrawing
//
//  Created by Ansh Maroo on 7/3/19.
//  Copyright © 2019 Mygen Contac. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var draw: UIButton!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        print("rendering")
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let transform = pointOfView.transform
        
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        
        let currentPositionOfCamera = orientation + location
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
                sphereNode.position = currentPositionOfCamera
                
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                
                print("draw button being pressed")
            }
            else {
                
                
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentPositionOfCamera
                
                self.sceneView.scene.rootNode.enumerateChildNodes {(node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
        
        
    }


}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z )
}
