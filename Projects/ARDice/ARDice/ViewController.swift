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

    var diceArray = [SCNNode]()
    
    
    var getRandomFloat: Float {
        Float.random(in: 1...4) * (Float.pi / 2)
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            // hitTest is depricated
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                let columns = hitResult.worldTransform.columns
                let x = Double(columns.3.x)
                let y = Double(columns.3.y)
                let z = Double(columns.3.z)
                let postion = SCNVector3(x, y, z)
                self.createDice(at: postion)
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Roll Again", style: .done, target: self, action: #selector(rollAll))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove All", style: .done, target: self, action: #selector(removeAll))
        
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
    
    private func createGrid() -> SCNMaterial{
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: gridName)
        return gridMaterial
    }
    
    private func createDice(at position: SCNVector3) {
        let diceScene = SCNScene(named: diceName)!
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            let positionAboveGrid = SCNVector3(position.x, position.y + diceNode.boundingSphere.radius, position.z)
            diceNode.position = positionAboveGrid
            
            diceArray.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            createRoleAnimation(with: diceNode)
            
        }
    }
    
    private func createRoleAnimation(with diceNode: SCNNode) {
        let radomX = getRandomFloat
        let randomY = getRandomFloat
        let x = CGFloat(radomX * 5)
        let z = CGFloat(randomY * 5)
        
        let action = SCNAction.rotateBy(x: x, y: 0, z: z, duration: 0.4)
        
        diceNode.runAction(action)
    }
    
    @objc func rollAll() {
        if !diceArray.isEmpty {
            diceArray.forEach {
                createRoleAnimation(with: $0)
            }
        }
        
    }
    
    @objc func removeAll() {
        if !diceArray.isEmpty {
            diceArray.forEach{
                $0.removeFromParentNode()
            }
        }
    }
    
}
