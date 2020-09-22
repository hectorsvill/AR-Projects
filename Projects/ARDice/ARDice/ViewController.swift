//
//  ViewController.swift
//  ARDice
//
//  Created by Hector Villasano on 9/22/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private let diceName = "art.scnassets/diceCollada.scn"
    private let moonImageName = "art.scnassets/moon.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
        } else {
            print("ARWorldTrackingConfiguration not supported")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ViewController {
    private func configureViews() {
        sceneView.delegate = self
        
//        let cube = createCube()
//        let node = createNode(with: cube)
//        sceneView.scene.rootNode.addChildNode(node)
        
        
//        let sphere = createSphere()
//        let node = createNode(with: sphere)
//        sceneView.scene.rootNode.addChildNode(node)
        
        
        createDice()
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func createNode(with geometry: SCNGeometry) -> SCNNode {
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        node.geometry = geometry
        return node
    }
    
    private func createCube() -> SCNBox {
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGreen
        cube.materials = [material]
        return cube
    }
    
    private func createSphere() -> SCNSphere {
        let sphere = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: moonImageName)
        sphere.materials = [material]
        return sphere
    }
    
    private func createDice() {
        let diceScene = SCNScene(named: diceName)!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(0, 0, -0.1)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
}
