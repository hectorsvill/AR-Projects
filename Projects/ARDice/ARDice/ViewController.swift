//
//  ViewController.swift
//  ARDice
//
//  Created by Hector Villasano on 9/22/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    private let diceName = "art.scnassets/diceCollada.scn"
    private let moonName = "art.scnassets/moon.jpg"
    private let gridName = "art.scnassets/grid.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported {
            worldTrackingConfiguration()
        } else {
            print("ARWorldTrackingConfiguration not supported")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            plane.materials = [createGrid()]
            planeNode.geometry = plane
            node.addChildNode(planeNode)
        } else {
            return
        }
    }
}

extension ViewController {
    private func configureViews() {
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
        
//        let cube = createCube()
//        let node = createNode(with: cube)
//        sceneView.scene.rootNode.addChildNode(node)
        
//        let sphere = createSphere()
//        let node = createNode(with: sphere)
//        sceneView.scene.rootNode.addChildNode(node)
        
        
//        createDice()
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func worldTrackingConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
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
        material.diffuse.contents = UIImage(named: moonName)
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
    
    private func createGrid() -> SCNMaterial{
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: gridName)
        return gridMaterial
    }
    
}
