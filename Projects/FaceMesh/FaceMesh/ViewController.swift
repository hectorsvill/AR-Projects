//
//  ViewController.swift
//  FaceMesh
//
//  Created by Hector Villasano on 9/30/20.
//

import ARKit
import RealityKit
import UIKit

class ViewController: UIViewController {
    lazy var arView = ARSCNView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ARFaceTrackingConfiguration.isSupported else { fatalError() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.addSubview(arView)
        arView.delegate = self
        setupARView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        arView.session.pause()
    }
    
    private func setupARView() {
        let scene = SCNScene()
        arView.scene = scene
        
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config)
        self.view = arView
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = renderer.device else { return nil }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else { return }
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
