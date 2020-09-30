//
//  ViewController.swift
//  roboAnimoji
//
//  Created by Hector Villasano on 9/30/20.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet var arView: ARView!
    var roboAnchor: RoboExperience.Animoji!
    var allowsTalking = true
    var mouth: Entity!
    var mouthModel: ModelEntity!
    var eyeLeft: Entity!
    var eyeRight: Entity!
    var browLeft: Entity!
    var browRight: Entity!
    var lastBrowLeftValue: Float = 0.0
    var lastBrowRightValue: Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config)
        arView.session.delegate = self
        
        roboAnchor = try! RoboExperience.loadAnimoji()
        arView.scene.anchors.append(roboAnchor)
        
        configureEntities()
    }
    
    private func configureEntities() {
        mouth = roboAnchor.findEntity(named: "mouth")
        mouthModel = mouth.children.first as? ModelEntity
        
        eyeLeft = roboAnchor.findEntity(named: "eyeLeft")
        eyeRight = roboAnchor.findEntity(named: "eyeRight")
        
        browLeft = roboAnchor.findEntity(named: "browLeft")
        browRight = roboAnchor.findEntity(named: "browRight")
        
        roboAnchor.actions.finishedTalking.onAction = { _ in
            self.allowsTalking = true
        }
    }
    
}

extension ViewController: ARSessionDelegate{
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors {
            if let faceAnchor = anchor as? ARFaceAnchor {
                let blendShapes = faceAnchor.blendShapes
                
                if let jawValue = blendShapes[.jawOpen]?.floatValue,
                   let eyeLeftValue = blendShapes[.eyeBlinkLeft]?.floatValue,
                   let eyeRightValue = blendShapes[.eyeBlinkRight]?.floatValue,
                   let browLeftValue = blendShapes[.browOuterUpLeft]?.floatValue,
                   let browRightValue = blendShapes[.browOuterUpRight]?.floatValue {
                    
                    
//                    print(jawValue, eyeLeftValue, eyeRightValue, browLeftValue, browRightValue)
                    
                    if (browLeftValue >= 0.5 || browRightValue >= 0.5) && allowsTalking && lastBrowLeftValue < 0.5 && lastBrowRightValue < 0.5 {
                        allowsTalking = false
                        roboAnchor.notifications.talk.post()
                    }
                    
                    lastBrowLeftValue = browLeftValue
                    lastBrowRightValue = browRightValue

                    mouth.scale.z = jawValue * 0.4 + 1.0
                    mouth.scale.x = jawValue * 0.4 + 1.0
                    mouthModel.model?.materials = [SimpleMaterial(color: .init(red: CGFloat(jawValue + 0.35), green: 0.35, blue: 0.35, alpha: 1), isMetallic: false)]

                    eyeLeft.scale.z = 1.0 - eyeLeftValue
                    eyeRight.scale.z = 1.0 - eyeRightValue
                    
                    browLeft.position.z = -0.075 - browLeftValue * 0.05
                    browRight.position.z = -0.075 - browRightValue * 0.05
                    
                }
            }
        }
        
        
    }
}
