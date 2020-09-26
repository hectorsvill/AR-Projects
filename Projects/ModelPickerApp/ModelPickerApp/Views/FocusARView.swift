//
//  FocusARView.swift
//  ModelPickerApp
//
//  Created by Hector Villasano on 9/26/20.
//

import ARKit
import RealityKit
import FocusEntity

class FocusARView: ARView {
    var focusEntity: FocusEntity?
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.setupConfig()
        self.focusEntity = FocusEntity(on: self, style: .classic)
    }
    
    func setupConfig() {
        let config = ARWorldTrackingConfiguration()
        
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        // Check if device has LiDAR Scanner
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)        
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusARView: FocusEntityDelegate {
    func toTrackingState() {
        print("tracking")
    }
    func toInitializingState() {
        print("initializing")
    }
}
